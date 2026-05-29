import Foundation
import SwiftData

@Observable
@MainActor
final class HomeViewModel {
    private(set) var courseName: String = "Language Skull"
    private(set) var morningProgress: Double = 0.0
    private(set) var eveningProgress: Double = 0.0
    private(set) var morningSubtitle: String = "Morning session"
    private(set) var eveningSubtitle: String = "Evening session"
    private(set) var greeting: String = GreetingHelper.timeBasedGreeting(firstName: nil)
    private(set) var studyPlanDay: Int = 1
    private(set) var isLoading = true
    private(set) var errorMessage: String?
    private(set) var isEmptyPlan = false

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
        errorMessage = nil

        greeting = GreetingHelper.timeBasedGreeting(firstName: profile.firstName)

        do {
            studyPlanDay = await engine.studyPlanDay(for: profile)

            if let course = try contentRepository.fetchCourse(for: profile) {
                courseName = course.displayName
            }

            let morning = try await engine.assembleSession(for: profile, timeOfDay: .morning)
            let evening = try await engine.assembleSession(for: profile, timeOfDay: .evening)

            morningProgress = morning.progress
            eveningProgress = evening.progress
            morningSubtitle = sessionSubtitle(for: morning)
            eveningSubtitle = sessionSubtitle(for: evening)
            isEmptyPlan = morning.totalCount == 0 && evening.totalCount == 0
        } catch {
            errorMessage = error.localizedDescription
            print("HomeViewModel load error: \(error)")
        }

        isLoading = false
    }

    private func sessionSubtitle(for summary: StudySessionSummary) -> String {
        if summary.totalCount == 0 {
            return "Day \(summary.studyPlanDay) · No activities scheduled"
        }
        return "Day \(summary.studyPlanDay) · \(summary.completedCount)/\(summary.totalCount) complete"
    }
}
