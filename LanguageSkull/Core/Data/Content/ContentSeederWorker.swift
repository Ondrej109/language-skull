import Foundation
import SwiftData
import OSLog

enum ContentSeederError: LocalizedError {
    case contentFolderNotFound(String)
    case malformedJSON(String)
    case unsupportedLanguage(String)

    var errorDescription: String? {
        switch self {
        case .contentFolderNotFound(let language):
            "Bundled content not found for language: \(language)"
        case .malformedJSON(let file):
            "Malformed JSON in \(file)"
        case .unsupportedLanguage(let language):
            "Unsupported language: \(language)"
        }
    }
}

@MainActor
final class ContentSeederWorker {
    private let modelContext: ModelContext
    private let logger = Logger(subsystem: "com.languageskull.app", category: "ContentSeederWorker")

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    @discardableResult
    func seedInitialContent(preferredLanguage: String? = nil, forceLanguage: Bool = false) throws -> String {
        let languageName = BundledContentLanguage.resolveLanguageName(preferredLanguage)
        guard let contentCode = BundledContentLanguage.contentCode(for: languageName) else {
            throw ContentSeederError.unsupportedLanguage(languageName)
        }

        let displayName = BundledContentLanguage.displayName(for: contentCode)
        let courseID = "course_\(contentCode)"
        let bundledVersion = try peekBundledVersion(contentCode: contentCode)
        let versionKey = "\(ContentSeeder.currentContentVersion)-\(bundledVersion)"

        if !forceLanguage,
           let existing = try fetchCourse(id: courseID),
           existing.contentVersion == versionKey {
            logger.info("Content already seeded for \(displayName, privacy: .public) at version \(versionKey, privacy: .public)")
            return displayName
        }

        guard bundledWordsURL(for: contentCode) != nil else {
            logger.error("Falling back to Spanish — bundled content missing for \(displayName, privacy: .public)")
            if languageName != "Spanish" {
                return try seedInitialContent(preferredLanguage: "Spanish", forceLanguage: forceLanguage)
            }
            throw ContentSeederError.contentFolderNotFound(displayName)
        }

        let wordsFile = try loadWordsFile(contentCode: contentCode)
        let phrasesFile = try loadPhrasesFile(contentCode: contentCode)

        let course: Course
        if let existing = try fetchCourse(id: courseID) {
            course = existing
            course.contentVersion = versionKey
            course.displayName = displayName
            course.languageCode = contentCode
            clearCourseContent(course)
        } else {
            course = Course(
                id: courseID,
                languageCode: contentCode,
                displayName: displayName,
                contentVersion: versionKey
            )
            modelContext.insert(course)
        }

        for (index, item) in wordsFile.words.enumerated() {
            let word = Word(
                id: "\(contentCode)_\(item.id)",
                english: item.english,
                foreign: item.foreign,
                dayIntroduced: Self.dayIntroducedForWord(item.id),
                difficulty: item.difficulty,
                tags: [item.category],
                sortOrder: index
            )
            word.course = course
            modelContext.insert(word)
        }

        for (index, item) in phrasesFile.phrases.enumerated() {
            let phrase = Phrase(
                id: "\(contentCode)_\(item.id)",
                english: item.english,
                foreign: item.foreign,
                dayIntroduced: Self.dayIntroducedForPhrase(item.id),
                difficulty: item.difficulty,
                tags: [item.category],
                sortOrder: index
            )
            phrase.course = course
            modelContext.insert(phrase)
        }

        if course.studyPlan == nil {
            let studyPlan = buildDefaultStudyPlan(for: course, languageCode: contentCode)
            course.studyPlan = studyPlan
            modelContext.insert(studyPlan)
        }

        try modelContext.save()

        logger.info(
            "Seeded \(wordsFile.words.count) words and \(phrasesFile.phrases.count) phrases for \(displayName, privacy: .public)"
        )
        return displayName
    }

