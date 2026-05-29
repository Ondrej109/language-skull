import Foundation

enum ActivityType: String, Codable, CaseIterable, Sendable {
    case newWordsList
    case newWordsFlashcardsEF
    case newWordsFlashcardsFE
    case revisionWordsD1
    case revisionWordsD3
    case newPhrasesList
    case newPhrasesFlashcardsEF
    case newPhrasesFlashcardsFE
    case revisionPhrasesD1
    case revisionPhrasesD3
    case grammarParagraph
}
