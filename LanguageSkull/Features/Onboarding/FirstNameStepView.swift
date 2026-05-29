import SwiftUI
import SwiftData

struct FirstNameStepView: View {
    @Environment(\.theme) private var theme
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        OnboardingQuestionContainer(
            step: 1,
            title: "What should we call you?",
            subtitle: "Optional — we'll use this to personalize your experience."
        ) {
            TextField("What should we call you?", text: $viewModel.firstName)
                .textContentType(.givenName)
                .autocorrectionDisabled()
                .padding()
                .background(theme.surface.opacity(0.6), in: RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(theme.textPrimary)
                .accessibilityLabel("First name")

            VStack(spacing: 12) {
                Button("Continue") { viewModel.submitFirstName() }
                    .buttonStyle(.borderedProminent)
                    .tint(theme.accent)
                    .frame(maxWidth: .infinity)

                Button("Continue as Guest") { viewModel.submitFirstName() }
                    .foregroundStyle(theme.textSecondary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        FirstNameStepView(viewModel: OnboardingViewModel(modelContext: PreviewData.previewContainer.mainContext))
    }
    .environment(\.theme, Theme())
}
