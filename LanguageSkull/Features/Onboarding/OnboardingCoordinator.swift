import Foundation

/// Coordinates onboarding step transitions and persistence (docs/03).
enum OnboardingCoordinator {
    static func resumeStep() -> OnboardingStep {
        OnboardingStateStore.loadStep() ?? .launch
    }

    static func persistStep(_ step: OnboardingStep) {
        OnboardingStateStore.saveStep(step)
    }

    static func clearProgress() {
        OnboardingStateStore.clear()
    }
}
