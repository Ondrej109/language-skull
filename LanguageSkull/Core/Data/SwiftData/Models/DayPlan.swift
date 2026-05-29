import Foundation
import SwiftData

@Model
final class DayPlan {
    @Attribute(.unique) var id: String
    var dayNumber: Int

    // Simplified relationships for now
    @Relationship(deleteRule: .cascade)
    var activities: [ActivityDefinition] = []

    // Optional: keep parent links but remove inverse for stability
    var studyPlan: StudyPlan?
    var weekPlan: WeekPlan?

    init(id: String, dayNumber: Int) {
        self.id = id
        self.dayNumber = dayNumber
    }

    var morningActivities: [ActivityDefinition] {
        activities
            .filter { $0.timeOfDay == .morning }
            .sorted { $0.order < $1.order }
    }

    var eveningActivities: [ActivityDefinition] {
        activities
            .filter { $0.timeOfDay == .evening }
            .sorted { $0.order < $1.order }
    }
}
