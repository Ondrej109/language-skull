import SwiftUI

struct Theme: Sendable {
    let background = Color(hex: 0x050505)
    let surface = Color(hex: 0x111111)
    let accent = Color(hex: 0x4A1C1C)
    let highlight = Color(hex: 0xD4C4A8)
    let textPrimary = Color.white
    let textSecondary = Color(hex: 0xE5E5E5)
}

private struct ThemeKey: EnvironmentKey {
    static let defaultValue = Theme()
}

extension EnvironmentValues {
    var theme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

extension View {
    func appBackground(_ theme: Theme) -> some View {
        background(theme.background.ignoresSafeArea())
    }
}

extension Color {
    init(hex: UInt, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}
