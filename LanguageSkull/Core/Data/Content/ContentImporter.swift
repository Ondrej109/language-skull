import Foundation
import SwiftData
import OSLog

@MainActor
final class ContentImporter {
    private let modelContext: ModelContext
    private let logger = Logger(subsystem: "com.languageskull.app", category: "ContentImporter")

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func validate(urls: [URL]) throws -> ContentValidationResult {
        let payload = try parsePayload(from: urls)
        var warnings: [String] = []
        if payload.grammarSections.isEmpty {
            warnings.append("No grammar sections found — grammar activities will be empty until grammar content is added.")
        }
        return ContentValidationResult(
            languageCode: payload.languageCode,
            languageName: payload.languageName,
            wordCount: payload.words.count,
            phraseCount: payload.phrases.count,
            grammarSectionCount: payload.grammarSections.count,
            warnings: warnings
        )
    }

    func importContent(
        at urls: [URL],
        mode: ContentImportMode,
        languageCode: String? = nil
    ) throws -> ContentImportResult {
        var payload = try parsePayload(from: urls)
        if let languageCode {
            payload.languageCode = languageCode
            payload.languageName = BundledContentLanguage.displayName(for: languageCode)
        }

        let courseID = "course_\(payload.languageCode)"
        let versionKey = "\(ContentSeeder.currentContentVersion)-import-\(Date().timeIntervalSince1970)"

        let course: Course
        if let existing = try fetchCourse(id: courseID) {
            course = existing
            if mode == .replace {
                clearCourseContentPreservingProgress(course)
            }
            course.contentVersion = versionKey
            course.displayName = payload.languageName
            course.languageCode = payload.languageCode
        } else {
            course = Course(
                id: courseID,
                languageCode: payload.languageCode,
                displayName: payload.languageName,
                contentVersion: versionKey
            )
            modelContext.insert(course)
        }

        let wordsImported = try upsertWords(payload.words, course: course, mode: mode, languageCode: payload.languageCode)
        let phrasesImported = try upsertPhrases(payload.phrases, course: course, mode: mode, languageCode: payload.languageCode)
        let grammarImported = try upsertGrammar(payload.grammarSections, course: course, mode: mode)

        if course.studyPlan == nil {
            let worker = ContentSeederWorker(modelContext: modelContext)
            let studyPlan = worker.buildDefaultStudyPlan(for: course, languageCode: payload.languageCode)
            course.studyPlan = studyPlan
            modelContext.insert(studyPlan)
        }

        try modelContext.save()

        logger.info("Imported content for \(payload.languageName, privacy: .public) using \(mode.rawValue, privacy: .public) mode")

        return ContentImportResult(
            languageName: payload.languageName,
            wordsImported: wordsImported,
            phrasesImported: phrasesImported,
            grammarSectionsImported: grammarImported,
            mode: mode
        )
    }

    private struct ImportPayload {
        var languageCode: String
        var languageName: String
        var words: [ImportWord]
        var phrases: [ImportPhrase]
        var grammarSections: [ImportGrammarSection]
    }

    private struct ImportWord {
        let id: String
        let english: String
        let foreign: String
        let dayIntroduced: Int
        let difficulty: Int
        let tags: [String]
        let sortOrder: Int
    }

    private struct ImportPhrase {
        let id: String
        let english: String
        let foreign: String
        let dayIntroduced: Int
        let difficulty: Int
        let tags: [String]
        let sortOrder: Int
    }

    private struct ImportGrammarSection {
        let id: String
        let number: Int
        let title: String
        let content: String
    }

