import Foundation
import SwiftData

@Observable
@MainActor
final class AdminViewModel {
    private(set) var courses: [CourseSummary] = []
    private(set) var isImporting = false
    private(set) var statusMessage: String?
    private(set) var errorMessage: String?
    private(set) var validation: ContentValidationResult?

    var selectedImportMode: ContentImportMode = .merge

    private let modelContext: ModelContext
    private let contentSeeder: ContentSeeder

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.contentSeeder = ContentSeeder(modelContainer: modelContext.container)
    }

    func loadCourses() {
        do {
            let repository = ContentRepository(modelContext: modelContext)
            courses = try repository.fetchCourses().map {
                CourseSummary(
                    id: $0.id,
                    name: $0.displayName,
                    wordCount: $0.words.count,
                    phraseCount: $0.phrases.count,
                    grammarCount: $0.grammarSections.count,
                    version: $0.contentVersion
                )
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func validateFiles(_ urls: [URL]) async {
        do {
            validation = try await contentSeeder.validateContentFiles(at: urls)
            errorMessage = nil
        } catch {
            validation = nil
            errorMessage = error.localizedDescription
        }
    }

    func importFiles(_ urls: [URL]) async {
        isImporting = true
        statusMessage = nil
        errorMessage = nil

        do {
            let result = try await contentSeeder.importContent(
                at: urls,
                mode: selectedImportMode
            )
            statusMessage = "Imported \(result.wordsImported) words and \(result.phrasesImported) phrases for \(result.languageName) (\(result.mode.rawValue))."
            loadCourses()
        } catch {
            errorMessage = error.localizedDescription
        }

        isImporting = false
    }

    func importFolder(_ url: URL) async {
        isImporting = true
        statusMessage = nil
        errorMessage = nil

        do {
            let result = try await contentSeeder.importLanguageFolder(at: url, mode: selectedImportMode)
            statusMessage = "Imported folder for \(result.languageName) (\(result.mode.rawValue))."
            loadCourses()
        } catch {
            errorMessage = error.localizedDescription
        }

        isImporting = false
    }

    func reportError(_ message: String) {
        errorMessage = message
    }
}

struct CourseSummary: Identifiable {
    let id: String
    let name: String
    let wordCount: Int
    let phraseCount: Int
    let grammarCount: Int
    let version: String
}
