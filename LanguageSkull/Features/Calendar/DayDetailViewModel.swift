import Foundation
import SwiftData

struct DayActivityRow: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let isCompleted: Bool
    let completedAt: Date?
    let timeOfDay: TimeOfDay
}

@Observable
@MainActor
final class DayDetailViewModel {
    private(set) var morningProgress: Double = 0
    private(set) var eveningProgress: Double = 0
    private(set) var morningSubtitle: String = ""
    private(set) var eveningSubtitle: String = ""
    private(set) var activities: [DayActivityRow] = []
    private(set) var resolvedActivities: [String: ResolvedActivity] = [:]
    private(set) var isLoading = true

    private let engine: StudyPlanEngine
    private let profile: UserProfile
    private let date: Date

    init(modelContext: ModelContext, profile: UserProfile, date: Date) {
        engine = StudyPlanEngine(modelContainer: modelContext.container)
        self.profile = profile
        self.date = date.startOfDay
    }

    func load() async {
        isLoading = true
        do {
            let morning = try await engine.assembleSession(for: profile, timeOfDay: .morning, on: date)
            let evening = try await engine.assembleSession(for: profile, timeOfDay: .evening, on: date)
            morningProgress = morning.progress
            eveningProgress = evening.progress
            morningSubtitle = "\(morning.completedCount)/\(morning.totalCount) complete"
            eveningSubtitle = "\(evening.completedCount)/\(evening.totalCount) complete"

            let allResolved = morning.activities + evening.activities
            resolvedActivities = Dictionary(uniqueKeysWithValues: allResolved.map { ($0.id, $0) })

            activities = allResolved.map { activity in
                let completion = profile.completions.first {
                    $0.activityId == activity.id &&
                    Calendar.current.isDate($0.date, inSameDayAs: date) &&
                    $0.isCompleted
                }
                return DayActivityRow(
                    id: activity.id,
                    title: activity.title,
                    subtitle: activity.subtitle,
                    isCompleted: activity.isCompleted,
                    completedAt: completion?.completedAt,
                    timeOfDay: activity.timeOfDay
                )
            }
        } catch {
            print("DayDetailViewModel error: \(error)")
        }
        isLoading = false
    }

    func resolvedActivity(for id: String) -> ResolvedActivity? {
        resolvedActivities[id]
    }
}
