import Foundation
import SwiftData

@Model
final class StudyPlan {
    @Attribute(.unique) var id: String
    var name: String
    var isRepeatingWeekly: Bool

    // Simplified relationships to avoid circular reference errors
    var course: Course?

    @Relationship(deleteRule: .cascade)
    var weekPlans: [WeekPlan] = []

    @Relationship(deleteRule: .cascade)
    var dayPlans: [DayPlan] = []

    init(id: String, name: String, isRepeatingWeekly: Bool = true) {
        self.id = id
        self.name = name
        self.isRepeatingWeekly = isRepeatingWeekly
    }

    func dayPlan(for dayNumber: Int) -> DayPlan? {
        if isRepeatingWeekly {
            let normalizedDay = ((dayNumber - 1) % 7) + 1
            return dayPlans.first { $0.dayNumber == normalizedDay }
        }
        return dayPlans.first { $0.dayNumber == dayNumber }
    }
}
