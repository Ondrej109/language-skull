import SwiftUI

struct AvatarView: View {
    @Environment(\.theme) private var theme

    var body: some View {
        Image(systemName: "person.circle.fill")
            .font(.title2)
            .foregroundStyle(theme.highlight)
            .accessibilityLabel("User menu")
            .accessibilityHint("Opens profile and settings options")
    }
}

#Preview {
    AvatarView()
        .environment(\.theme, Theme())
        .padding()
        .background(Color.black)
}
