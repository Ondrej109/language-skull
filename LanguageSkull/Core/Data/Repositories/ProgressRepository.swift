import Foundation
import SwiftData

@MainActor
final class ProgressRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func completions(for user: UserProfile, on date: Date) -> [UserActivityCompletion] {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay) ?? startOfDay

        return user.completions.filter { completion in
            completion.date >= startOfDay && completion.date < endOfDay
        }
    }

    func markCompleted(
        activityId: String,
        user: UserProfile,
        date: Date = .now
    ) throws {
        let normalizedDate = Calendar.current.startOfDay(for: date)
        let existing = completions(for: user, on: normalizedDate)
            .first { $0.activityId == activityId }

        if let existing {
            existing.isCompleted = true
            existing.completedAt = .now
        } else {
            let completion = UserActivityCompletion(
                date: normalizedDate,
                activityId: activityId,
                isCompleted: true,
                completedAt: .now
            )
            completion.user = user
            modelContext.insert(completion)
        }
        try modelContext.save()
    }
}