    private func parsePayload(from urls: [URL]) throws -> ImportPayload {
        var languageCode: String?
        var languageName: String?
        var words: [ImportWord] = []
        var phrases: [ImportPhrase] = []
        var grammarSections: [ImportGrammarSection] = []

        for url in urls {
            let access = url.startAccessingSecurityScopedResource()
            defer { if access { url.stopAccessingSecurityScopedResource() } }

            let filename = url.lastPathComponent.lowercased()
            if filename.hasSuffix("_words.json") || filename == "words.json" {
                let parsed = try parseWordsFile(url: url)
                languageCode = languageCode ?? parsed.languageCode
                languageName = languageName ?? parsed.languageName
                words = parsed.words
            } else if filename.hasSuffix("_phrases.json") || filename == "phrases.json" {
                let parsed = try parsePhrasesFile(url: url)
                languageCode = languageCode ?? parsed.languageCode
                languageName = languageName ?? parsed.languageName
                phrases = parsed.phrases
            } else if filename == "grammar.md" {
                let code = languageCode ?? "es"
                grammarSections = try parseGrammarMarkdown(url: url, languageCode: code)
            }
        }

        guard let resolvedCode = languageCode else {
            throw ContentSeederError.malformedJSON("Could not detect language code from selected files.")
        }

        return ImportPayload(
            languageCode: resolvedCode,
            languageName: languageName ?? BundledContentLanguage.displayName(for: resolvedCode),
            words: words,
            phrases: phrases,
            grammarSections: grammarSections
        )
    }

    private func parseWordsFile(url: URL) throws -> (languageCode: String, languageName: String, words: [ImportWord]) {
        let data = try Data(contentsOf: url)
        if let bundled = try? JSONDecoder().decode(BundledWordsFile.self, from: data) {
            let imports = bundled.words.enumerated().map { index, item in
                ImportWord(
                    id: item.id,
                    english: item.english,
                    foreign: item.foreign,
                    dayIntroduced: ContentSeederWorker.dayIntroducedForWord(item.id),
                    difficulty: item.difficulty,
                    tags: [item.category],
                    sortOrder: index
                )
            }
            return (bundled.language, bundled.languageName, imports)
        }

        let legacy = try JSONDecoder().decode([LegacyWordDTO].self, from: data)
        let imports = legacy.enumerated().map { index, item in
            ImportWord(
                id: item.id,
                english: item.english,
                foreign: item.foreign,
                dayIntroduced: item.dayIntroduced,
                difficulty: item.difficulty,
                tags: item.tags ?? [],
                sortOrder: index
            )
        }
        let code = inferLanguageCode(from: url) ?? "es"
        return (code, BundledContentLanguage.displayName(for: code), imports)
    }

    private func parsePhrasesFile(url: URL) throws -> (languageCode: String, languageName: String, phrases: [ImportPhrase]) {
        let data = try Data(contentsOf: url)
        if let bundled = try? JSONDecoder().decode(BundledPhrasesFile.self, from: data) {
            let imports = bundled.phrases.enumerated().map { index, item in
                ImportPhrase(
                    id: item.id,
                    english: item.english,
                    foreign: item.foreign,
                    dayIntroduced: ContentSeederWorker.dayIntroducedForPhrase(item.id),
                    difficulty: item.difficulty,
                    tags: [item.category],
                    sortOrder: index
                )
            }
            return (bundled.language, bundled.languageName, imports)
        }

        let legacy = try JSONDecoder().decode([LegacyPhraseDTO].self, from: data)
        let imports = legacy.enumerated().map { index, item in
            ImportPhrase(
                id: item.id,
                english: item.english,
                foreign: item.foreign,
                dayIntroduced: item.dayIntroduced,
                difficulty: item.difficulty,
                tags: item.tags ?? [],
                sortOrder: index
            )
        }
        let code = inferLanguageCode(from: url) ?? "es"
        return (code, BundledContentLanguage.displayName(for: code), imports)
    }

    private func inferLanguageCode(from url: URL) -> String? {
        let name = url.deletingPathExtension().lastPathComponent
        if name.hasSuffix("_words") || name.hasSuffix("_phrases") {
            return String(name.split(separator: "_").first ?? "")
        }
        return nil
    }

    private func parseGrammarMarkdown(url: URL, languageCode: String) throws -> [ImportGrammarSection] {
        ContentSeederWorker.parseGrammarSections(from: url, languageCode: languageCode)
            .map { section in
                ImportGrammarSection(
                    id: section.id,
                    number: section.number,
                    title: section.title,
                    content: section.content
                )
            }
    }

