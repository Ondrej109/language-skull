import SwiftUI
import SwiftData
import Foundation   // ← This was missing

enum PreviewData {
    
    @MainActor
    static var sampleProfile: UserProfile {
        let profile = UserProfile(
            id: "profile_preview",
            firstName: "Alex",
            targetLanguage: "Spanish",
            proficiencyLevel: .beginner,
            hasCompletedOnboarding: true,
            startingStudyDay: 1,
            courseStartDate: Calendar.current.date(byAdding: .day, value: -2, to: .now)
        )
        return profile
    }

    @MainActor
    static var previewContainer: ModelContainer {
        let container = try! LanguageSkullModelContainer.makeContainer(inMemory: true)
        let context = container.mainContext

        let profile = sampleProfile
        context.insert(profile)

        let course = Course(
            id: "course_es",
            languageCode: "es",
            displayName: "Spanish",
            contentVersion: "preview"
        )
        context.insert(course)

        let words: [(String, String, String, Int, Int)] = [
            ("es_w001", "Hello", "Hola", 1, 0),
            ("es_w002", "Goodbye", "Adiós", 1, 1),
            ("es_w003", "Please", "Por favor", 1, 2),
            ("es_w011", "Thank you", "Gracias", 2, 3),
            ("es_w012", "Yes", "Sí", 2, 4),
            ("es_w021", "No", "No", 3, 5)
        ]

        for word in words {
            let model = Word(
                id: word.0,
                english: word.1,
                foreign: word.2,
                dayIntroduced: word.3,
                sortOrder: word.4
            )
            model.course = course
            context.insert(model)
        }

        let phrases: [(String, String, String, Int, Int)] = [
            ("es_p001", "How are you?", "¿Cómo estás?", 1, 0),
            ("es_p002", "Nice to meet you.", "Mucho gusto.", 1, 1),
            ("es_p003", "What is your name?", "¿Cómo te llamas?", 2, 2)
        ]

        for phrase in phrases {
            let model = Phrase(
                id: phrase.0,
                english: phrase.1,
                foreign: phrase.2,
                dayIntroduced: phrase.3,
                sortOrder: phrase.4
            )
            model.course = course
            context.insert(model)
        }

        let worker = ContentSeederWorker(modelContext: context)
        let studyPlan = worker.buildDefaultStudyPlan(for: course, languageCode: "es")
        course.studyPlan = studyPlan
        context.insert(studyPlan)

        try? context.save()
        return container
    }
}
