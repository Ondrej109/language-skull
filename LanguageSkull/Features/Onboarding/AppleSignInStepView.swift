import AuthenticationServices
import SwiftUI
import SwiftData

struct AppleSignInStepView: View {
    @Environment(\.theme) private var theme
    @Environment(\.colorScheme) private var colorScheme
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        OnboardingQuestionContainer(
            step: 5,
            title: "Save your progress",
            subtitle: "Sync your progress across devices and never lose your streak."
        ) {
            VStack(spacing: 20) {
                Button {
                    Task { await viewModel.signInWithApple() }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "apple.logo")
                        Text("Sign in with Apple")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(colorScheme == .dark ? Color.white : Color.black)
                    .foregroundStyle(colorScheme == .dark ? Color.black : Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .disabled(viewModel.isProcessing)
                .accessibilityLabel("Sign in with Apple")

                if viewModel.isProcessing {
                    ProgressView()
                        .tint(theme.highlight)
                }

                Button("Continue as Guest") {
                    Task { await viewModel.continueAsGuest() }
                }
                .foregroundStyle(theme.textSecondary)
                .disabled(viewModel.isProcessing)
                .accessibilityHint("Completes onboarding without signing in")
            }
        }
    }
}

#Preview {
    NavigationStack {
        AppleSignInStepView(viewModel: OnboardingViewModel(modelContext: PreviewData.previewContainer.mainContext))
    }
    .environment(\.theme, Theme())
}
