import SwiftUI
import SwiftData

struct OnboardingFlowView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var modelContext

    @State private var viewModel: OnboardingViewModel?
    let onComplete: () -> Void

    var body: some View {
        Group {
            if let viewModel {
                NavigationStack {
                    stepView(for: viewModel)
                        .alert(
                            "Something went wrong",
                            isPresented: Binding(
                                get: { viewModel.errorMessage != nil },
                                set: { if !$0 { viewModel.errorMessage = nil } }
                            )
                        ) {
                            Button("OK", role: .cancel) {}
                        } message: {
                            Text(viewModel.errorMessage ?? "")
                        }
                }
            } else {
                ProgressView("Loading…")
                    .tint(theme.highlight)
            }
        }
        .appBackground(theme)
        .task {
            if viewModel == nil {
                let vm = OnboardingViewModel(modelContext: modelContext)
                vm.onComplete = onComplete
                vm.bootstrap()
                viewModel = vm
            }
        }
    }

    @ViewBuilder
    private func stepView(for viewModel: OnboardingViewModel) -> some View {
        switch viewModel.currentStep {
        case .launch:
            LaunchScreenView { viewModel.beginTraining() }

        case .quickDemo:
            QuickDemoView(
                onComplete: { viewModel.completeQuickDemo() },
                onSkip: { viewModel.skipQuickDemo() }
            )

        case .firstName:
            FirstNameStepView(viewModel: viewModel)

        case .language:
            LanguageSelectionStepView(viewModel: viewModel)

        case .proficiency:
            ProficiencyStepView(viewModel: viewModel)

        case .notifications:
            NotificationStepView(viewModel: viewModel)

        case .appleSignIn:
            AppleSignInStepView(viewModel: viewModel)

        case .seeding:
            VStack(spacing: 16) {
                ProgressView()
                    .tint(theme.highlight)
                Text("Building your study plan…")
                    .foregroundStyle(theme.textSecondary)
                if let message = viewModel.contentFallbackMessage {
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(theme.highlight)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    OnboardingFlowView(onComplete: {})
        .environment(\.theme, Theme())
        .modelContainer(PreviewData.previewContainer)
}
