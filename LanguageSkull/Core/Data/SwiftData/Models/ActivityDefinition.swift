import Foundation
import SwiftData

@Model
final class ActivityDefinition {
    @Attribute(.unique) var id: String
    var typeRawValue: String
    var order: Int
    var timeOfDayRaw: String
    var metadataJSON: Data?

    @Relationship(inverse: \DayPlan.activities)
    var dayPlan: DayPlan?

    var type: ActivityType {
        get { ActivityType(rawValue: typeRawValue) ?? .newWordsList }
        set { typeRawValue = newValue.rawValue }
    }

    var timeOfDay: TimeOfDay {
        get { TimeOfDay(rawValue: timeOfDayRaw) ?? .morning }
        set { timeOfDayRaw = newValue.rawValue }
    }

    var metadata: [String: String] {
        get {
            guard let metadataJSON else { return [:] }
            return (try? JSONDecoder().decode([String: String].self, from: metadataJSON)) ?? [:]
        }
        set {
            metadataJSON = try? JSONEncoder().encode(newValue)
        }
    }

    init(
        id: String,
        type: ActivityType,
        order: Int,
        timeOfDay: TimeOfDay,
        metadata: [String: String] = [:]
    ) {
        self.id = id
        self.typeRawValue = type.rawValue
        self.order = order
        self.timeOfDayRaw = timeOfDay.rawValue
        self.metadataJSON = try? JSONEncoder().encode(metadata)
    }
}
