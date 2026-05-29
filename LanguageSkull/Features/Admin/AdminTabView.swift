import SwiftUI
import SwiftData

struct AdminTabView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var modelContext

    let profile: UserProfile

    @State private var viewModel: AdminViewModel?

    var body: some View {
        NavigationStack {
            Group {
                if let viewModel {
                    List {
                        Section("Content Management") {
                            NavigationLink {
                                ContentImportView(viewModel: viewModel)
                            } label: {
                                Label("Import / Update Content", systemImage: "square.and.arrow.down")
                            }
                        }

                        Section("Loaded Courses") {
                            if viewModel.courses.isEmpty {
                                Text("No courses loaded yet.")
                                    .foregroundStyle(theme.textSecondary)
                            } else {
                                ForEach(viewModel.courses) { course in
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(course.name)
                                            .font(.headline)
                                        Text("\(course.wordCount) words · \(course.phraseCount) phrases · \(course.grammarCount) grammar")
                                            .font(.caption)
                                            .foregroundStyle(theme.textSecondary)
                                        Text("Version: \(course.version)")
                                            .font(.caption2)
                                            .foregroundStyle(theme.textSecondary)
                                    }
                                }
                            }
                        }

                        Section {
                            Text("Study Plan Editor and Preview as Learner arrive in Phase 7.")
                                .font(.footnote)
                                .foregroundStyle(theme.textSecondary)
                        }
                    }
                    .scrollContentBackground(.hidden)
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("Admin")
            .avatarToolbar(profile: profile)
            .onAppear {
                if viewModel == nil {
                    let vm = AdminViewModel(modelContext: modelContext)
                    vm.loadCourses()
                    viewModel = vm
                } else {
                    viewModel?.loadCourses()
                }
            }
        }
        .appBackground(theme)
    }
}

#Preview {
    AdminTabView(profile: PreviewData.sampleProfile)
        .environment(\.theme, Theme())
        .environment(AppNavigationState())
        .modelContainer(PreviewData.previewContainer)
}
