import Foundation

enum ProficiencyLevel: String, Codable, CaseIterable, Sendable {
    case beginner
    case knowBasicWords
    case intermediate
    case advanced
    case fluent

    var displayName: String {
        switch self {
        case .beginner: "Beginner"
        case .knowBasicWords: "Know Basic Words"
        case .intermediate: "Intermediate"
        case .advanced: "Advanced"
        case .fluent: "Fluent"
        }
    }

    /// Starting study day offset based on proficiency (docs/03).
    var startingStudyDay: Int {
        switch self {
        case .beginner: 1
        case .knowBasicWords: 2
        case .intermediate: 4
        case .advanced: 7
        case .fluent: 10
        }
    }
}
