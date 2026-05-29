import SwiftUI

struct OnboardingProgressBar: View {
    @Environment(\.theme) private var theme

    let currentStep: Int
    let totalSteps: Int

    private var progress: Double {
        guard totalSteps > 0 else { return 0 }
        return Double(currentStep) / Double(totalSteps)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(theme.surface.opacity(0.6))
                    Capsule()
                        .fill(theme.accent)
                        .frame(width: geometry.size.width * progress)
                        .animation(.easeInOut(duration: 0.35), value: progress)
                }
            }
            .frame(height: 4)

            Text("Step \(currentStep) of \(totalSteps)")
                .font(.caption)
                .foregroundStyle(theme.textSecondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Onboarding progress")
        .accessibilityValue("Step \(currentStep) of \(totalSteps)")
    }
}

#Preview {
    OnboardingProgressBar(currentStep: 2, totalSteps: 5)
        .padding()
        .background(Color.black)
        .environment(\.theme, Theme())
}
