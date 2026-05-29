import Foundation
import SwiftData

/// Single source of truth for session assembly (docs/06).
actor StudyPlanEngine {
    private let modelContainer: ModelContainer

    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }

    func studyPlanDay(for profile: UserProfile, on date: Date = .now) async -> Int {
        // Extract only Sendable values before crossing actor boundary.
        // No need to re-fetch the model for this pure calculation.
        let courseStartDate = profile.courseStartDate
        let createdAt = profile.createdAt
        let startingStudyDay = profile.startingStudyDay

        return await MainActor.run {
            StudyPlanEngineLogic.studyPlanDay(
                courseStartDate: courseStartDate,
                createdAt: createdAt,
                startingStudyDay: startingStudyDay,
                on: date
            )
        }
    }

    func assembleSession(
        for profile: UserProfile,
        timeOfDay: TimeOfDay,
        on date: Date = .now
    ) async throws -> StudySessionSummary {
        let profileID = profile.persistentModelID
        return try await MainActor.run {
            let context = modelContainer.mainContext
            guard let freshProfile = context.model(for: profileID) as? UserProfile else {
                throw StudyPlanEngineError.profileNotFound
            }
            return try self.assembleSessionOnMainActor(
                profile: freshProfile,
                timeOfDay: timeOfDay,
                on: date
            )
        }
    }

    func calendarSummaries(for profile: UserProfile, dayCount: Int = 30) async throws -> [CalendarDaySummary] {
        let profileID = profile.persistentModelID
        return try await MainActor.run {
            let context = modelContainer.mainContext
            guard let freshProfile = context.model(for: profileID) as? UserProfile else {
                throw StudyPlanEngineError.profileNotFound
            }

            var summaries: [CalendarDaySummary] = []
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: .now)

            for offset in 0..<dayCount {
                guard let date = calendar.date(byAdding: .day, value: -offset, to: today) else { continue }

                let morning = try self.assembleSessionOnMainActor(
                    profile: freshProfile,
                    timeOfDay: .morning,
                    on: date
                )
                let evening = try self.assembleSessionOnMainActor(
                    profile: freshProfile,
                    timeOfDay: .evening,
                    on: date
                )

                summaries.append(
                    CalendarDaySummary(
                        id: ISO8601DateFormatter().string(from: date),
                        date: date,
                        studyPlanDay: morning.studyPlanDay,
                        morningCompleted: morning.completedCount,
                        morningTotal: morning.totalCount,
                        eveningCompleted: evening.completedCount,
                        eveningTotal: evening.totalCount
                    )
                )
            }
            return summaries
        }
    }

    @MainActor
    private func assembleSessionOnMainActor(
        profile: UserProfile,
        timeOfDay: TimeOfDay,
        on date: Date
    ) throws -> StudySessionSummary {
        let context = modelContainer.mainContext
        let contentRepository = ContentRepository(modelContext: context)
        let progressRepository = ProgressRepository(modelContext: context)

        guard let course = try contentRepository.fetchCourse(for: profile) else {
            throw StudyPlanEngineError.courseNotFound
        }
        guard let studyPlan = course.studyPlan else {
            throw StudyPlanEngineError.studyPlanNotFound
        }

        let planDay = StudyPlanEngineLogic.studyPlanDay(for: profile, on: date)
        guard let dayPlan = studyPlan.dayPlan(for: planDay) else {
            throw StudyPlanEngineError.dayPlanNotFound(planDay)
        }

        let activities = (timeOfDay == .morning ? dayPlan.morningActivities : dayPlan.eveningActivities)
        let completions = progressRepository.completions(for: profile, on: date)
        let completionIDs = Set(completions.filter(\.isCompleted).map(\.activityId))

        let resolved = activities.map { definition in
            Self.resolveActivity(
                definition: definition,
                course: course,
                planDay: planDay,
                isCompleted: completionIDs.contains(definition.id)
            )
        }

        return StudySessionSummary(
            studyPlanDay: planDay,
            calendarDate: date.startOfDay,
            timeOfDay: timeOfDay,
            activities: resolved,
            completedCount: resolved.filter(\.isCompleted).count,
            totalCount: resolved.count
        )
    }

    @MainActor
    private static func resolveActivity(
        definition: ActivityDefinition,
        course: Course,
        planDay: Int,
        isCompleted: Bool
    ) -> ResolvedActivity {
        let items = Self.contentItems(
            for: definition.type,
            course: course,
            planDay: planDay,
            metadata: definition.metadata
        )

        return ResolvedActivity(
            id: definition.id,
            type: definition.type,
            order: definition.order,
            timeOfDay: definition.timeOfDay,
            title: Self.title(for: definition.type),
            subtitle: Self.subtitle(for: definition.type, itemCount: items.count, planDay: planDay),
            items: items,
            isCompleted: isCompleted,
            metadata: definition.metadata
        )
    }

    @MainActor
    private static func contentItems(
        for type: ActivityType,
        course: Course,
        planDay: Int,
        metadata: [String: String]
    ) -> [StudyContentItem] {
        switch type {
        case .newWordsList, .newWordsFlashcardsEF, .newWordsFlashcardsFE:
            return StudyPlanEngineLogic.newItemsForDay(
                from: course.words,
                currentDay: planDay,
                dayIntroduced: \.dayIntroduced,
                sortOrder: \.sortOrder
            ).map { word in
                StudyContentItem(
                    id: word.id,
                    english: word.english,
                    foreign: word.foreign,
                    kind: .word,
                    dayIntroduced: word.dayIntroduced,
                    sortOrder: word.sortOrder
                )
            }

        case .revisionWordsD1:
            return StudyPlanEngineLogic.d1RevisionItems(
                from: course.words,
                currentDay: planDay,
                dayIntroduced: \.dayIntroduced,
                sortOrder: \.sortOrder
            ).map { word in
                StudyContentItem(
                    id: word.id,
                    english: word.english,
                    foreign: word.foreign,
                    kind: .word,
                    dayIntroduced: word.dayIntroduced,
                    sortOrder: word.sortOrder
                )
            }

        case .revisionWordsD3:
            return StudyPlanEngineLogic.d3RevisionItems(
                from: course.words,
                currentDay: planDay,
                dayIntroduced: \.dayIntroduced,
                sortOrder: \.sortOrder
            ).map { word in
                StudyContentItem(
                    id: word.id,
                    english: word.english,
                    foreign: word.foreign,
                    kind: .word,
                    dayIntroduced: word.dayIntroduced,
                    sortOrder: word.sortOrder
                )
            }

        case .newPhrasesList, .newPhrasesFlashcardsEF, .newPhrasesFlashcardsFE:
            return StudyPlanEngineLogic.newItemsForDay(
                from: course.phrases,
                currentDay: planDay,
                dayIntroduced: \.dayIntroduced,
                sortOrder: \.sortOrder
            ).map { phrase in
                StudyContentItem(
                    id: phrase.id,
                    english: phrase.english,
                    foreign: phrase.foreign,
                    kind: .phrase,
                    dayIntroduced: phrase.dayIntroduced,
                    sortOrder: phrase.sortOrder
                )
            }

        case .revisionPhrasesD1:
            return StudyPlanEngineLogic.d1RevisionItems(
                from: course.phrases,
                currentDay: planDay,
                dayIntroduced: \.dayIntroduced,
                sortOrder: \.sortOrder
            ).map { phrase in
                StudyContentItem(
                    id: phrase.id,
                    english: phrase.english,
                    foreign: phrase.foreign,
                    kind: .phrase,
                    dayIntroduced: phrase.dayIntroduced,
                    sortOrder: phrase.sortOrder
                )
            }

        case .revisionPhrasesD3:
            return StudyPlanEngineLogic.d3RevisionItems(
                from: course.phrases,
                currentDay: planDay,
                dayIntroduced: \.dayIntroduced,
                sortOrder: \.sortOrder
            ).map { phrase in
                StudyContentItem(
                    id: phrase.id,
                    english: phrase.english,
                    foreign: phrase.foreign,
                    kind: .phrase,
                    dayIntroduced: phrase.dayIntroduced,
                    sortOrder: phrase.sortOrder
                )
            }

        case .grammarParagraph:
            let sectionNumber = Int(metadata["sectionNumber"] ?? "") ?? min(planDay, course.grammarSections.count)
            let section = course.grammarSections.first { $0.number == sectionNumber }
            guard let section else { return [] }
            return [
                StudyContentItem(
                    id: section.id,
                    english: section.title,
                    foreign: section.content,
                    kind: .grammar,
                    grammarTitle: section.title
                )
            ]
        }
    }

    private static func title(for type: ActivityType) -> String {
        switch type {
        case .newWordsList: "New Words"
        case .newWordsFlashcardsEF: "Flashcards E → F"
        case .newWordsFlashcardsFE: "Flashcards F → E"
        case .revisionWordsD1: "Revision D-1 Words"
        case .revisionWordsD3: "Revision D-3 Words"
        case .newPhrasesList: "New Phrases"
        case .newPhrasesFlashcardsEF: "Phrase Flashcards E → F"
        case .newPhrasesFlashcardsFE: "Phrase Flashcards F → E"
        case .revisionPhrasesD1: "Revision D-1 Phrases"
        case .revisionPhrasesD3: "Revision D-3 Phrases"
        case .grammarParagraph: "Grammar"
        }
    }

    private static func subtitle(for type: ActivityType, itemCount: Int, planDay: Int) -> String {
        switch type {
        case .revisionWordsD3, .revisionPhrasesD3:
            "Days \(max(1, planDay - 3))–\(max(1, planDay - 1)) · \(itemCount) items · original order"
        case .revisionWordsD1, .revisionPhrasesD1:
            "Day \(max(1, planDay - 1)) · \(itemCount) items"
        case .grammarParagraph:
            "Section · \(itemCount) block"
        default:
            "Day \(planDay) · \(itemCount) items"
        }
    }
}

enum StudyPlanEngineError: LocalizedError {
    case courseNotFound
    case studyPlanNotFound
    case dayPlanNotFound(Int)
    case profileNotFound

    var errorDescription: String? {
        switch self {
        case .courseNotFound: "No course found for your profile."
        case .studyPlanNotFound: "Study plan is missing for this course."
        case .dayPlanNotFound(let day): "No plan found for study day \(day)."
        case .profileNotFound: "Profile could not be loaded."
        }
    }
}
