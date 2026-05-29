import UIKit
import AuthenticationServices
import Foundation
import SwiftData

struct AppleSignInResult: Sendable {
    let userID: String
    let firstName: String?
    let email: String?
}

enum AuthServiceError: LocalizedError {
    case cancelled
    case failed(String)
    case invalidCredential

    var errorDescription: String? {
        switch self {
        case .cancelled:
            "Sign in was cancelled."
        case .failed(let message):
            message
        case .invalidCredential:
            "Unable to verify your Apple ID. Please try again."
        }
    }
}

@MainActor
final class AuthService: NSObject {
    private var continuation: CheckedContinuation<AppleSignInResult, Error>?

    func signInWithApple() async throws -> AppleSignInResult {
        try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation

            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.fullName, .email]

            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }
}

extension AuthService: ASAuthorizationControllerDelegate {
    nonisolated func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        Task { @MainActor in
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                continuation?.resume(throwing: AuthServiceError.invalidCredential)
                continuation = nil
                return
            }

            let firstName = credential.fullName?.givenName
            let result = AppleSignInResult(
                userID: credential.user,
                firstName: firstName,
                email: credential.email
            )
            continuation?.resume(returning: result)
            continuation = nil
        }
    }

    nonisolated func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        Task { @MainActor in
            if let authError = error as? ASAuthorizationError, authError.code == .canceled {
                continuation?.resume(throwing: AuthServiceError.cancelled)
            } else {
                continuation?.resume(throwing: AuthServiceError.failed(error.localizedDescription))
            }
            continuation = nil
        }
    }
}

extension AuthService: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        // Prefer the currently active foreground scene
        if let activeScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            if let keyWindow = activeScene.keyWindow {
                return keyWindow
            }
            if let firstWindow = activeScene.windows.first {
                return firstWindow
            }
            return UIWindow(windowScene: activeScene)
        }

        // Fallback to any available window scene
        if let anyScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let keyWindow = anyScene.keyWindow {
                return keyWindow
            }
            if let firstWindow = anyScene.windows.first {
                return firstWindow
            }
            return UIWindow(windowScene: anyScene)
        }

        // Should be unreachable in a running app
        fatalError("No UIWindowScene available to provide presentation anchor for Sign in with Apple")
    }
}
