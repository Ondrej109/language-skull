import SwiftUI

struct SessionCompletionView: View {
    @Environment(\.theme) private var theme

    let timeOfDay: TimeOfDay
    let onDismiss: () -> Void

    @State private var animate = false

    private var message: String {
        switch timeOfDay {
        case .morning:
            "Great work! Your morning session is complete. The evening session awaits when you're ready."
        case .evening:
            "Excellent discipline. You've completed today's evening training. Rest well."
        }
    }

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            Image(systemName: "seal.fill")
                .font(.system(size: 72))
                .foregroundStyle(theme.highlight)
                .scaleEffect(animate ? 1 : 0.6)
                .opacity(animate ? 1 : 0)
                .symbolEffect(.pulse, options: .nonRepeating)

            VStack(spacing: 10) {
                Text("Session Complete")
                    .font(.largeTitle.bold())
                    .foregroundStyle(theme.textPrimary)
                Text(message)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(theme.textSecondary)
                    .padding(.horizontal)
            }
            .offset(y: animate ? 0 : 20)
            .opacity(animate ? 1 : 0)

            Spacer()

            Button("Continue", action: onDismiss)
                .buttonStyle(.borderedProminent)
                .tint(theme.accent)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .padding(.bottom, 32)
        }
        .appBackground(theme)
        .onAppear {
            HapticService.success()
            withAnimation(.spring(response: 0.55, dampingFraction: 0.78)) {
                animate = true
            }
        }
    }
}

#Preview("Morning") {
    SessionCompletionView(timeOfDay: .morning, onDismiss: {})
        .environment(\.theme, Theme())
}

#Preview("Evening") {
    SessionCompletionView(timeOfDay: .evening, onDismiss: {})
        .environment(\.theme, Theme())
}
