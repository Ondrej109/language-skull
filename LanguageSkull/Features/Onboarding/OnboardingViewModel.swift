import Foundation
import SwiftData

@Observable
@MainActor
final class OnboardingViewModel {
    private(set) var currentStep: OnboardingStep = .launch
    private(set) var isProcessing = false
    var errorMessage: String?                   // ← Remove private(set)
    private(set) var contentFallbackMessage: String?
    private(set) var guestProfile: UserProfile?

    var firstName: String = ""
    var selectedLanguage: LanguageOption?
    var selectedProficiency: ProficiencyLevel = .beginner
    var notificationsEnabled = false

    let languageOptions = LanguageOption.localeAwareOptions()

    private let modelContext: ModelContext
    private let userRepository: UserRepository
    private let contentSeeder: ContentSeeder
    private let authService = AuthService()

    var onComplete: (() -> Void)?

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.userRepository = UserRepository(modelContext: modelContext)
        self.contentSeeder = ContentSeeder(modelContainer: modelContext.container)
    }

    func bootstrap() {
            do {
                if let profile = try userRepository.fetchCurrentProfile(), profile.hasCompletedOnboarding {
                    onComplete?()
                    return
                }

                if let savedStep = OnboardingStateStore.loadStep(), savedStep != .launch {
                    currentStep = savedStep
                    guestProfile = try userRepository.fetchGuestProfile()
                }
            } catch {
                errorMessage = error.localizedDescription
            }
        }

    func beginTraining() {
        errorMessage = nil
        do {
            guestProfile = try userRepository.createGuestProfile()
            advance(to: .quickDemo)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func skipQuickDemo() {
        advance(to: .firstName)
    }

    func completeQuickDemo() {
        advance(to: .firstName)
    }

    func submitFirstName() {
        advance(to: .language)
    }

    func selectLanguage(_ language: LanguageOption) {
        selectedLanguage = language
        advance(to: .proficiency)
    }

    func selectProficiency(_ level: ProficiencyLevel) {
        selectedProficiency = level
        advance(to: .notifications)
    }

    func handleNotificationChoice(requestPermission: Bool) async {
        if requestPermission {
            notificationsEnabled = await NotificationService.shared.requestMorningReminderPermission()
        } else {
            notificationsEnabled = false
        }
        persistDraftProfile()
        advance(to: .appleSignIn)
    }

    func continueAsGuest() async {
        await finalizeOnboarding(signedInProfile: nil)
    }

    func signInWithApple() async {
        isProcessing = true
        errorMessage = nil

        do {
            let result = try await authService.signInWithApple()
            if guestProfile == nil {
                guestProfile = try userRepository.fetchGuestProfile() ?? userRepository.createGuestProfile()
            }
            guard let guest = guestProfile else {
                throw AuthServiceError.failed("Guest profile missing.")
            }
            persistDraftProfile(on: guest)
            let profile = try userRepository.applyAppleSignIn(result: result, guestProfile: guest)
            guestProfile = profile
            await finalizeOnboarding(signedInProfile: profile)
        } catch AuthServiceError.cancelled {
            // User cancelled — remain on sign-in step.
        } catch {
            errorMessage = error.localizedDescription
        }

        isProcessing = false
    }

    private func finalizeOnboarding(signedInProfile: UserProfile?) async {
        isProcessing = true
        errorMessage = nil
        advance(to: .seeding)

        do {
            let profile: UserProfile

            if let signedIn = signedInProfile {
                profile = signedIn
            } else if let guest = guestProfile {
                profile = guest
            } else {
                profile = try userRepository.createGuestProfile()
            }

            persistDraftProfile(on: profile)

            let language = selectedLanguage?.id ?? profile.targetLanguage
            let seededLanguage = try await contentSeeder.seedContentForOnboarding(
                language: language,
                profileID: profile.persistentModelID
            )

            if seededLanguage != language {
                contentFallbackMessage = "\(language) content isn't available yet. We've loaded Spanish for now."
            }

            try userRepository.completeOnboarding(for: profile)
            onComplete?()
        } catch {
            errorMessage = error.localizedDescription
            advance(to: .appleSignIn)
        }

        isProcessing = false
    }
    private func persistDraftProfile(on profile: UserProfile? = nil) {
        guard let profile = profile ?? guestProfile else { return }
        do {
            try userRepository.updateProfile(
                profile,
                firstName: firstName,
                targetLanguage: selectedLanguage?.id ?? profile.targetLanguage,
                proficiencyLevel: selectedProficiency,
                notificationEnabled: notificationsEnabled
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func advance(to step: OnboardingStep) {
            currentStep = step
            OnboardingStateStore.saveStep(step)
        }
}
