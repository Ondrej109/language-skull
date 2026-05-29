import SwiftUI

struct FlashcardView: View {
    @Environment(\.theme) private var theme

    let items: [StudyContentItem]
    let showForeignFirst: Bool

    @State private var index = 0
    @State private var isFlipped = false
    @State private var dragOffset: CGSize = .zero
    @State private var cardTransition: CGFloat = 0

    private let swipeThreshold: CGFloat = 120

    private var current: StudyContentItem? {
        guard items.indices.contains(index) else { return nil }
        return items[index]
    }

    var body: some View {
        VStack(spacing: 18) {
            progressHeader

            if let current {
                ZStack {
                    cardStack(for: current)
                        .offset(x: dragOffset.width + cardTransition)
                        .rotationEffect(.degrees(Double(dragOffset.width / 18)))
                        .gesture(dragGesture)
                        .onTapGesture { flipCard() }
                }
                .frame(height: 320)

                Text("Tap to flip · Swipe to continue")
                    .font(.caption)
                    .foregroundStyle(theme.textSecondary)

                HStack(spacing: 24) {
                    Button {
                        movePrevious()
                    } label: {
                        Label("Previous", systemImage: "chevron.left")
                    }
                    .disabled(index == 0)

                    Button {
                        advanceCard()
                    } label: {
                        Label("Next", systemImage: "chevron.right")
                    }
                    .disabled(index >= items.count - 1)
                }
                .font(.subheadline.weight(.medium))
                .foregroundStyle(theme.highlight)
            } else {
                Text("No items scheduled for this activity.")
                    .foregroundStyle(theme.textSecondary)
                    .padding(.vertical, 40)
            }
        }
    }

    private var progressHeader: some View {
        VStack(spacing: 8) {
            HStack {
                Text("\(min(index + 1, max(items.count, 1))) of \(max(items.count, 1))")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(theme.textSecondary)
                Spacer()
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule().fill(theme.surface.opacity(0.6))
                    Capsule()
                        .fill(theme.accent)
                        .frame(width: geometry.size.width * progress)
                }
            }
            .frame(height: 4)
        }
    }

    private var progress: Double {
        guard !items.isEmpty else { return 0 }
        return Double(index + 1) / Double(items.count)
    }

    private func cardStack(for item: StudyContentItem) -> some View {
        ZStack {
            cardFace(text: frontText(for: item), label: frontLabel)
                .opacity(isFlipped ? 0 : 1)
                .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))

            cardFace(text: backText(for: item), label: backLabel)
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))
        }
        .animation(.spring(response: 0.48, dampingFraction: 0.82), value: isFlipped)
    }

    private func cardFace(text: String, label: String) -> some View {
        VStack(spacing: 14) {
            Text(label.uppercased())
                .font(.caption.weight(.semibold))
                .foregroundStyle(theme.highlight.opacity(0.85))
                .tracking(1.2)

            Text(text)
                .font(.system(size: 34, weight: .semibold, design: .serif))
                .foregroundStyle(theme.textPrimary)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.6)
                .padding(.horizontal, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(24)
        .background {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.regularMaterial)
                .overlay {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(theme.accent.opacity(0.35), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.35), radius: 18, y: 10)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label), \(text)")
    }

    private var frontLabel: String {
        showForeignFirst ? "Foreign" : "English"
    }

    private var backLabel: String {
        showForeignFirst ? "English" : "Foreign"
    }

    private func frontText(for item: StudyContentItem) -> String {
        showForeignFirst ? item.foreign : item.english
    }

    private func backText(for item: StudyContentItem) -> String {
        showForeignFirst ? item.english : item.foreign
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = value.translation
            }
            .onEnded { value in
                let horizontal = value.translation.width
                if horizontal > swipeThreshold {
                    movePrevious(withHaptic: true)
                } else if horizontal < -swipeThreshold {
                    advanceCard(withHaptic: true)
                } else {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        dragOffset = .zero
                    }
                }
            }
    }

    private func flipCard() {
        HapticService.lightImpact()
        withAnimation { isFlipped.toggle() }
    }

    private func advanceCard(withHaptic: Bool = false) {
        guard index < items.count - 1 else {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) { dragOffset = .zero }
            return
        }
        if withHaptic { HapticService.lightImpact() }

        withAnimation(.spring(response: 0.42, dampingFraction: 0.86)) {
            cardTransition = -420
            dragOffset = .zero
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
            index += 1
            isFlipped = false
            cardTransition = 420
            withAnimation(.spring(response: 0.45, dampingFraction: 0.86)) {
                cardTransition = 0
            }
        }
    }

    private func movePrevious(withHaptic: Bool = false) {
        guard index > 0 else {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) { dragOffset = .zero }
            return
        }
        if withHaptic { HapticService.lightImpact() }

        withAnimation(.spring(response: 0.42, dampingFraction: 0.86)) {
            cardTransition = 420
            dragOffset = .zero
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
            index -= 1
            isFlipped = false
            cardTransition = -420
            withAnimation(.spring(response: 0.45, dampingFraction: 0.86)) {
                cardTransition = 0
            }
        }
    }
}

#Preview {
    FlashcardView(
        items: TwoColumnListView.spanishDemoPairs.map {
            StudyContentItem(id: $0.id, english: $0.english, foreign: $0.foreign, kind: .word)
        },
        showForeignFirst: false
    )
    .padding()
    .background(Color.black)
    .environment(\.theme, Theme())
}

#Preview("D-3 Session") {
    FlashcardView(
        items: [
            StudyContentItem(id: "1", english: "Hello", foreign: "Hola", kind: .word, dayIntroduced: 1, sortOrder: 0),
            StudyContentItem(id: "2", english: "Goodbye", foreign: "Adiós", kind: .word, dayIntroduced: 1, sortOrder: 1),
            StudyContentItem(id: "3", english: "Thank you", foreign: "Gracias", kind: .word, dayIntroduced: 2, sortOrder: 2)
        ],
        showForeignFirst: false
    )
    .padding()
    .background(Color.black)
    .environment(\.theme, Theme())
}