    func buildDefaultStudyPlan(for course: Course, languageCode: String) -> StudyPlan {
        let planID = "plan_\(languageCode)_default"
        let studyPlan = StudyPlan(id: planID, name: "Universal 7-Day Plan", isRepeatingWeekly: true)

        let dayTemplates: [(Int, [ActivityTemplate])] = [
            (1, [
                ActivityTemplate(type: .newWordsList, timeOfDay: .morning, order: 0),
                ActivityTemplate(type: .newWordsFlashcardsEF, timeOfDay: .morning, order: 1),
                ActivityTemplate(type: .newPhrasesList, timeOfDay: .evening, order: 0),
                ActivityTemplate(type: .newPhrasesFlashcardsEF, timeOfDay: .evening, order: 1)
            ]),
            (2, [
                ActivityTemplate(type: .newWordsList, timeOfDay: .morning, order: 0),
                ActivityTemplate(type: .revisionWordsD1, timeOfDay: .morning, order: 1),
                ActivityTemplate(type: .newPhrasesList, timeOfDay: .evening, order: 0),
                ActivityTemplate(type: .revisionPhrasesD1, timeOfDay: .evening, order: 1)
            ]),
            (3, [
                ActivityTemplate(type: .newWordsList, timeOfDay: .morning, order: 0),
                ActivityTemplate(type: .newWordsFlashcardsFE, timeOfDay: .morning, order: 1),
                ActivityTemplate(type: .revisionWordsD3, timeOfDay: .morning, order: 2),
                ActivityTemplate(type: .newPhrasesFlashcardsFE, timeOfDay: .evening, order: 0),
                ActivityTemplate(type: .revisionPhrasesD3, timeOfDay: .evening, order: 1)
            ]),
            (4, [
                ActivityTemplate(type: .newWordsList, timeOfDay: .morning, order: 0),
                ActivityTemplate(type: .revisionWordsD1, timeOfDay: .morning, order: 1),
                ActivityTemplate(type: .revisionWordsD3, timeOfDay: .morning, order: 2),
                ActivityTemplate(type: .newPhrasesList, timeOfDay: .evening, order: 0),
                ActivityTemplate(type: .revisionPhrasesD1, timeOfDay: .evening, order: 1),
                ActivityTemplate(type: .revisionPhrasesD3, timeOfDay: .evening, order: 2)
            ]),
            (5, [
                ActivityTemplate(type: .newWordsFlashcardsEF, timeOfDay: .morning, order: 0),
                ActivityTemplate(type: .revisionWordsD3, timeOfDay: .morning, order: 1),
                ActivityTemplate(type: .grammarParagraph, timeOfDay: .evening, order: 0, metadata: ["sectionNumber": "1"]),
                ActivityTemplate(type: .newPhrasesFlashcardsEF, timeOfDay: .evening, order: 1)
            ]),
            (6, [
                ActivityTemplate(type: .newWordsList, timeOfDay: .morning, order: 0),
                ActivityTemplate(type: .revisionWordsD1, timeOfDay: .morning, order: 1),
                ActivityTemplate(type: .newPhrasesList, timeOfDay: .evening, order: 0),
                ActivityTemplate(type: .revisionPhrasesD3, timeOfDay: .evening, order: 1),
                ActivityTemplate(type: .grammarParagraph, timeOfDay: .evening, order: 2, metadata: ["sectionNumber": "2"])
            ]),
            (7, [
                ActivityTemplate(type: .revisionWordsD3, timeOfDay: .morning, order: 0),
                ActivityTemplate(type: .newWordsFlashcardsFE, timeOfDay: .morning, order: 1),
                ActivityTemplate(type: .revisionPhrasesD3, timeOfDay: .evening, order: 0),
                ActivityTemplate(type: .newPhrasesFlashcardsFE, timeOfDay: .evening, order: 1)
            ])
        ]

        for (day, templates) in dayTemplates {
            let dayPlan = DayPlan(id: "\(planID)_day_\(day)", dayNumber: day)
            dayPlan.studyPlan = studyPlan

            let activities = templates.enumerated().map { index, template in
                ActivityDefinition(
                    id: "\(planID)_d\(day)_\(template.timeOfDay.rawValue)_\(index)",
                    type: template.type,
                    order: template.order,
                    timeOfDay: template.timeOfDay,
                    metadata: template.metadata
                )
            }

            activities.forEach { activity in
                activity.dayPlan = dayPlan
                modelContext.insert(activity)
            }

            dayPlan.activities = activities
            studyPlan.dayPlans.append(dayPlan)
            modelContext.insert(dayPlan)
        }

        studyPlan.course = course
        return studyPlan
    }

    static func dayIntroducedForWord(_ id: String) -> Int {
        guard let number = extractItemNumber(from: id) else { return 1 }
        return min(7, (number - 1) / 10 + 1)
    }

    static func dayIntroducedForPhrase(_ id: String) -> Int {
        guard let number = extractItemNumber(from: id) else { return 1 }
        return min(7, (number - 1) / 3 + 1)
    }