    private func upsertWords(
        _ words: [ImportWord],
        course: Course,
        mode: ContentImportMode,
        languageCode: String
    ) throws -> Int {
        var count = 0
        for word in words {
            let uniqueID = "\(languageCode)_\(word.id)"
            if let existing = course.words.first(where: { $0.id == uniqueID }) {
                guard mode == .merge else { continue }
                existing.english = word.english
                existing.foreign = word.foreign
                existing.dayIntroduced = word.dayIntroduced
                existing.difficulty = word.difficulty
                existing.tags = word.tags
                existing.sortOrder = word.sortOrder
            } else {
                let model = Word(
                    id: uniqueID,
                    english: word.english,
                    foreign: word.foreign,
                    dayIntroduced: word.dayIntroduced,
                    difficulty: word.difficulty,
                    tags: word.tags,
                    sortOrder: word.sortOrder
                )
                model.course = course
                modelContext.insert(model)
            }
            count += 1
        }
        return count
    }

    private func upsertPhrases(
        _ phrases: [ImportPhrase],
        course: Course,
        mode: ContentImportMode,
        languageCode: String
    ) throws -> Int {
        var count = 0
        for phrase in phrases {
            let uniqueID = "\(languageCode)_\(phrase.id)"
            if let existing = course.phrases.first(where: { $0.id == uniqueID }) {
                guard mode == .merge else { continue }
                existing.english = phrase.english
                existing.foreign = phrase.foreign
                existing.dayIntroduced = phrase.dayIntroduced
                existing.difficulty = phrase.difficulty
                existing.tags = phrase.tags
                existing.sortOrder = phrase.sortOrder
            } else {
                let model = Phrase(
                    id: uniqueID,
                    english: phrase.english,
                    foreign: phrase.foreign,
                    dayIntroduced: phrase.dayIntroduced,
                    difficulty: phrase.difficulty,
                    tags: phrase.tags,
                    sortOrder: phrase.sortOrder
                )
                model.course = course
                modelContext.insert(model)
            }
            count += 1
        }
        return count
    }

    private func upsertGrammar(
        _ sections: [ImportGrammarSection],
        course: Course,
        mode: ContentImportMode
    ) throws -> Int {
        var count = 0
        for section in sections {
            if let existing = course.grammarSections.first(where: { $0.id == section.id }) {
                guard mode == .merge else { continue }
                existing.number = section.number
                existing.title = section.title
                existing.content = section.content
            } else {
                let model = GrammarSection(
                    id: section.id,
                    number: section.number,
                    title: section.title,
                    content: section.content
                )
                model.course = course
                modelContext.insert(model)
            }
            count += 1
        }
        return count
    }

    private func clearCourseContentPreservingProgress(_ course: Course) {
        course.words.forEach { modelContext.delete($0) }
        course.phrases.forEach { modelContext.delete($0) }
        course.grammarSections.forEach { modelContext.delete($0) }
    }

    private func fetchCourse(id: String) throws -> Course? {
        let descriptor = FetchDescriptor<Course>(predicate: #Predicate { $0.id == id })
        return try modelContext.fetch(descriptor).first
    }
}

private struct LegacyWordDTO: Codable {
    let id: String
    let english: String
    let foreign: String
    let dayIntroduced: Int
    let difficulty: Int
    let tags: [String]?
}

private struct LegacyPhraseDTO: Codable {
    let id: String
    let english: String
    let foreign: String
    let dayIntroduced: Int
    let difficulty: Int
    let tags: [String]?
}

struct BundledWordsFile: Codable {
    let language: String
    let languageName: String
    let version: Int
    let words: [BundledWordItem]

    enum CodingKeys: String, CodingKey {
        case language
        case languageName = "language_name"
        case version
        case words
    }
}

struct BundledPhrasesFile: Codable {
    let language: String
    let languageName: String
    let version: Int
    let phrases: [BundledPhraseItem]

    enum CodingKeys: String, CodingKey {
        case language
        case languageName = "language_name"
        case version
        case phrases
    }
}

struct BundledWordItem: Codable {
    let id: String
    let english: String
    let foreign: String
    let category: String
    let difficulty: Int
}

struct BundledPhraseItem: Codable {
    let id: String
    let english: String
    let foreign: String
    let category: String
    let difficulty: Int
}
