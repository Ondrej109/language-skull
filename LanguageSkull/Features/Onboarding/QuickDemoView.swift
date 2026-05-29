import SwiftUI

struct QuickDemoView: View {
    @Environment(\.theme) private var theme

    let onComplete: () -> Void
    let onSkip: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 24) {
                    Text("Try a quick sample")
                        .font(.title.bold())
                        .foregroundStyle(theme.textPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Experience how Language Skull presents new words before we personalize your plan.")
                        .font(.body)
                        .foregroundStyle(theme.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    TwoColumnListView(
                        title: "New Words",
                        subtitle: "English → Spanish",
                        pairs: TwoColumnListView.spanishDemoPairs
                    )
                }
                .padding()
            }

            VStack(spacing: 12) {
                Button("Continue", action: onComplete)
                    .buttonStyle(.borderedProminent)
                    .tint(theme.accent)
                    .frame(maxWidth: .infinity)

                Button("Skip Demo", action: onSkip)
                    .foregroundStyle(theme.textSecondary)
            }
            .padding()
            .background(.ultraThinMaterial)
        }
        .appBackground(theme)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        QuickDemoView(onComplete: {}, onSkip: {})
    }
    .environment(\.theme, Theme())
}
