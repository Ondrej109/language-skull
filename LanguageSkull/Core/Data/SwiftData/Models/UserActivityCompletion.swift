import Foundation
import SwiftData

@Model
final class UserActivityCompletion {
    var date: Date
    var activityId: String
    var isCompleted: Bool
    var completedAt: Date?

    // Simplified relationship - removed inverse to break circular dependency
    var user: UserProfile?

    init(
        date: Date,
        activityId: String,
        isCompleted: Bool = false,
        completedAt: Date? = nil
    ) {
        self.date = date
        self.activityId = activityId
        self.isCompleted = isCompleted
        self.completedAt = completedAt
    }
}
