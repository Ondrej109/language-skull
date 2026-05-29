import SwiftUI

struct GrammarParagraphView: View {
    @Environment(\.theme) private var theme

    let sectionNumber: Int?
    let items: [StudyContentItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if items.isEmpty {
                emptyState
            } else {
                ForEach(items) { item in
                    VStack(alignment: .leading, spacing: 14) {
                        if let sectionNumber {
                            Text("Section \(sectionNumber)")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(theme.highlight)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(theme.accent.opacity(0.35), in: Capsule())
                        }

                        Text(item.grammarTitle ?? item.english)
                            .font(.title2.bold())
                            .foregroundStyle(theme.textPrimary)

                        Text(item.foreign)
                            .font(.title3)
                            .foregroundStyle(theme.textSecondary)
                            .lineSpacing(6)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(22)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(theme.accent.opacity(0.25), lineWidth: 1)
                    }
                    .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Grammar content will appear here once sections are imported.")
                .foregroundStyle(theme.textSecondary)
            Text("You can still mark this activity complete after reviewing your notes.")
                .font(.footnote)
                .foregroundStyle(theme.textSecondary.opacity(0.85))
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    ScrollView {
        GrammarParagraphView(
            sectionNumber: 1,
            items: [
                StudyContentItem(
                    id: "g1",
                    english: "Basic Greetings",
                    foreign: "Hola = Hello\nBuenos días = Good morning\nBuenas tardes = Good afternoon",
                    kind: .grammar,
                    grammarTitle: "Basic Greetings"
                )
            ]
        )
        .padding()
    }
    .background(Color.black)
    .environment(\.theme, Theme())
}
