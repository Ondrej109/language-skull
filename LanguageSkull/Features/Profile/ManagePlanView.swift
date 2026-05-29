import SwiftUI

struct ManagePlanView: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    let profile: UserProfile

    var body: some View {
        List {
            Section("Current Plan") {
                LabeledContent("Status", value: profile.subscriptionStatus?.isPro == true ? "Pro" : "Free Trial")
                LabeledContent("Language", value: profile.targetLanguage)
                LabeledContent("Study Day", value: "Day \(profile.startingStudyDay)+")
            }

            Section {
                Text("Full subscription management with StoreKit arrives in Phase 6.")
                    .font(.footnote)
                    .foregroundStyle(theme.textSecondary)
            }
        }
        .scrollContentBackground(.hidden)
        .appBackground(theme)
        .navigationTitle("Manage Plan")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") { dismiss() }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ManagePlanView(profile: PreviewData.sampleProfile)
    }
    .environment(\.theme, Theme())
}
