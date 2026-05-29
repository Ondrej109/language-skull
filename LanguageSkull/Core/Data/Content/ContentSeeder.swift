import Foundation
import SwiftData
import OSLog

enum ContentImportMode: String, CaseIterable, Sendable {
    case replace
    case merge
}

struct ContentValidationResult: Sendable {
    let languageCode: String
    let languageName: String
    let wordCount: Int
    let phraseCount: Int
    let grammarSectionCount: Int
    let warnings: [String]
}

struct ContentImportResult: Sendable {
    let languageName: String
    let wordsImported: Int
    let phrasesImported: Int
    let grammarSectionsImported: Int
    let mode: ContentImportMode
}

/// Thread-safe entry point for content seeding and admin import (docs/05).
actor ContentSeeder {
    static let currentContentVersion = "1.0.0"

    private let modelContainer: ModelContainer
    private let logger = Logger(subsystem: "com.languageskull.app", category: "ContentSeeder")

    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }

    func seedContentForOnboarding(language: String, profileID: PersistentIdentifier) async throws -> String {
        try await MainActor.run {
            let context = modelContainer.mainContext
            guard let profile = context.model(for: profileID) as? UserProfile else {
                throw ContentSeederError.unsupportedLanguage(language)
            }
            let worker = ContentSeederWorker(modelContext: context)
            let resolvedLanguage = try worker.seedInitialContent(preferredLanguage: language, forceLanguage: true)
            profile.targetLanguage = resolvedLanguage
            profile.startingStudyDay = profile.proficiencyLevel.startingStudyDay
            profile.courseStartDate = Date()
            try context.save()
            logger.info("Onboarding seed complete for \(resolvedLanguage, privacy: .public)")
            return resolvedLanguage
        }
    }

    func seedInitialContent(preferredLanguage: String? = nil, forceLanguage: Bool = false) async throws -> String {
        try await MainActor.run {
            let context = modelContainer.mainContext
            return try ContentSeederWorker(modelContext: context)
                .seedInitialContent(preferredLanguage: preferredLanguage, forceLanguage: forceLanguage)
        }
    }

    func validateContentFiles(at urls: [URL]) async throws -> ContentValidationResult {
        try await MainActor.run {
            try ContentImporter(modelContext: modelContainer.mainContext).validate(urls: urls)
        }
    }

    func importContent(
        at urls: [URL],
        mode: ContentImportMode,
        languageCode: String? = nil
    ) async throws -> ContentImportResult {
        try await MainActor.run {
            try ContentImporter(modelContext: modelContainer.mainContext)
                .importContent(at: urls, mode: mode, languageCode: languageCode)
        }
    }

    func importLanguageFolder(at folderURL: URL, mode: ContentImportMode) async throws -> ContentImportResult {
        let files = try FileManager.default.contentsOfDirectory(
            at: folderURL,
            includingPropertiesForKeys: nil
        )
        return try await importContent(at: files, mode: mode)
    }
}
