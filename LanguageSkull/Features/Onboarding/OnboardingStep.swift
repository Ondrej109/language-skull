import Foundation

enum OnboardingStep: String, CaseIterable, Sendable {
    case launch
    case quickDemo
    case firstName
    case language
    case proficiency
    case notifications
    case appleSignIn
    case seeding

    var progressIndex: Int {
        switch self {
        case .launch, .quickDemo: 0
        case .firstName: 1
        case .language: 2
        case .proficiency: 3
        case .notifications: 4
        case .appleSignIn: 5
        case .seeding: 6
        }
    }

    static let questionSteps: [OnboardingStep] = [
        .firstName, .language, .proficiency, .notifications, .appleSignIn
    ]

    var totalProgressSteps: Int { Self.questionSteps.count }
}
