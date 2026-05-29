import Foundation
import SwiftData

extension Notification.Name {
    static let userDidSignOut = Notification.Name("userDidSignOut")
}

@Observable
@MainActor
final class AppNavigationState {
    enum Tab: Hashable {
        case home
        case calendar
        case admin
        case profile
    }

    var selectedTab: Tab = .home
    var showManagePlan = false
    var showReferSheet = false
}

@MainActor
enum SignOutService {
    static func signOut(profile: UserProfile, modelContext: ModelContext) throws {
        profile.hasCompletedOnboarding = false
        profile.appleUserID = nil
        OnboardingStateStore.clear()
        OnboardingStateStore.saveStep(.launch)
        try modelContext.save()
        NotificationCenter.default.post(name: .userDidSignOut, object: nil)
    }
}
