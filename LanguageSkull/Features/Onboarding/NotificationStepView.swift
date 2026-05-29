import SwiftUI
import SwiftData

struct NotificationStepView: View {
    @Environment(\.theme) private var theme
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        OnboardingQuestionContainer(
            step: 4,
            title: "Morning reminder",
            subtitle: "We'll send one gentle reminder each morning so you never miss your training."
        ) {
            VStack(spacing: 16) {
                Image(systemName: "bell.badge")
                    .font(.system(size: 48))
                    .foregroundStyle(theme.highlight)
                    .padding(.bottom, 8)

                Text("You can change this anytime in Settings. Denying permission won't limit your access.")
                    .font(.footnote)
                    .foregroundStyle(theme.textSecondary)
                    .multilineTextAlignment(.center)

                Button("Enable Morning Reminder") {
                    Task { await viewModel.handleNotificationChoice(requestPermission: true) }
                }
                .buttonStyle(.borderedProminent)
                .tint(theme.accent)
                .frame(maxWidth: .infinity)
                .disabled(viewModel.isProcessing)

                Button("Not Now") {
                    Task { await viewModel.handleNotificationChoice(requestPermission: false) }
                }
                .foregroundStyle(theme.textSecondary)
                .disabled(viewModel.isProcessing)
            }
        }
    }
}

#Preview {
    NavigationStack {
        NotificationStepView(viewModel: OnboardingViewModel(modelContext: PreviewData.previewContainer.mainContext))
    }
    .environment(\.theme, Theme())
}
