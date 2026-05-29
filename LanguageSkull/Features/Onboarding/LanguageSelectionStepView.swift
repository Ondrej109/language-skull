import SwiftUI
import SwiftData

struct LanguageSelectionStepView: View {
    @Environment(\.theme) private var theme
    @Bindable var viewModel: OnboardingViewModel

    var body: some View {
        OnboardingQuestionContainer(
            step: 2,
            title: "Choose your language",
            subtitle: "We'll build your daily Morning and Evening plan around it."
        ) {
            VStack(spacing: 10) {
                ForEach(viewModel.languageOptions) { language in
                    Button {
                        viewModel.selectLanguage(language)
                    } label: {
                        HStack(spacing: 14) {
                            Text(language.flag)
                                .font(.title2)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(language.nativeName)
                                    .font(.headline)
                                    .foregroundStyle(theme.textPrimary)
                                Text(language.englishName)
                                    .font(.caption)
                                    .foregroundStyle(theme.textSecondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption.bold())
                                .foregroundStyle(theme.highlight.opacity(0.7))
                        }
                        .padding()
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14))
                        .overlay {
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(
                                    viewModel.selectedLanguage == language ? theme.highlight : theme.accent.opacity(0.2),
                                    lineWidth: viewModel.selectedLanguage == language ? 2 : 1
                                )
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("\(language.englishName), \(language.nativeName)")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        LanguageSelectionStepView(viewModel: OnboardingViewModel(modelContext: PreviewData.previewContainer.mainContext))
    }
    .environment(\.theme, Theme())
}
