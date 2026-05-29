import SwiftUI

struct LaunchScreenView: View {
    @Environment(\.theme) private var theme

    let onBegin: () -> Void

    @State private var glow = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            ZStack {
                Circle()
                    .fill(theme.accent.opacity(glow ? 0.35 : 0.15))
                    .frame(width: 160, height: 160)
                    .blur(radius: 24)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: glow)

                Image(systemName: "skull")
                    .font(.system(size: 72, weight: .light))
                    .foregroundStyle(theme.highlight)
                    .shadow(color: theme.highlight.opacity(0.4), radius: glow ? 16 : 4)
                    .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: glow)
            }
            .accessibilityLabel("Language Skull")

            VStack(spacing: 8) {
                Text("Language Skull")
                    .font(.largeTitle.bold())
                    .foregroundStyle(theme.textPrimary)
                Text("Structured training for serious learners")
                    .font(.subheadline)
                    .foregroundStyle(theme.textSecondary)
            }

            Spacer()

            VStack(spacing: 12) {
                Button(action: onBegin) {
                    Text("Begin Training")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .buttonStyle(.borderedProminent)
                .tint(theme.accent)
                .accessibilityHint("Starts onboarding as a guest")

                Text("No account needed to start")
                    .font(.footnote)
                    .foregroundStyle(theme.textSecondary)
            }
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
        .appBackground(theme)
        .onAppear { glow = true }
    }
}

#Preview {
    LaunchScreenView(onBegin: {})
        .environment(\.theme, Theme())
}
