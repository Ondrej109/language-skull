import Foundation

enum StudyItemKind: String, Sendable {
    case word
    case phrase
    case grammar
}

struct StudyContentItem: Identifiable, Hashable, Sendable {
    let id: String
    let english: String
    let foreign: String
    let kind: StudyItemKind
    let dayIntroduced: Int
    let sortOrder: Int
    let grammarTitle: String?

    init(
        id: String,
        english: String,
        foreign: String,
        kind: StudyItemKind,
        dayIntroduced: Int = 0,
        sortOrder: Int = 0,
        grammarTitle: String? = nil
    ) {
        self.id = id
        self.english = english
        self.foreign = foreign
        self.kind = kind
        self.dayIntroduced = dayIntroduced
        self.sortOrder = sortOrder
        self.grammarTitle = grammarTitle
    }
}

struct ResolvedActivity: Identifiable, Sendable {
    let id: String
    let type: ActivityType
    let order: Int
    let timeOfDay: TimeOfDay
    let title: String
    let subtitle: String
    let items: [StudyContentItem]
    let isCompleted: Bool
    let metadata: [String: String]
}

struct StudySessionSummary: Sendable {
    let studyPlanDay: Int
    let calendarDate: Date
    let timeOfDay: TimeOfDay
    let activities: [ResolvedActivity]
    let completedCount: Int
    let totalCount: Int

    var progress: Double {
        guard totalCount > 0 else { return 0 }
        return Double(completedCount) / Double(totalCount)
    }
}

struct CalendarDaySummary: Identifiable, Sendable {
    let id: String
    let date: Date
    let studyPlanDay: Int
    let morningCompleted: Int
    let morningTotal: Int
    let eveningCompleted: Int
    let eveningTotal: Int

    var isFullyComplete: Bool {
        morningCompleted == morningTotal && eveningCompleted == eveningTotal && (morningTotal + eveningTotal) > 0
    }
}

enum StudyPlanEngineLogic {
    /// Primitive, Sendable version usable from any concurrency domain.
    static func studyPlanDay(
        courseStartDate: Date?,
        createdAt: Date,
        startingStudyDay: Int,
        on date: Date = .now
    ) -> Int {
        let calendar = Calendar.current
        let anchor = calendar.startOfDay(for: courseStartDate ?? createdAt)
        let target = calendar.startOfDay(for: date)
        let elapsed = calendar.daysBetween(anchor, and: target)
        return startingStudyDay + max(0, elapsed)
    }

    /// Convenience for use on MainActor where we have a live model instance.
    @MainActor
    static func studyPlanDay(for profile: UserProfile, on date: Date = .now) -> Int {
        studyPlanDay(
            courseStartDate: profile.courseStartDate,
            createdAt: profile.createdAt,
            startingStudyDay: profile.startingStudyDay,
            on: date
        )
    }

    static func d3RevisionItems<T>(
        from items: [T],
        currentDay: Int,
        dayIntroduced: (T) -> Int,
        sortOrder: (T) -> Int
    ) -> [T] {
        let lowerBound = currentDay - 3
        let upperBound = currentDay - 1
        guard upperBound >= lowerBound else { return [] }

        return items
            .filter {
                let day = dayIntroduced($0)
                return day >= lowerBound && day <= upperBound
            }
            .sorted { lhs, rhs in
                let leftDay = dayIntroduced(lhs)
                let rightDay = dayIntroduced(rhs)
                if leftDay != rightDay { return leftDay < rightDay }
                return sortOrder(lhs) < sortOrder(rhs)
            }
    }

    static func d1RevisionItems<T>(
        from items: [T],
        currentDay: Int,
        dayIntroduced: (T) -> Int,
        sortOrder: (T) -> Int
    ) -> [T] {
        items
            .filter { dayIntroduced($0) == currentDay - 1 }
            .sorted { sortOrder($0) < sortOrder($1) }
    }

    static func newItemsForDay<T>(
        from items: [T],
        currentDay: Int,
        dayIntroduced: (T) -> Int,
        sortOrder: (T) -> Int
    ) -> [T] {
        items
            .filter { dayIntroduced($0) == currentDay }
            .sorted { sortOrder($0) < sortOrder($1) }
    }
}
