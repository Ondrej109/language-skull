import Foundation
import SwiftData

@Model
final class Word {
    @Attribute(.unique) var id: String
    var english: String
    var foreign: String
    var dayIntroduced: Int
    var difficulty: Int
    var tagsData: Data?
    var sortOrder: Int

    @Relationship(inverse: \Course.words)
    var course: Course?

    var tags: [String] {
        get {
            guard let tagsData else { return [] }
            return (try? JSONDecoder().decode([String].self, from: tagsData)) ?? []
        }
        set {
            tagsData = try? JSONEncoder().encode(newValue)
        }
    }

    init(
        id: String,
        english: String,
        foreign: String,
        dayIntroduced: Int,
        difficulty: Int = 1,
        tags: [String] = [],
        sortOrder: Int = 0
    ) {
        self.id = id
        self.english = english
        self.foreign = foreign
        self.dayIntroduced = dayIntroduced
        self.difficulty = difficulty
        self.sortOrder = sortOrder
        self.tagsData = try? JSONEncoder().encode(tags)
    }
}
