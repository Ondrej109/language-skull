import SwiftUI
import SwiftData

struct AvatarMenuButton: View {
    @Environment(\.theme) private var theme

    let onProfile: () -> Void
    let onManagePlan: () -> Void
    let onReferFriend: () -> Void
    let onSignOut: () -> Void

    var body: some View {
        Menu {
            Button("Profile", action: onProfile)
            Button("Manage Plan", action: onManagePlan)
            Button("Refer a Friend", action: onReferFriend)
            Divider()
            Button("Sign Out", role: .destructive, action: onSignOut)
        } label: {
            AvatarView()
        }
    }
}

struct AvatarToolbarModifier: ViewModifier {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var modelContext
    @Environment(AppNavigationState.self) private var navigationState

    let profile: UserProfile
    var onSignOutComplete: (() -> Void)?

    func body(content: Content) -> some View {
        @Bindable var navigationState = navigationState

        content
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    AvatarMenuButton(
                        onProfile: { navigationState.selectedTab = .profile },
                        onManagePlan: { navigationState.showManagePlan = true },
                        onReferFriend: { navigationState.showReferSheet = true },
                        onSignOut: signOut
                    )
                }
            }
            .sheet(isPresented: $navigationState.showManagePlan) {
                NavigationStack {
                    ManagePlanView(profile: profile)
                }
            }
            .sheet(isPresented: $navigationState.showReferSheet) {
                ReferFriendView()
            }
    }

    private func signOut() {
        do {
            try SignOutService.signOut(profile: profile, modelContext: modelContext)
            onSignOutComplete?()
        } catch {
            print("Sign out error: \(error)")
        }
    }
}

extension View {
    func avatarToolbar(profile: UserProfile, onSignOutComplete: (() -> Void)? = nil) -> some View {
        modifier(AvatarToolbarModifier(profile: profile, onSignOutComplete: onSignOutComplete))
    }
}

#Preview {
    NavigationStack {
        Text("Screen")
            .avatarToolbar(profile: PreviewData.sampleProfile)
    }
    .environment(\.theme, Theme())
    .environment(AppNavigationState())
}
