import SwiftUI

struct OnboardingQuestionContainer<Content: View>: View {
    @Environment(\.theme) private var theme

    let step: Int
    let title: String
    let subtitle: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                OnboardingProgressBar(
                    currentStep: step,
                    totalSteps: OnboardingStep.questionSteps.count
                )

                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .font(.title.bold())
                        .foregroundStyle(theme.textPrimary)
                    Text(subtitle)
                        .font(.body)
                        .foregroundStyle(theme.textSecondary)
                }

                content()
            }
            .padding()
        }
        .appBackground(theme)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        OnboardingQuestionContainer(
            step: 1,
            title: "Sample Question",
            subtitle: "Sample subtitle for preview."
        ) {
            Text("Content goes here")
                .foregroundStyle(.white)
        }
    }
    .environment(\.theme, Theme())
}
