import Foundation
import SwiftData

@MainActor
final class ContentRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchCourses() throws -> [Course] {
        let descriptor = FetchDescriptor<Course>(
            sortBy: [SortDescriptor(\.displayName)]
        )
        return try modelContext.fetch(descriptor)
    }

    func fetchCourse(id: String) throws -> Course? {
        let descriptor = FetchDescriptor<Course>(predicate: #Predicate { $0.id == id })
        return try modelContext.fetch(descriptor).first
    }

    func fetchCourse(for profile: UserProfile) throws -> Course? {
        if let code = BundledContentLanguage.contentCode(for: profile.targetLanguage) {
            if let course = try fetchCourse(id: "course_\(code)") {
                return course
            }
        }
        return try fetchCourses().first
    }

    func fetchActiveCourse() throws -> Course? {
        try fetchCourses().first
    }
}
