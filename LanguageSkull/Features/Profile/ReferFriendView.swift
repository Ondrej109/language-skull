import SwiftUI

struct ReferFriendView: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    private let message = """
    I've been training with Language Skull — structured morning and evening sessions that actually stick. \
    Want to try it with me?
    """

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "person.2.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(theme.highlight)

                Text("Invite someone to train with you")
                    .font(.title2.bold())
                    .foregroundStyle(theme.textPrimary)
                    .multilineTextAlignment(.center)

                Text(message)
                    .font(.body)
                    .foregroundStyle(theme.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                ShareLink(item: message) {
                    Label("Share Invite", systemImage: "square.and.arrow.up")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                }
                .buttonStyle(.borderedProminent)
                .tint(theme.accent)
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top, 32)
            .appBackground(theme)
            .navigationTitle("Refer a Friend")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    ReferFriendView()
        .environment(\.theme, Theme())
}
