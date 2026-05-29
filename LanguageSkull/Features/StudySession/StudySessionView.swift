import SwiftUI
import SwiftData

struct StudySessionView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var modelContext

    let profile: UserProfile
    let timeOfDay: TimeOfDay
    var viewingDate: Date = .now

    @State private var viewModel: StudySessionViewModel?
    @State private var showCelebration = false
    @State private var didCelebrateThisVisit = false

    private var title: String {
        timeOfDay == .morning ? "Morning Session" : "Evening Session"
    }

    var body: some View {
        Group {
            if let viewModel {
                content(viewModel: viewModel)
            } else {
                ProgressView("Loading session…")
                    .tint(theme.highlight)
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .appBackground(theme)
        .task {
            if viewModel == nil {
                let vm = StudySessionViewModel(
                    modelContext: modelContext,
                    profile: profile,
                    timeOfDay: timeOfDay,
                    viewingDate: viewingDate
                )
                viewModel = vm
                await vm.load()
            }
        }
        .onAppear {
            Task { await viewModel?.load() }
        }
        .fullScreenCover(isPresented: $showCelebration) {
            SessionCompletionView(timeOfDay: timeOfDay) {
                showCelebration = false
            }
        }
    }

    @ViewBuilder
    private func content(viewModel: StudySessionViewModel) -> some View {
        if viewModel.isLoading {
            ProgressView("Assembling activities…")
                .tint(theme.highlight)
        } else if let errorMessage = viewModel.errorMessage {
            ContentUnavailableView {
                Label("Session Unavailable", systemImage: "exclamationmark.triangle")
            } description: {
                Text(errorMessage)
            }
        } else if let summary = viewModel.summary {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Study Day \(summary.studyPlanDay)")
                        .font(.headline)
                        .foregroundStyle(theme.highlight)

                    Text("\(summary.completedCount) of \(summary.totalCount) activities complete")
                        .font(.subheadline)
                        .foregroundStyle(theme.textSecondary)

                    ProgressRing(progress: summary.progress, label: title)

                    ForEach(summary.activities) { activity in
                        NavigationLink {
                            ActivityDetailView(
                                activity: activity,
                                profile: profile,
                                viewingDate: viewingDate,
                                allowsRedo: !Calendar.current.isDateInToday(viewingDate),
                                onMarkedDone: {
                                    Task {
                                        await viewModel.load()
                                        evaluateCelebration(viewModel, userTriggered: true)
                                    }
                                }
                            )
                        } label: {
                            ActivityRow(
                                activity: activity,
                                allowsRedo: !Calendar.current.isDateInToday(viewingDate)
                            )
                        }
                        .buttonStyle(.plain)
                        .opacity(activity.isCompleted ? 0.72 : 1)
                    }
                }
                .padding()
            }
        }
    }

    private func evaluateCelebration(_ viewModel: StudySessionViewModel, userTriggered: Bool) {
        guard userTriggered else { return }
        guard !didCelebrateThisVisit else { return }
        guard let summary = viewModel.summary else { return }
        guard summary.totalCount > 0, summary.completedCount == summary.totalCount else { return }

        didCelebrateThisVisit = true
        showCelebration = true
        NotificationCenter.default.post(name: .studyProgressDidUpdate, object: nil)
    }
}

struct ActivityRow: View {
    @Environment(\.theme) private var theme
    let activity: ResolvedActivity
    var allowsRedo: Bool = false

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: activity.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(activity.isCompleted ? theme.highlight : theme.textSecondary)
                .font(.title3)

            VStack(alignment: .leading, spacing: 4) {
                Text(activity.title)
                    .font(.headline)
                    .foregroundStyle(theme.textPrimary)
                Text(activity.subtitle)
                    .font(.caption)
                    .foregroundStyle(theme.textSecondary)
            }

            Spacer()

            if activity.isCompleted {
                Text(allowsRedo ? "Re-do" : "Done")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(theme.highlight)
            } else {
                Image(systemName: "chevron.right")
                    .font(.caption.bold())
                    .foregroundStyle(theme.textSecondary)
            }
        }
        .padding()
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14))
        .overlay {
            RoundedRectangle(cornerRadius: 14)
                .stroke(
                    activity.isCompleted ? theme.highlight.opacity(0.45) : theme.accent.opacity(0.25),
                    lineWidth: 1
                )
        }
    }
}

#Preview {
    NavigationStack {
        StudySessionView(
            profile: PreviewData.sampleProfile,
            timeOfDay: .morning
        )
    }
    .environment(\.theme, Theme())
    .modelContainer(PreviewData.previewContainer)
}
