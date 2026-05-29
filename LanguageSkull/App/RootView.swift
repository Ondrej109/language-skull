import SwiftData
import SwiftUI

struct RootView: View {
    @Environment(\.theme) private var theme
    @Bindable var featureFlags: FeatureFlagStore

    @Query(sort: \UserProfile.createdAt, order: .reverse)
    private var profiles: [UserProfile]

    @State private var showOnboarding = true
    @State private var openMorningSession = false

    private var activeProfile: UserProfile? {
        profiles.first { $0.hasCompletedOnboarding }
    }

    var body: some View {
        Group {
            if showOnboarding {
                OnboardingFlowView {
                    openMorningSession = true
                    showOnboarding = false
                }
            } else if let profile = activeProfile {
                MainTabView(
                    featureFlags: featureFlags,
                    profile: profile,
                    openMorningSessionOnAppear: openMorningSession
                )
            } else {
                ProgressView("Loading profile…")
                    .tint(theme.highlight)
            }
        }
        .onAppear { evaluateRoute() }
        .onChange(of: profiles.count) { _, _ in evaluateRoute() }
        .onChange(of: activeProfile?.hasCompletedOnboarding) { _, completed in
            if completed == false {
                showOnboarding = true
                openMorningSession = false
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .userDidSignOut)) { _ in
            showOnboarding = true
            openMorningSession = false
        }
    }

    private func evaluateRoute() {
        if profiles.contains(where: { $0.hasCompletedOnboarding }) {
            showOnboarding = false
        } else if profiles.isEmpty {
            showOnboarding = true
        }
    }
}

#Preview("Main App") {
    RootView(featureFlags: FeatureFlagStore())
        .environment(\.theme, Theme())
        .environment(AppNavigationState())
        .modelContainer(PreviewData.previewContainer)
}
