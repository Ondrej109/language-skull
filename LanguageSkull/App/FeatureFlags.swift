import SwiftUI

/// Central feature flags. Admin mode can be disabled before App Store submission.
enum FeatureFlags {
    static let adminModeKey = "feature.adminModeEnabled"

    static var isAdminModeEnabled: Bool {
        get { UserDefaults.standard.bool(forKey: adminModeKey) }
        set { UserDefaults.standard.set(newValue, forKey: adminModeKey) }
    }
}

@Observable
final class FeatureFlagStore {
    var isAdminModeEnabled: Bool {
        didSet { FeatureFlags.isAdminModeEnabled = isAdminModeEnabled }
    }

    init() {
        if UserDefaults.standard.object(forKey: FeatureFlags.adminModeKey) == nil {
            isAdminModeEnabled = true
            FeatureFlags.isAdminModeEnabled = true
        } else {
            isAdminModeEnabled = FeatureFlags.isAdminModeEnabled
        }
    }
}
