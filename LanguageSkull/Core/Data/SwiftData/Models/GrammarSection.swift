import Foundation
import SwiftData

@Model
final class GrammarSection {
    @Attribute(.unique) var id: String
    var number: Int
    var title: String
    var content: String

    // Simplified relationship - removed inverse temporarily to break circular dependency
    var course: Course?

    init(id: String, number: Int, title: String, content: String) {
        self.id = id
        self.number = number
        self.title = title
        self.content = content
    }
}
