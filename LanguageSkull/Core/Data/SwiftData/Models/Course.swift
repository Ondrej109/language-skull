import Foundation
import SwiftData

@Model
final class Course {
    @Attribute(.unique) var id: String
    var languageCode: String
    var displayName: String
    var contentVersion: String
    var createdAt: Date

    // Simplified relationships to avoid circular reference errors
    @Relationship(deleteRule: .cascade)
    var words: [Word] = []

    @Relationship(deleteRule: .cascade)
    var phrases: [Phrase] = []

    @Relationship(deleteRule: .cascade)
    var grammarSections: [GrammarSection] = []

    var studyPlan: StudyPlan?

    init(
        id: String,
        languageCode: String,
        displayName: String,
        contentVersion: String,
        createdAt: Date = .now
    ) {
        self.id = id
        self.languageCode = languageCode
        self.displayName = displayName
        self.contentVersion = contentVersion
        self.createdAt = createdAt
    }
}
