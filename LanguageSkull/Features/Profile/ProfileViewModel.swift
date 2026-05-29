import Foundation
import SwiftData

@Observable
@MainActor
final class ProfileViewModel {
    private(set) var courseName: String = "—"
    private(set) var wordsLearned: Int = 0
    private(set) var phrasesLearned: Int = 0
    private(set) var currentStreak: Int = 0
    private(set) var studyPlanDay: Int = 1
    private(set) var isLoading = true

    private let contentRepository: ContentRepository
    private let engine: StudyPlanEngine
    private let profile: UserProfile

    init(modelContext: ModelContext, profile: UserProfile) {
        contentRepository = ContentRepository(modelContext: modelContext)
        engine = StudyPlanEngine(modelContainer: modelContext.container)
        self.profile = profile
    }

    func load() async {
        isLoading = true

        studyPlanDay = await engine.studyPlanDay(for: profile)
        currentStreak = computeStreak()

        if let course = try? contentRepository.fetchCourse(for: profile) {
            courseName = course.displayName
            wordsLearned = course.words.count
            phrasesLearned = course.phrases.count
        }

        isLoading = false
    }

    private func computeStreak() -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        var streak = 0

        for offset in 0..<365 {
            guard let date = calendar.date(byAdding: .day, value: -offset, to: today) else { break }
            let dayCompletions = profile.completions.filter {
                calendar.isDate($0.date, inSameDayAs: date) && $0.isCompleted
            }
            if dayCompletions.isEmpty { break }
            streak += 1
        }

        return streak
    }
}
