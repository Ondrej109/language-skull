import SwiftData
import SwiftUI

@main
struct LanguageSkullApp: App {
    @State private var featureFlags = FeatureFlagStore()
    @State private var navigationState = AppNavigationState()

    private let modelContainer: ModelContainer

    init() {
        do {
            modelContainer = try LanguageSkullModelContainer.makeContainer()
        } catch {
            fatalError("Failed to create ModelContainer: \(error.localizedDescription)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView(featureFlags: featureFlags)
                .environment(\.theme, Theme())
                .environment(navigationState)
                .modelContainer(modelContainer)
        }
    }
}
