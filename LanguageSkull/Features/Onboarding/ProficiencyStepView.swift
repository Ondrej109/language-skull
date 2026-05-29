import SwiftUI
import SwiftData

struct ProficiencyStepView: View {
    @Environment(\.theme) private var theme
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        OnboardingQuestionContainer(
            step: 3,
            title: "What's your level?",
            subtitle: "This sets your starting day so you're never bored or overwhelmed."
        ) {
            VStack(spacing: 10) {
                ForEach(ProficiencyLevel.allCases, id: \.self) { level in
                    Button {
                        viewModel.selectProficiency(level)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(level.displayName)
                                    .font(.headline)
                                    .foregroundStyle(theme.textPrimary)
                                Text("Starts on Day \(level.startingStudyDay)")
                                    .font(.caption)
                                    .foregroundStyle(theme.textSecondary)
                            }
                            Spacer()
                            if viewModel.selectedProficiency == level {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(theme.highlight)
                            }
                        }
                        .padding()
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14))
                        .overlay {
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(theme.accent.opacity(0.25), lineWidth: 1)
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("\(level.displayName), starting day \(level.startingStudyDay)")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProficiencyStepView(viewModel: OnboardingViewModel(modelContext: PreviewData.previewContainer.mainContext))
    }
    .environment(\.theme, Theme())
}