    static func parseGrammarSections(from url: URL, languageCode: String) -> [GrammarSection] {
        guard FileManager.default.fileExists(atPath: url.path),
              let markdown = try? String(contentsOf: url, encoding: .utf8) else { return [] }

        let lines = markdown.components(separatedBy: .newlines)
        var sections: [GrammarSection] = []
        var currentNumber: Int?
        var currentTitle: String?
        var currentContent: [String] = []

        func flushSection() {
            guard let currentNumber, let currentTitle else { return }
            let content = currentContent.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
            sections.append(
                GrammarSection(
                    id: "g_\(languageCode.lowercased())_\(currentNumber)",
                    number: currentNumber,
                    title: currentTitle,
                    content: content
                )
            )
        }

        for line in lines {
            if line.hasPrefix("# ") {
                flushSection()
                currentContent = []
                let heading = String(line.dropFirst(2)).trimmingCharacters(in: .whitespaces)
                if let dotIndex = heading.firstIndex(of: ".") {
                    let numberPart = heading[..<dotIndex].trimmingCharacters(in: .whitespaces)
                    let titlePart = heading[heading.index(after: dotIndex)...].trimmingCharacters(in: .whitespaces)
                    currentNumber = Int(numberPart)
                    currentTitle = String(titlePart)
                } else {
                    currentNumber = sections.count + 1
                    currentTitle = heading
                }
            } else if currentNumber != nil {
                currentContent.append(line)
            }
        }
        flushSection()
        return sections
    }

    private struct ActivityTemplate {
        let type: ActivityType
        let timeOfDay: TimeOfDay
        let order: Int
        var metadata: [String: String] = [:]
    }

    private func bundledWordsURL(for contentCode: String) -> URL? {
        if let url = Bundle.main.url(
            forResource: "\(contentCode)_words",
            withExtension: "json",
            subdirectory: BundledContentLanguage.bundleSubdirectory
        ) { return url }

        guard let resourceURL = Bundle.main.resourceURL else { return nil }
        let candidates = [
            resourceURL.appending(path: "\(BundledContentLanguage.bundleSubdirectory)/\(contentCode)_words.json"),
            resourceURL.appending(path: "resources/bundled-content/\(contentCode)_words.json")
        ]
        return candidates.first { FileManager.default.fileExists(atPath: $0.path) }
    }

    private func bundledPhrasesURL(for contentCode: String) -> URL? {
        if let url = Bundle.main.url(
            forResource: "\(contentCode)_phrases",
            withExtension: "json",
            subdirectory: BundledContentLanguage.bundleSubdirectory
        ) { return url }

        guard let resourceURL = Bundle.main.resourceURL else { return nil }
        let candidates = [
            resourceURL.appending(path: "\(BundledContentLanguage.bundleSubdirectory)/\(contentCode)_phrases.json"),
            resourceURL.appending(path: "resources/bundled-content/\(contentCode)_phrases.json")
        ]
        return candidates.first { FileManager.default.fileExists(atPath: $0.path) }
    }

    private func peekBundledVersion(contentCode: String) throws -> Int {
        guard let url = bundledWordsURL(for: contentCode) else { return 1 }
        let data = try Data(contentsOf: url)
        return (try? JSONDecoder().decode(BundledWordsFile.self, from: data))?.version ?? 1
    }

    private func loadWordsFile(contentCode: String) throws -> BundledWordsFile {
        guard let url = bundledWordsURL(for: contentCode) else {
            throw ContentSeederError.contentFolderNotFound(BundledContentLanguage.displayName(for: contentCode))
        }
        return try JSONDecoder().decode(BundledWordsFile.self, from: Data(contentsOf: url))
    }

    private func loadPhrasesFile(contentCode: String) throws -> BundledPhrasesFile {
        guard let url = bundledPhrasesURL(for: contentCode) else {
            throw ContentSeederError.contentFolderNotFound(BundledContentLanguage.displayName(for: contentCode))
        }
        return try JSONDecoder().decode(BundledPhrasesFile.self, from: Data(contentsOf: url))
    }

    private static func extractItemNumber(from id: String) -> Int? {
        Int(id.filter(\.isNumber))
    }

    private func fetchCourse(id: String) throws -> Course? {
        let descriptor = FetchDescriptor<Course>(predicate: #Predicate { $0.id == id })
        return try modelContext.fetch(descriptor).first
    }

    private func clearCourseContent(_ course: Course) {
        course.words.forEach { modelContext.delete($0) }
        course.phrases.forEach { modelContext.delete($0) }
        course.grammarSections.forEach { modelContext.delete($0) }
        if let studyPlan = course.studyPlan {
            studyPlan.dayPlans.forEach { dayPlan in
                dayPlan.activities.forEach { modelContext.delete($0) }
                modelContext.delete(dayPlan)
            }
            modelContext.delete(studyPlan)
            course.studyPlan = nil
        }
    }
}
