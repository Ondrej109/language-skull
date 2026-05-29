import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var modelContext

    let profile: UserProfile
    var openMorningSessionOnAppear: Bool = false

    @State private var viewModel: HomeViewModel?
    @State private var showMorningSession = false

    var body: some View {
        NavigationStack {
            ZStack {
                skullWatermark

                Group {
                    if let viewModel {
                        content(viewModel: viewModel)
                    } else {
                        ProgressView("Loading…")
                            .tint(theme.highlight)
                    }
                }
            }
            .navigationTitle(viewModel?.courseName ?? "Home")
            .navigationBarTitleDisplayMode(.large)
            .avatarToolbar(profile: profile)
            .navigationDestination(isPresented: $showMorningSession) {
                StudySessionView(profile: profile, timeOfDay: .morning)
            }
            .task {
                if viewModel == nil {
                    let vm = HomeViewModel(modelContext: modelContext, profile: profile)
                    viewModel = vm
                    await vm.load()
                }
            }
            .onAppear {
                if openMorningSessionOnAppear, !showMorningSession {
                    showMorningSession = true
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .studyProgressDidUpdate)) { _ in
                Task { await viewModel?.load() }
            }
        }
        .appBackground(theme)
    }

    private var skullWatermark: some View {
        Image(systemName: "skull")
            .font(.system(size: 180, weight: .ultraLight))
            .foregroundStyle(theme.highlight.opacity(0.04))
            .offset(x: 120, y: -40)
            .allowsHitTesting(false)
    }

    @ViewBuilder
    private func content(viewModel: HomeViewModel) -> some View {
        if viewModel.isLoading {
            ProgressView("Preparing your day…")
                .tint(theme.highlight)
        } else if let errorMessage = viewModel.errorMessage {
            ContentUnavailableView {
                Label("Unable to Load", systemImage: "exclamationmark.triangle")
            } description: {
                Text(errorMessage)
            }
        } else if viewModel.isEmptyPlan {
            ContentUnavailableView {
                Label("No Plan Yet", systemImage: "skull")
            } description: {
                Text("Your study plan will appear here once content is seeded.")
            }
        } else {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(viewModel.greeting)
                            .font(.title.bold())
                            .foregroundStyle(theme.textPrimary)

                        Text("Today · Study Day \(viewModel.studyPlanDay)")
                            .font(.subheadline)
                            .foregroundStyle(theme.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(spacing: 18) {
                        NavigationLink {
                            StudySessionView(profile: profile, timeOfDay: .morning)
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
                            StudySessionView(profile: profile, timeOfDay: .evening)
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
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
        }
    }
}

#Preview("Populated") {
    HomeView(profile: PreviewData.sampleProfile)
        .environment(\.theme, Theme())
        .environment(AppNavigationState())
        .modelContainer(PreviewData.previewContainer)
}
