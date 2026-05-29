import Foundation
import SwiftData

@Model
final class WeekPlan {
    @Attribute(.unique) var id: String
    var weekNumber: Int

    @Relationship(inverse: \StudyPlan.weekPlans)
    var studyPlan: StudyPlan?

    @Relationship(deleteRule: .cascade, inverse: \DayPlan.weekPlan)
    var dayPlans: [DayPlan]

    init(id: String, weekNumber: Int) {
        self.id = id
        self.weekNumber = weekNumber
        self.dayPlans = []
    }
}
