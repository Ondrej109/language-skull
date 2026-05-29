import Foundation
import SwiftData

@Observable
@MainActor
final class StudySessionViewModel {
    private(set) var summary: StudySessionSummary?
    private(set) var isLoading = true
    private(set) var errorMessage: String?

    private let engine: StudyPlanEngine
    private let progressRepository: ProgressRepository
    private let profile: UserProfile
    private let timeOfDay: TimeOfDay
    private let viewingDate: Date

    init(
        modelContext: ModelContext,
        profile: UserProfile,
        timeOfDay: TimeOfDay,
        viewingDate: Date = .now
    ) {
        self.engine = StudyPlanEngine(modelContainer: modelContext.container)
        self.progressRepository = ProgressRepository(modelContext: modelContext)
        self.profile = profile
        self.timeOfDay = timeOfDay
        self.viewingDate = viewingDate.startOfDay
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            summary = try await engine.assembleSession(
                for: profile,
                timeOfDay: timeOfDay,
                on: viewingDate
            )
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func markCompleted(activityID: String) async {
        do {
            try progressRepository.markCompleted(
                activityId: activityID,
                user: profile,
                date: viewingDate
            )
            await load()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
