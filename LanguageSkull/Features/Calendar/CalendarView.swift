import SwiftUI
import SwiftData

struct CalendarView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var modelContext

    let profile: UserProfile

    @State private var viewModel: CalendarViewModel?

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    content(viewModel: viewModel)
                } else {
                    ProgressView("Loading calendar…")
                        .tint(theme.highlight)
                }
            }
            .navigationTitle("Calendar")
            .avatarToolbar(profile: profile)
            .task {
                if viewModel == nil {
                    let vm = CalendarViewModel(modelContext: modelContext, profile: profile)
                    viewModel = vm
                    await vm.load()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .studyProgressDidUpdate)) { _ in
                Task { await viewModel?.load() }
            }
        }
        .appBackground(theme)
    }

    @ViewBuilder
    private func content(viewModel: CalendarViewModel) -> some View {
        if viewModel.isLoading {
            ProgressView()
                .tint(theme.highlight)
        } else if let errorMessage = viewModel.errorMessage {
            ContentUnavailableView {
                Label("Calendar Unavailable", systemImage: "calendar.badge.exclamationmark")
            } description: {
                Text(errorMessage)
            }
        } else {
            List(viewModel.days) { day in
                NavigationLink {
                    DayDetailView(profile: profile, date: day.date, studyPlanDay: day.studyPlanDay)
                } label: {
                    CalendarDayRow(day: day)
                }
                .listRowBackground(theme.surface.opacity(0.35))
            }
            .scrollContentBackground(.hidden)
        }
    }
}

struct CalendarDayRow: View {
    @Environment(\.theme) private var theme
    let day: CalendarDaySummary

    private var dateLabel: String {
        day.date.formatted(date: .abbreviated, time: .omitted)
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(dateLabel)
                    .font(.headline)
                    .foregroundStyle(theme.textPrimary)
                Text("Study Day \(day.studyPlanDay)")
                    .font(.caption)
                    .foregroundStyle(theme.textSecondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("☀️ \(day.morningCompleted)/\(day.morningTotal)")
                    .font(.caption)
                Text("🌙 \(day.eveningCompleted)/\(day.eveningTotal)")
                    .font(.caption)
            }
            .foregroundStyle(theme.textSecondary)

            if day.isFullyComplete {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(theme.highlight)
            }
        }
    }
}

#Preview {
    CalendarView(profile: PreviewData.sampleProfile)
        .environment(\.theme, Theme())
        .environment(AppNavigationState())
        .modelContainer(PreviewData.previewContainer)
}
