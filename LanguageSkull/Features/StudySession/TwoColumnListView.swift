import SwiftUI

struct DemoWordPair: Identifiable, Hashable {
    let id: String
    let english: String
    let foreign: String
}

struct TwoColumnListView: View {
    @Environment(\.theme) private var theme

    var showsHeader: Bool = true
    let title: String
    let subtitle: String
    let pairs: [DemoWordPair]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if showsHeader {
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.title2.bold())
                        .foregroundStyle(theme.textPrimary)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(theme.textSecondary)
                }
            }

            VStack(spacing: 0) {
                HStack {
                    Text("English")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(theme.highlight)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Translation")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(theme.highlight)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .background(theme.surface.opacity(0.65))

                LazyVStack(spacing: 0) {
                    ForEach(Array(pairs.enumerated()), id: \.element.id) { index, pair in
                        HStack(alignment: .firstTextBaseline, spacing: 16) {
                            Text(pair.english)
                                .font(.title3)
                                .foregroundStyle(theme.textPrimary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(pair.foreign)
                                .font(.title3)
                                .foregroundStyle(theme.textSecondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 18)
                        .background(rowBackground(for: index))
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("\(pair.english), \(pair.foreign)")
                    }
                }
            }
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(theme.accent.opacity(0.28), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.25), radius: 12, y: 6)
        }
    }

    private func rowBackground(for index: Int) -> some View {
        index.isMultiple(of: 2) ? theme.surface.opacity(0.22) : Color.clear
    }
}

extension TwoColumnListView {
    static let spanishDemoPairs: [DemoWordPair] = [
        DemoWordPair(id: "1", english: "Hello", foreign: "Hola"),
        DemoWordPair(id: "2", english: "Goodbye", foreign: "Adiós"),
        DemoWordPair(id: "3", english: "Please", foreign: "Por favor"),
        DemoWordPair(id: "4", english: "Thank you", foreign: "Gracias")
    ]
}

#Preview {
    ScrollView {
        TwoColumnListView(
            title: "New Words",
            subtitle: "English → Spanish",
            pairs: TwoColumnListView.spanishDemoPairs
        )
        .padding()
    }
    .background(Color.black)
    .environment(\.theme, Theme())
}
