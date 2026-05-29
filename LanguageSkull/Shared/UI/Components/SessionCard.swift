import SwiftUI

struct SessionCard: View {
    @Environment(\.theme) private var theme

    let title: String
    let subtitle: String
    let progress: Double
    let systemImage: String
    var largeRing: Bool = false

    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Label(title, systemImage: systemImage)
                    .font(largeRing ? .title.bold() : .title2.bold())
                    .foregroundStyle(theme.textPrimary)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(theme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 12)

            ProgressRing(
                progress: progress,
                label: title,
                diameter: largeRing ? 88 : 64,
                lineWidth: largeRing ? 10 : 8,
                showsLabel: !largeRing
            )
        }
        .padding(largeRing ? 24 : 20)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(theme.accent.opacity(0.32), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.18), radius: largeRing ? 14 : 8, y: largeRing ? 8 : 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title) session")
        .accessibilityHint("Opens the \(title.lowercased()) activity list")
    }
}

#Preview {
    VStack(spacing: 20) {
        SessionCard(
            title: "Morning",
            subtitle: "Day 3 · 2/4 complete",
            progress: 0.5,
            systemImage: "sun.max.fill",
            largeRing: true
        )
        SessionCard(
            title: "Evening",
            subtitle: "Day 3 · 0/4 complete",
            progress: 0.0,
            systemImage: "moon.stars.fill",
            largeRing: true
        )
    }
    .padding()
    .background(Color.black)
    .environment(\.theme, Theme())
}
