import SwiftUI

struct MarkAsDoneButton: View {
    @Environment(\.theme) private var theme

    let isCompleted: Bool
    var allowsRedo: Bool = false
    let action: () -> Void

    @State private var animateCompletion = false

    private var isActionable: Bool {
        !isCompleted || allowsRedo
    }

    private var buttonTitle: String {
        if isCompleted {
            return allowsRedo ? "Re-do Activity" : "Completed"
        }
        return "Mark as Done"
    }

    var body: some View {
        Button {
            guard isActionable else { return }
            HapticService.mediumImpact()
            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                animateCompletion = true
            }
            action()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .symbolEffect(.bounce, value: animateCompletion)
                Text(buttonTitle)
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                isCompleted && !allowsRedo ? theme.surface.opacity(0.8) : theme.accent,
                in: RoundedRectangle(cornerRadius: 16, style: .continuous)
            )
            .foregroundStyle(isCompleted && !allowsRedo ? theme.highlight : theme.textPrimary)
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(theme.highlight.opacity(isCompleted ? 0.5 : 0), lineWidth: 1)
            }
            .scaleEffect(animateCompletion && !isCompleted ? 1.02 : 1)
        }
        .disabled(!isActionable)
        .accessibilityLabel(
            isCompleted
                ? (allowsRedo ? "Re-do activity" : "Activity completed")
                : "Mark activity as done"
        )
        .onAppear {
            animateCompletion = isCompleted
        }
        .onChange(of: isCompleted) { _, completed in
            if completed {
                HapticService.success()
                animateCompletion = true
            }
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        MarkAsDoneButton(isCompleted: false) {}
        MarkAsDoneButton(isCompleted: true) {}
    }
    .padding()
    .background(Color.black)
    .environment(\.theme, Theme())
}
