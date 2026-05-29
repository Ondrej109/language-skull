import SwiftUI
import SwiftData

struct ProfileTabView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var modelContext

    let profile: UserProfile

    @State private var viewModel: ProfileViewModel?

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    content(viewModel: viewModel)
                } else {
                    ProgressView("Loading profile…")
                        .tint(theme.highlight)
                }
            }
            .navigationTitle("Profile")
            .avatarToolbar(profile: profile)
            .task {
                if viewModel == nil {
                    let vm = ProfileViewModel(modelContext: modelContext, profile: profile)
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
    private func content(viewModel: ProfileViewModel) -> some View {
        if viewModel.isLoading {
            ProgressView()
                .tint(theme.highlight)
        } else {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    profileHeader

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        StatCard(title: "Streak", value: "\(viewModel.currentStreak)", subtitle: "days", icon: "flame.fill")
                        StatCard(title: "Study Day", value: "\(viewModel.studyPlanDay)", subtitle: "current", icon: "calendar")
                        StatCard(title: "Words", value: "\(viewModel.wordsLearned)", subtitle: "in course", icon: "text.book.closed")
                        StatCard(title: "Phrases", value: "\(viewModel.phrasesLearned)", subtitle: "in course", icon: "quote.bubble")
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Current Plan")
                            .font(.headline)
                            .foregroundStyle(theme.textSecondary)

                        VStack(alignment: .leading, spacing: 8) {
                            LabeledContent("Course", value: viewModel.courseName)
                            LabeledContent("Language", value: profile.targetLanguage)
                            LabeledContent("Level", value: profile.proficiencyLevel.displayName)
                            LabeledContent("Plan", value: profile.subscriptionStatus?.isPro == true ? "Pro" : "Free Trial")
                        }
                        .font(.subheadline)
                        .foregroundStyle(theme.textPrimary)
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                    }
                }
                .padding(20)
            }
        }
    }

    private var profileHeader: some View {
        HStack(spacing: 16) {
            AvatarView()
                .scaleEffect(1.4)
                .padding(.trailing, 8)

            VStack(alignment: .leading, spacing: 6) {
                Text(profile.firstName ?? "Guest")
                    .font(.title.bold())
                    .foregroundStyle(theme.textPrimary)
                Text("Language Skull member")
                    .font(.subheadline)
                    .foregroundStyle(theme.textSecondary)
            }

            Spacer()
        }
    }
}

struct StatCard: View {
    @Environment(\.theme) private var theme

    let title: String
    let value: String
    let subtitle: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(title, systemImage: icon)
                .font(.caption.weight(.semibold))
                .foregroundStyle(theme.textSecondary)

            Text(value)
                .font(.title.bold())
                .foregroundStyle(theme.textPrimary)

            Text(subtitle)
                .font(.caption2)
                .foregroundStyle(theme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(theme.accent.opacity(0.25), lineWidth: 1)
        }
    }
}

#Preview {
    ProfileTabView(profile: PreviewData.sampleProfile)
        .environment(\.theme, Theme())
        .environment(AppNavigationState())
        .modelContainer(PreviewData.previewContainer)
}
