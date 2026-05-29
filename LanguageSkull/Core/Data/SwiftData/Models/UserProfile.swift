import Foundation
import SwiftData

@Model
final class UserProfile {
    @Attribute(.unique) var id: String
    var firstName: String?
    var appleUserID: String?
    var createdAt: Date
    var targetLanguage: String
    var proficiencyLevelRaw: String
    var notificationEnabled: Bool
    var hasCompletedOnboarding: Bool
    var startingStudyDay: Int
    var courseStartDate: Date?

    @Relationship(deleteRule: .cascade, inverse: \SubscriptionStatus.user)
    var subscriptionStatus: SubscriptionStatus?

    @Relationship(deleteRule: .cascade, inverse: \UserActivityCompletion.user)
    var completions: [UserActivityCompletion]

    var proficiencyLevel: ProficiencyLevel {
        get { ProficiencyLevel(rawValue: proficiencyLevelRaw) ?? .beginner }
        set { proficiencyLevelRaw = newValue.rawValue }
    }

    init(
        id: String = UUID().uuidString,
        firstName: String? = nil,
        appleUserID: String? = nil,
        createdAt: Date = .now,
        targetLanguage: String,
        proficiencyLevel: ProficiencyLevel = .beginner,
        notificationEnabled: Bool = false,
        hasCompletedOnboarding: Bool = false,
        startingStudyDay: Int = 1,
        courseStartDate: Date? = nil
    ) {
        self.id = id
        self.firstName = firstName
        self.appleUserID = appleUserID
        self.createdAt = createdAt
        self.targetLanguage = targetLanguage
        self.proficiencyLevelRaw = proficiencyLevel.rawValue
        self.notificationEnabled = notificationEnabled
        self.hasCompletedOnboarding = hasCompletedOnboarding
        self.startingStudyDay = startingStudyDay
        self.courseStartDate = courseStartDate
        self.completions = []
    }
}
