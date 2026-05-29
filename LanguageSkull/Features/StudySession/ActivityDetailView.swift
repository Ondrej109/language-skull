import SwiftUI
import SwiftData

struct ActivityDetailView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let activity: ResolvedActivity
    let profile: UserProfile
    let viewingDate: Date
    var allowsRedo: Bool = false
    var onMarkedDone: (() -> Void)?

    @State private var isMarkedDone = false

    private var isPastDay: Bool {
        !Calendar.current.isDateInToday(viewingDate)
    }

    private var canRedo: Bool {
        allowsRedo || isPastDay
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header
                activityContent
                MarkAsDoneButton(
                    isCompleted: isMarkedDone || activity.isCompleted,
                    allowsRedo: canRedo
                ) {
                    markDone()
                }
            }
            .padding()
        }
        .navigationTitle(activity.title)
        .navigationBarTitleDisplayMode(.inline)
        .appBackground(theme)
        .onAppear {
            isMarkedDone = activity.isCompleted
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(activity.title)
                .font(.title.bold())
                .foregroundStyle(theme.textPrimary)
            Text(activity.subtitle)
                .font(.subheadline)
                .foregroundStyle(theme.textSecondary)
        }
    }

    @ViewBuilder
    private var activityContent: some View {
        switch activity.type {
        case .newWordsList, .revisionWordsD1, .revisionWordsD3,
             .newPhrasesList, .revisionPhrasesD1, .revisionPhrasesD3:
            TwoColumnListView(
                showsHeader: false,
                title: activity.title,
                subtitle: activity.subtitle,
                pairs: activity.items.map {
                    DemoWordPair(id: $0.id, english: $0.english, foreign: $0.foreign)
                }
            )

        case .newWordsFlashcardsEF, .newWordsFlashcardsFE,
             .newPhrasesFlashcardsEF, .newPhrasesFlashcardsFE:
            FlashcardView(
                items: activity.items,
                showForeignFirst: activity.type == .newWordsFlashcardsFE || activity.type == .newPhrasesFlashcardsFE
            )

        case .grammarParagraph:
            GrammarParagraphView(
                sectionNumber: Int(activity.metadata["sectionNumber"] ?? ""),
                items: activity.items
            )
        }
    }

    private func markDone() {
        Task {
            let repository = ProgressRepository(modelContext: modelContext)
            do {
                try repository.markCompleted(
                    activityId: activity.id,
                    user: profile,
                    date: viewingDate
                )
                isMarkedDone = true
                NotificationCenter.default.post(name: .studyProgressDidUpdate, object: nil)
                onMarkedDone?()

                try await Task.sleep(for: .milliseconds(650))
                dismiss()
            } catch {
                print("Mark done error: \(error)")
            }
        }
    }
}

#Preview("List") {
    NavigationStack {
        ActivityDetailView(
            activity: ResolvedActivity(
                id: "preview",
                type: .newWordsList,
                order: 0,
                timeOfDay: .morning,
                title: "New Words",
                subtitle: "Day 1 · 4 items",
                items: TwoColumnListView.spanishDemoPairs.map {
                    StudyContentItem(id: $0.id, english: $0.english, foreign: $0.foreign, kind: .word)
                },
                isCompleted: false,
                metadata: [:]
            ),
            profile: PreviewData.sampleProfile,
            viewingDate: .now
        )
    }
    .environment(\.theme, Theme())
}

#Preview("Flashcards") {
    NavigationStack {
        ActivityDetailView(
            activity: ResolvedActivity(
                id: "preview_flash",
                type: .newWordsFlashcardsEF,
                order: 0,
                timeOfDay: .morning,
                title: "Flashcards E → F",
                subtitle: "Day 1 · 4 items",
                items: TwoColumnListView.spanishDemoPairs.map {
                    StudyContentItem(id: $0.id, english: $0.english, foreign: $0.foreign, kind: .word)
                },
                isCompleted: false,
                metadata: [:]
            ),
            profile: PreviewData.sampleProfile,
            viewingDate: .now
        )
    }
    .environment(\.theme, Theme())
}
