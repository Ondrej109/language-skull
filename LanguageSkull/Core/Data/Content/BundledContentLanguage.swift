import Foundation

enum BundledContentLanguage {
    static let bundleSubdirectory = "bundled-content"

    static func contentCode(for languageName: String) -> String? {
        switch languageName {
        case "Spanish": "es"
        case "French": "fr"
        case "German": "de"
        case "Italian": "it"
        case "Portuguese": "pt"
        case "English": "en"
        default:
            nil
        }
    }

    static func displayName(for contentCode: String) -> String {
        switch contentCode {
        case "es": "Spanish"
        case "fr": "French"
        case "de": "German"
        case "it": "Italian"
        case "pt": "Portuguese"
        case "en": "English"
        default: contentCode.capitalized
        }
    }

    static func resolveLanguageName(_ preferred: String?) -> String {
        if let preferred, !preferred.isEmpty { return preferred }
        let deviceCode = Locale.current.language.languageCode?.identifier.lowercased() ?? "en"
        switch deviceCode {
        case "es": return "Spanish"
        case "fr": return "French"
        case "de": return "German"
        case "it": return "Italian"
        case "pt": return "Portuguese"
        default: return "Spanish"
        }
    }
}
