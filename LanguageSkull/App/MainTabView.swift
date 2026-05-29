import SwiftData
import SwiftUI

struct MainTabView: View {
    @Environment(\.theme) private var theme
    @Environment(AppNavigationState.self) private var navigationState
    @Bindable var featureFlags: FeatureFlagStore

    let profile: UserProfile
    var openMorningSessionOnAppear: Bool = false

    var body: some View {
        @Bindable var navigationState = navigationState

        TabView(selection: $navigationState.selectedTab) {
            HomeView(
                profile: profile,
                openMorningSessionOnAppear: openMorningSessionOnAppear
            )
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(AppNavigationState.Tab.home)

            CalendarView(profile: profile)
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
                .tag(AppNavigationState.Tab.calendar)

            if featureFlags.isAdminModeEnabled {
                AdminTabView(profile: profile)
                    .tabItem {
                        Label("Admin", systemImage: "hammer.fill")
                    }
                    .tag(AppNavigationState.Tab.admin)
            }

            ProfileTabView(profile: profile)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(AppNavigationState.Tab.profile)
        }
        .tint(theme.accent)
    }
}

#Preview {
    MainTabView(featureFlags: FeatureFlagStore(), profile: PreviewData.sampleProfile)
        .environment(\.theme, Theme())
        .environment(AppNavigationState())
        .modelContainer(PreviewData.previewContainer)
}
