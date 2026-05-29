import SwiftUI

struct ProgressRing: View {
    @Environment(\.theme) private var theme

    let progress: Double
    let label: String
    var diameter: CGFloat = 64
    var lineWidth: CGFloat = 8
    var showsLabel: Bool = true

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(theme.surface.opacity(0.8), lineWidth: lineWidth)
                Circle()
                    .trim(from: 0, to: min(max(progress, 0), 1))
                    .stroke(
                        theme.accent,
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 0.55, dampingFraction: 0.85), value: progress)

                Text("\(Int(progress * 100))%")
                    .font(diameter > 72 ? .title3.bold() : .caption.bold())
                    .foregroundStyle(theme.textPrimary)
            }
            .frame(width: diameter, height: diameter)

            if showsLabel {
                Text(label)
                    .font(.caption)
                    .foregroundStyle(theme.textSecondary)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label) progress")
        .accessibilityValue("\(Int(progress * 100)) percent complete")
    }
}

#Preview {
    HStack(spacing: 24) {
        ProgressRing(progress: 0.35, label: "Morning")
        ProgressRing(progress: 0.0, label: "Evening", diameter: 88, lineWidth: 10, showsLabel: false)
        ProgressRing(progress: 1.0, label: "Done")
    }
    .padding()
    .background(Color.black)
    .environment(\.theme, Theme())
}
