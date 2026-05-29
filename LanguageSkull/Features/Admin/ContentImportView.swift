import SwiftUI
import UniformTypeIdentifiers
import SwiftData

struct ContentImportView: View {
    @Environment(\.theme) private var theme
    @Bindable var viewModel: AdminViewModel

    @State private var showFileImporter = false
    @State private var showFolderImporter = false
    @State private var pendingURLs: [URL] = []

    var body: some View {
        Form {
            Section {
                Picker("Import Mode", selection: $viewModel.selectedImportMode) {
                    ForEach(ContentImportMode.allCases, id: \.self) { mode in
                        Text(mode.rawValue.capitalized).tag(mode)
                    }
                }

                Button("Import Individual Files") { showFileImporter = true }
                Button("Import Language Folder") { showFolderImporter = true }

                if viewModel.isImporting {
                    ProgressView("Importing content…")
                }
            } footer: {
                Text("Replace overwrites words/phrases/grammar for the course. Merge updates existing IDs and adds new ones. User progress is never deleted.")
            }

            if let validation = viewModel.validation {
                Section("Validation") {
                    LabeledContent("Language", value: validation.languageName)
                    LabeledContent("Words", value: "\(validation.wordCount)")
                    LabeledContent("Phrases", value: "\(validation.phraseCount)")
                    LabeledContent("Grammar", value: "\(validation.grammarSectionCount)")
                    ForEach(validation.warnings, id: \.self) { warning in
                        Text(warning)
                            .font(.footnote)
                            .foregroundStyle(theme.highlight)
                    }
                }
            }

            if let statusMessage = viewModel.statusMessage {
                Section {
                    Text(statusMessage)
                        .foregroundStyle(theme.highlight)
                }
            }

            if let errorMessage = viewModel.errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("Import Content")
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [.json, .plainText, .text],
            allowsMultipleSelection: true
        ) { result in
            handleSelection(result)
        }
        .fileImporter(
            isPresented: $showFolderImporter,
            allowedContentTypes: [.folder],
            allowsMultipleSelection: false
        ) { result in
            switch result {
            case .success(let urls):
                guard let folder = urls.first else { return }
                Task { await viewModel.importFolder(folder) }
            case .failure(let error):
                viewModel.reportError(error.localizedDescription)
            }
        }
    }

    private func handleSelection(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            pendingURLs = urls
            Task {
                await viewModel.validateFiles(urls)
                await viewModel.importFiles(urls)
            }
        case .failure(let error):
            viewModel.reportError(error.localizedDescription)
        }
    }
}

#Preview {
    NavigationStack {
        ContentImportView(viewModel: AdminViewModel(modelContext: PreviewData.previewContainer.mainContext))
    }
    .environment(\.theme, Theme())
}
