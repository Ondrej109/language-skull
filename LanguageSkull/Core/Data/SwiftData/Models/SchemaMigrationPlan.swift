import Foundation
import SwiftData

enum LanguageSkullSchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version { Schema.Version(1, 0, 0) }

    static var models: [any PersistentModel.Type] {
        LanguageSkullSchemaV2.models
    }
}

enum LanguageSkullSchemaV2: VersionedSchema {
    static var versionIdentifier: Schema.Version { Schema.Version(2, 0, 0) }

    static var models: [any PersistentModel.Type] {
        [
            UserProfile.self,
            SubscriptionStatus.self,
            Course.self,
            Word.self,
            Phrase.self,
            GrammarSection.self,
            StudyPlan.self,
            WeekPlan.self,
            DayPlan.self,
            ActivityDefinition.self,
            UserActivityCompletion.self
        ]
    }
}

enum LanguageSkullSchemaV3: VersionedSchema {
    static var versionIdentifier: Schema.Version { Schema.Version(3, 0, 0) }

    static var models: [any PersistentModel.Type] {
        LanguageSkullSchemaV2.models
    }
}

enum LanguageSkullMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [LanguageSkullSchemaV1.self, LanguageSkullSchemaV2.self, LanguageSkullSchemaV3.self]
    }

    static var stages: [MigrationStage] {
        [migrateV1toV2, migrateV2toV3]
    }

    static let migrateV1toV2 = MigrationStage.lightweight(
        fromVersion: LanguageSkullSchemaV1.self,
        toVersion: LanguageSkullSchemaV2.self
    )

    static let migrateV2toV3 = MigrationStage.lightweight(
        fromVersion: LanguageSkullSchemaV2.self,
        toVersion: LanguageSkullSchemaV3.self
    )
}

enum LanguageSkullModelContainer {
    static func makeContainer(inMemory: Bool = false) throws -> ModelContainer {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: inMemory)
        return try ModelContainer(
            for: Schema(versionedSchema: LanguageSkullSchemaV3.self),
            migrationPlan: LanguageSkullMigrationPlan.self,
            configurations: [configuration]
        )
    }
}
