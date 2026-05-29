import Foundation

struct LanguageOption: Identifiable, Hashable, Sendable {
    let id: String
    let contentCode: String
    let nativeName: String
    let englishName: String
    let flag: String

    static func localeAwareOptions() -> [LanguageOption] {
        let all: [LanguageOption] = [
            LanguageOption(id: "Spanish", contentCode: "es", nativeName: "Español", englishName: "Spanish", flag: "🇪🇸"),
            LanguageOption(id: "French", contentCode: "fr", nativeName: "Français", englishName: "French", flag: "🇫🇷"),
            LanguageOption(id: "German", contentCode: "de", nativeName: "Deutsch", englishName: "German", flag: "🇩🇪"),
            LanguageOption(id: "Italian", contentCode: "it", nativeName: "Italiano", englishName: "Italian", flag: "🇮🇹"),
            LanguageOption(id: "Portuguese", contentCode: "pt", nativeName: "Português", englishName: "Portuguese", flag: "🇵🇹")
        ]

        let deviceCode = Locale.current.language.languageCode?.identifier.lowercased() ?? "en"
        let priorityMap: [String: String] = [
            "en": "Spanish",
            "es": "Spanish",
            "fr": "French",
            "de": "German",
            "it": "Italian",
            "pt": "Portuguese"
        ]

        guard let priorityID = priorityMap[deviceCode],
              let priority = all.first(where: { $0.id == priorityID }) else {
            return all
        }

        return [priority] + all.filter { $0.id != priorityID }
    }
}
