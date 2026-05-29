import SwiftUI

struct SessionPlaceholderView: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    let timeOfDay: TimeOfDay

    private var title: String {
        timeOfDay == .morning ? "Morning Session" : "Evening Session"
    }

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: timeOfDay == .morning ? "sun.max.fill" : "moon.stars.fill")
                .font(.system(size: 56))
                .foregroundStyle(theme.highlight)
                .symbolEffect(.pulse)

            Text(title)
                .font(.largeTitle.bold())
                .foregroundStyle(theme.textPrimary)

            Text("Activity screens arrive in Phase 4. This placeholder confirms navigation works.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(theme.textSecondary)
                .padding(.horizontal)

            Button("Done") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .tint(theme.accent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .appBackground(theme)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview("Morning") {
    NavigationStack {
        SessionPlaceholderView(timeOfDay: .morning)
    }
    .environment(\.theme, Theme())
}

#Preview("Evening") {
    NavigationStack {
        SessionPlaceholderView(timeOfDay: .evening)
    }
    .environment(\.theme, Theme())
}
