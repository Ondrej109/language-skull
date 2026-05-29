import Foundation
import SwiftData

@Observable
@MainActor
final class CalendarViewModel {
    private(set) var days: [CalendarDaySummary] = []
    private(set) var isLoading = true
    private(set) var errorMessage: String?

    private let engine: StudyPlanEngine
    private let profile: UserProfile

    init(modelContext: ModelContext, profile: UserProfile) {
        self.engine = StudyPlanEngine(modelContainer: modelContext.container)
        self.profile = profile
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            days = try await engine.calendarSummaries(for: profile, dayCount: 30)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
