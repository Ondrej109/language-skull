import SwiftUI

struct SettingsView: View {
    @Environment(\.theme) private var theme
    @Bindable var featureFlags: FeatureFlagStore

    var body: some View {
        Form {
            Section {
                Toggle("Admin Mode", isOn: $featureFlags.isAdminModeEnabled)
                    .accessibilityHint("Shows admin tools for content management")
            } footer: {
                Text("Disable Admin Mode before App Store submission. Admin tools are built in Phase 7.")
            }

            if featureFlags.isAdminModeEnabled {
                Section("Admin") {
                    Label("Admin tools coming in Phase 7", systemImage: "hammer.fill")
                        .foregroundStyle(theme.textSecondary)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .appBackground(theme)
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView(featureFlags: FeatureFlagStore())
    }
    .environment(\.theme, Theme())
}
