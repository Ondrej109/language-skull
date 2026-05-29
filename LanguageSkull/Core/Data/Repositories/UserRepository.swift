import Foundation
import SwiftData
import OSLog

@MainActor
final class UserRepository {
    private let modelContext: ModelContext
    private let logger = Logger(subsystem: "com.languageskull.app", category: "UserRepository")

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchCurrentProfile() throws -> UserProfile? {
        var descriptor = FetchDescriptor<UserProfile>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }

    func fetchProfile(byAppleUserID appleUserID: String) throws -> UserProfile? {
        let descriptor = FetchDescriptor<UserProfile>(
            predicate: #Predicate { $0.appleUserID == appleUserID }
        )
        return try modelContext.fetch(descriptor).first
    }

    func fetchGuestProfile() throws -> UserProfile? {
        let descriptor = FetchDescriptor<UserProfile>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return try modelContext.fetch(descriptor).first { $0.appleUserID == nil }
    }

    @discardableResult
    func createGuestProfile() throws -> UserProfile {
        if let existing = try fetchGuestProfile(), !existing.hasCompletedOnboarding {
            return existing
        }

        let profile = UserProfile(
            targetLanguage: "Spanish",
            proficiencyLevel: .beginner,
            hasCompletedOnboarding: false
        )
        let subscription = SubscriptionStatus()
        subscription.user = profile
        profile.subscriptionStatus = subscription
        modelContext.insert(profile)
        modelContext.insert(subscription)
        try modelContext.save()
        logger.info("Created guest profile \(profile.id, privacy: .public)")
        return profile
    }

    func updateProfile(
        _ profile: UserProfile,
        firstName: String?,
        targetLanguage: String,
        proficiencyLevel: ProficiencyLevel,
        notificationEnabled: Bool
    ) throws {
        profile.firstName = firstName?.isEmpty == true ? nil : firstName
        profile.targetLanguage = targetLanguage
        profile.proficiencyLevel = proficiencyLevel
        profile.notificationEnabled = notificationEnabled
        profile.startingStudyDay = proficiencyLevel.startingStudyDay
        try modelContext.save()
    }

    func completeOnboarding(for profile: UserProfile) throws {
        profile.hasCompletedOnboarding = true
        if profile.courseStartDate == nil {
            profile.courseStartDate = Date()
        }
        try modelContext.save()
        OnboardingStateStore.clear()
        logger.info("Onboarding completed for profile \(profile.id, privacy: .public)")
    }

    /// Merges guest progress into the signed-in profile without duplicating completions.
    func mergeGuestProgress(from guest: UserProfile, into signedIn: UserProfile) throws {
        for completion in guest.completions {
            let activityId = completion.activityId
            let date = completion.date
            let isDuplicate = signedIn.completions.contains {
                $0.activityId == activityId && $0.date == date
            }
            if !isDuplicate {
                completion.user = signedIn
            }
        }

        if signedIn.firstName == nil, let guestName = guest.firstName {
            signedIn.firstName = guestName
        }

        if !guest.targetLanguage.isEmpty {
            signedIn.targetLanguage = guest.targetLanguage
        }
        signedIn.proficiencyLevel = guest.proficiencyLevel
        signedIn.startingStudyDay = guest.startingStudyDay
        signedIn.notificationEnabled = guest.notificationEnabled || signedIn.notificationEnabled

        if !guest.hasCompletedOnboarding {
            signedIn.hasCompletedOnboarding = guest.hasCompletedOnboarding
        }

        if guest.id != signedIn.id {
            if let guestSubscription = guest.subscriptionStatus {
                modelContext.delete(guestSubscription)
            }
            modelContext.delete(guest)
        }

        try modelContext.save()
        logger.info("Merged guest progress into profile \(signedIn.id, privacy: .public)")
    }

    func applyAppleSignIn(
        result: AppleSignInResult,
        guestProfile: UserProfile
    ) throws -> UserProfile {
        if let existing = try fetchProfile(byAppleUserID: result.userID) {
            try mergeGuestProgress(from: guestProfile, into: existing)
            if existing.firstName == nil, let name = result.firstName {
                existing.firstName = name
            }
            existing.appleUserID = result.userID
            try modelContext.save()
            return existing
        }

        guestProfile.appleUserID = result.userID
        if guestProfile.firstName == nil, let name = result.firstName {
            guestProfile.firstName = name
        }
        try modelContext.save()
        return guestProfile
    }
}

enum OnboardingStateStore {
    private static let stepKey = "onboarding.currentStep"

    static func saveStep(_ step: OnboardingStep) {
        UserDefaults.standard.set(step.rawValue, forKey: stepKey)
    }

    static func loadStep() -> OnboardingStep? {
        guard let raw = UserDefaults.standard.string(forKey: stepKey) else { return nil }
        return OnboardingStep(rawValue: raw)
    }

    static func clear() {
        UserDefaults.standard.removeObject(forKey: stepKey)
    }
}
