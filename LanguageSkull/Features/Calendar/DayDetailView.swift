import SwiftUI
import SwiftData

struct DayDetailView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var modelContext

    let profile: UserProfile
    let date: Date
    let studyPlanDay: Int

    @State private var viewModel: DayDetailViewModel?

    private var allowsRedo: Bool {
        !Calendar.current.isDateInToday(date)
    }

    var body: some View {
        ScrollView {
            if let viewModel {
                VStack(alignment: .leading, spacing: 24) {
                    header

                    if viewModel.isLoading {
                        ProgressView()
                            .tint(theme.highlight)
                            .frame(maxWidth: .infinity)
                    } else {
                        sessionLinks(viewModel: viewModel)
                        activityHistory(viewModel: viewModel)
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Day Detail")
        .navigationBarTitleDisplayMode(.inline)
        .appBackground(theme)
        .task {
            if viewModel == nil {
                let vm = DayDetailViewModel(modelContext: modelContext, profile: profile, date: date)
                viewModel = vm
                await vm.load()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .studyProgressDidUpdate)) { _ in
            Task { await viewModel?.load() }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(date.formatted(date: .complete, time: .omitted))
                .font(.subheadline)
                .foregroundStyle(theme.textSecondary)
            Text("Study Day \(studyPlanDay)")
                .font(.title.bold())
                .foregroundStyle(theme.textPrimary)
        }
    }

    @ViewBuilder
    private func sessionLinks(viewModel: DayDetailViewModel) -> some View {
        VStack(spacing: 16) {
            NavigationLink {
                StudySessionView(profile: profile, timeOfDay: .morning, viewingDate: date)
            } label: {
                SessionCard(
                    title: "Morning",
                    subtitle: viewModel.morningSubtitle,
                    progress: viewModel.morningProgress,
                    systemImage: "sun.max.fill",
                    largeRing: true
                )
            }
            .buttonStyle(.plain)

            NavigationLink {
                StudySessionView(profile: profile, timeOfDay: .evening, viewingDate: date)
            } label: {
                SessionCard(
                    title: "Evening",
                    subtitle: viewModel.eveningSubtitle,
                    progress: viewModel.eveningProgress,
                    systemImage: "moon.stars.fill",
                    largeRing: true
                )
            }
            .buttonStyle(.plain)
        }
    }

    @ViewBuilder
    private func activityHistory(viewModel: DayDetailViewModel) -> some View {
        if !viewModel.activities.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("Activities")
                    .font(.headline)
                    .foregroundStyle(theme.textSecondary)

                ForEach(viewModel.activities) { activity in
                    if let resolved = viewModel.resolvedActivity(for: activity.id) {
                        NavigationLink {
                            ActivityDetailView(
                                activity: resolved,
                                profile: profile,
                                viewingDate: date,
                                allowsRedo: allowsRedo,
                                onMarkedDone: {
                                    Task { await viewModel.load() }
                                }
                            )
                        } label: {
                            DayActivityStatusRow(activity: activity, allowsRedo: allowsRedo)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

struct DayActivityStatusRow: View {
    @Environment(\.theme) private var theme
    let activity: DayActivityRow
    var allowsRedo: Bool = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: activity.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(activity.isCompleted ? theme.highlight : theme.textSecondary)

            VStack(alignment: .leading, spacing: 4) {
                Text(activity.title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(theme.textPrimary)
                Text(activity.subtitle)
                    .font(.caption)
                    .foregroundStyle(theme.textSecondary)

                if let completedAt = activity.completedAt {
                    Text("Completed \(completedAt.formatted(date: .omitted, time: .shortened))")
                        .font(.caption2)
                        .foregroundStyle(theme.highlight.opacity(0.85))
                }
            }

            Spacer()

            if activity.isCompleted && allowsRedo {
                Text("Re-do")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(theme.highlight)
            } else {
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundStyle(theme.textSecondary)
            }
        }
        .padding(14)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
    }
}

#Preview {
    NavigationStack {
        DayDetailView(profile: PreviewData.sampleProfile, date: .now, studyPlanDay: 3)
    }
    .environment(\.theme, Theme())
    .modelContainer(PreviewData.previewContainer)
}
