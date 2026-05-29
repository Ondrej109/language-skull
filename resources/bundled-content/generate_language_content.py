#!/usr/bin/env python3
"""
Generate consistent parallel JSON content files for Language Skull.
All languages have the exact same structure, IDs, order, English side, and categories.
Only the 'foreign' field changes per language.
This ensures the study plan works identically across all language courses.
"""

import json
import os

OUTPUT_DIR = "/home/workdir/artifacts/content"

# ============================================================
# BASE CONTENT - Same for all languages (English side)
# ============================================================

WORDS_BASE = [
    {"id": "w001", "english": "Hello", "category": "greetings", "difficulty": 1},
    {"id": "w002", "english": "Goodbye", "category": "greetings", "difficulty": 1},
    {"id": "w003", "english": "Please", "category": "politeness", "difficulty": 1},
    {"id": "w004", "english": "Thank you", "category": "politeness", "difficulty": 1},
    {"id": "w005", "english": "Yes", "category": "basics", "difficulty": 1},
    {"id": "w006", "english": "No", "category": "basics", "difficulty": 1},
    {"id": "w007", "english": "Sorry", "category": "politeness", "difficulty": 1},
    {"id": "w008", "english": "Water", "category": "food_drink", "difficulty": 1},
    {"id": "w009", "english": "Bread", "category": "food_drink", "difficulty": 1},
    {"id": "w010", "english": "Apple", "category": "food_drink", "difficulty": 1},
    {"id": "w011", "english": "Coffee", "category": "food_drink", "difficulty": 1},
    {"id": "w012", "english": "Milk", "category": "food_drink", "difficulty": 1},
    {"id": "w013", "english": "House", "category": "home", "difficulty": 2},
    {"id": "w014", "english": "Car", "category": "travel", "difficulty": 2},
    {"id": "w015", "english": "Book", "category": "objects", "difficulty": 2},
    {"id": "w016", "english": "Friend", "category": "people", "difficulty": 2},
    {"id": "w017", "english": "Mother", "category": "family", "difficulty": 2},
    {"id": "w018", "english": "Father", "category": "family", "difficulty": 2},
    {"id": "w019", "english": "Brother", "category": "family", "difficulty": 2},
    {"id": "w020", "english": "Sister", "category": "family", "difficulty": 2},
    {"id": "w021", "english": "Good", "category": "adjectives", "difficulty": 2},
    {"id": "w022", "english": "Bad", "category": "adjectives", "difficulty": 2},
    {"id": "w023", "english": "Big", "category": "adjectives", "difficulty": 2},
    {"id": "w024", "english": "Small", "category": "adjectives", "difficulty": 2},
    {"id": "w025", "english": "Beautiful", "category": "adjectives", "difficulty": 2},
    {"id": "w026", "english": "One", "category": "numbers", "difficulty": 1},
    {"id": "w027", "english": "Two", "category": "numbers", "difficulty": 1},
    {"id": "w028", "english": "Three", "category": "numbers", "difficulty": 1},
    {"id": "w029", "english": "Where", "category": "questions", "difficulty": 2},
    {"id": "w030", "english": "What", "category": "questions", "difficulty": 2},
]

PHRASES_BASE = [
    {"id": "p001", "english": "How are you?", "category": "greetings", "difficulty": 1},
    {"id": "p002", "english": "Nice to meet you.", "category": "greetings", "difficulty": 1},
    {"id": "p003", "english": "What is your name?", "category": "introductions", "difficulty": 1},
    {"id": "p004", "english": "My name is John.", "category": "introductions", "difficulty": 1},
    {"id": "p005", "english": "Where is the bathroom?", "category": "travel", "difficulty": 2},
    {"id": "p006", "english": "How much does it cost?", "category": "travel", "difficulty": 2},
    {"id": "p007", "english": "I don't understand.", "category": "communication", "difficulty": 2},
    {"id": "p008", "english": "Can you help me, please?", "category": "communication", "difficulty": 2},
    {"id": "p009", "english": "Good morning.", "category": "greetings", "difficulty": 1},
    {"id": "p010", "english": "Good night.", "category": "greetings", "difficulty": 1},
    {"id": "p011", "english": "See you later.", "category": "greetings", "difficulty": 1},
    {"id": "p012", "english": "I would like a coffee.", "category": "food_drink", "difficulty": 2},
    {"id": "p013", "english": "Do you speak English?", "category": "communication", "difficulty": 2},
    {"id": "p014", "english": "I am from the United States.", "category": "introductions", "difficulty": 2},
    {"id": "p015", "english": "Thank you very much.", "category": "politeness", "difficulty": 1},
]

# ============================================================
# TRANSLATIONS - Foreign language equivalents (must match order)
# ============================================================

TRANSLATIONS = {
    "es": {  # Spanish
        "words": {
            "w001": "Hola",
            "w002": "Adiós",
            "w003": "Por favor",
            "w004": "Gracias",
            "w005": "Sí",
            "w006": "No",
            "w007": "Lo siento",
            "w008": "Agua",
            "w009": "Pan",
            "w010": "Manzana",
            "w011": "Café",
            "w012": "Leche",
            "w013": "Casa",
            "w014": "Coche",
            "w015": "Libro",
            "w016": "Amigo",
            "w017": "Madre",
            "w018": "Padre",
            "w019": "Hermano",
            "w020": "Hermana",
            "w021": "Bueno",
            "w022": "Malo",
            "w023": "Grande",
            "w024": "Pequeño",
            "w025": "Hermoso",
            "w026": "Uno",
            "w027": "Dos",
            "w028": "Tres",
            "w029": "Dónde",
            "w030": "Qué",
        },
        "phrases": {
            "p001": "¿Cómo estás?",
            "p002": "Mucho gusto.",
            "p003": "¿Cómo te llamas?",
            "p004": "Me llamo John.",
            "p005": "¿Dónde está el baño?",
            "p006": "¿Cuánto cuesta?",
            "p007": "No entiendo.",
            "p008": "¿Me puedes ayudar, por favor?",
            "p009": "Buenos días.",
            "p010": "Buenas noches.",
            "p011": "Hasta luego.",
            "p012": "Me gustaría un café.",
            "p013": "¿Hablas inglés?",
            "p014": "Soy de los Estados Unidos.",
            "p015": "Muchas gracias.",
        }
    },
    "de": {  # German
        "words": {
            "w001": "Hallo",
            "w002": "Auf Wiedersehen",
            "w003": "Bitte",
            "w004": "Danke",
            "w005": "Ja",
            "w006": "Nein",
            "w007": "Entschuldigung",
            "w008": "Wasser",
            "w009": "Brot",
            "w010": "Apfel",
            "w011": "Kaffee",
            "w012": "Milch",
            "w013": "Haus",
            "w014": "Auto",
            "w015": "Buch",
            "w016": "Freund",
            "w017": "Mutter",
            "w018": "Vater",
            "w019": "Bruder",
            "w020": "Schwester",
            "w021": "Gut",
            "w022": "Schlecht",
            "w023": "Groß",
            "w024": "Klein",
            "w025": "Schön",
            "w026": "Eins",
            "w027": "Zwei",
            "w028": "Drei",
            "w029": "Wo",
            "w030": "Was",
        },
        "phrases": {
            "p001": "Wie geht es dir?",
            "p002": "Freut mich, dich kennenzulernen.",
            "p003": "Wie heißt du?",
            "p004": "Ich heiße John.",
            "p005": "Wo ist die Toilette?",
            "p006": "Wie viel kostet das?",
            "p007": "Ich verstehe nicht.",
            "p008": "Kannst du mir bitte helfen?",
            "p009": "Guten Morgen.",
            "p010": "Gute Nacht.",
            "p011": "Bis später.",
            "p012": "Ich hätte gerne einen Kaffee.",
            "p013": "Sprichst du Englisch?",
            "p014": "Ich komme aus den Vereinigten Staaten.",
            "p015": "Vielen Dank.",
        }
    },
    "fr": {  # French
        "words": {
            "w001": "Bonjour",
            "w002": "Au revoir",
            "w003": "S'il vous plaît",
            "w004": "Merci",
            "w005": "Oui",
            "w006": "Non",
            "w007": "Désolé",
            "w008": "Eau",
            "w009": "Pain",
            "w010": "Pomme",
            "w011": "Café",
            "w012": "Lait",
            "w013": "Maison",
            "w014": "Voiture",
            "w015": "Livre",
            "w016": "Ami",
            "w017": "Mère",
            "w018": "Père",
            "w019": "Frère",
            "w020": "Sœur",
            "w021": "Bon",
            "w022": "Mauvais",
            "w023": "Grand",
            "w024": "Petit",
            "w025": "Beau",
            "w026": "Un",
            "w027": "Deux",
            "w028": "Trois",
            "w029": "Où",
            "w030": "Quoi",
        },
        "phrases": {
            "p001": "Comment ça va ?",
            "p002": "Enchanté de vous rencontrer.",
            "p003": "Comment vous appelez-vous ?",
            "p004": "Je m'appelle John.",
            "p005": "Où sont les toilettes ?",
            "p006": "Combien ça coûte ?",
            "p007": "Je ne comprends pas.",
            "p008": "Pouvez-vous m'aider, s'il vous plaît ?",
            "p009": "Bonjour.",
            "p010": "Bonne nuit.",
            "p011": "À plus tard.",
            "p012": "Je voudrais un café.",
            "p013": "Parlez-vous anglais ?",
            "p014": "Je viens des États-Unis.",
            "p015": "Merci beaucoup.",
        }
    },
    "it": {  # Italian
        "words": {
            "w001": "Ciao",
            "w002": "Arrivederci",
            "w003": "Per favore",
            "w004": "Grazie",
            "w005": "Sì",
            "w006": "No",
            "w007": "Scusa",
            "w008": "Acqua",
            "w009": "Pane",
            "w010": "Mela",
            "w011": "Caffè",
            "w012": "Latte",
            "w013": "Casa",
            "w014": "Macchina",
            "w015": "Libro",
            "w016": "Amico",
            "w017": "Madre",
            "w018": "Padre",
            "w019": "Fratello",
            "w020": "Sorella",
            "w021": "Buono",
            "w022": "Cattivo",
            "w023": "Grande",
            "w024": "Piccolo",
            "w025": "Bello",
            "w026": "Uno",
            "w027": "Due",
            "w028": "Tre",
            "w029": "Dove",
            "w030": "Cosa",
        },
        "phrases": {
            "p001": "Come stai?",
            "p002": "Piacere di conoscerti.",
            "p003": "Come ti chiami?",
            "p004": "Mi chiamo John.",
            "p005": "Dov'è il bagno?",
            "p006": "Quanto costa?",
            "p007": "Non capisco.",
            "p008": "Puoi aiutarmi, per favore?",
            "p009": "Buongiorno.",
            "p010": "Buonanotte.",
            "p011": "A più tardi.",
            "p012": "Vorrei un caffè.",
            "p013": "Parli inglese?",
            "p014": "Vengo dagli Stati Uniti.",
            "p015": "Grazie mille.",
        }
    },
    "pt": {  # Portuguese (Brazilian)
        "words": {
            "w001": "Olá",
            "w002": "Tchau",
            "w003": "Por favor",
            "w004": "Obrigado",
            "w005": "Sim",
            "w006": "Não",
            "w007": "Desculpe",
            "w008": "Água",
            "w009": "Pão",
            "w010": "Maçã",
            "w011": "Café",
            "w012": "Leite",
            "w013": "Casa",
            "w014": "Carro",
            "w015": "Livro",
            "w016": "Amigo",
            "w017": "Mãe",
            "w018": "Pai",
            "w019": "Irmão",
            "w020": "Irmã",
            "w021": "Bom",
            "w022": "Ruim",
            "w023": "Grande",
            "w024": "Pequeno",
            "w025": "Bonito",
            "w026": "Um",
            "w027": "Dois",
            "w028": "Três",
            "w029": "Onde",
            "w030": "O quê",
        },
        "phrases": {
            "p001": "Como vai?",
            "p002": "Prazer em conhecê-lo.",
            "p003": "Qual é o seu nome?",
            "p004": "Meu nome é John.",
            "p005": "Onde fica o banheiro?",
            "p006": "Quanto custa?",
            "p007": "Não entendo.",
            "p008": "Você pode me ajudar, por favor?",
            "p009": "Bom dia.",
            "p010": "Boa noite.",
            "p011": "Até mais tarde.",
            "p012": "Eu gostaria de um café.",
            "p013": "Você fala inglês?",
            "p014": "Eu sou dos Estados Unidos.",
            "p015": "Muito obrigado.",
        }
    },
    "en": {  # English (for English course / testing - foreign mirrors english)
        "words": {
            "w001": "Hello",
            "w002": "Goodbye",
            "w003": "Please",
            "w004": "Thank you",
            "w005": "Yes",
            "w006": "No",
            "w007": "Sorry",
            "w008": "Water",
            "w009": "Bread",
            "w010": "Apple",
            "w011": "Coffee",
            "w012": "Milk",
            "w013": "House",
            "w014": "Car",
            "w015": "Book",
            "w016": "Friend",
            "w017": "Mother",
            "w018": "Father",
            "w019": "Brother",
            "w020": "Sister",
            "w021": "Good",
            "w022": "Bad",
            "w023": "Big",
            "w024": "Small",
            "w025": "Beautiful",
            "w026": "One",
            "w027": "Two",
            "w028": "Three",
            "w029": "Where",
            "w030": "What",
        },
        "phrases": {
            "p001": "How are you?",
            "p002": "Nice to meet you.",
            "p003": "What is your name?",
            "p004": "My name is John.",
            "p005": "Where is the bathroom?",
            "p006": "How much does it cost?",
            "p007": "I don't understand.",
            "p008": "Can you help me, please?",
            "p009": "Good morning.",
            "p010": "Good night.",
            "p011": "See you later.",
            "p012": "I would like a coffee.",
            "p013": "Do you speak English?",
            "p014": "I am from the United States.",
            "p015": "Thank you very much.",
        }
    },
}

LANGUAGE_NAMES = {
    "es": "Spanish",
    "de": "German",
    "fr": "French",
    "it": "Italian",
    "pt": "Portuguese",
    "en": "English",
}

def generate_files():
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    for lang_code in TRANSLATIONS.keys():
        lang_name = LANGUAGE_NAMES[lang_code]
        trans = TRANSLATIONS[lang_code]

        # Build words list in exact base order
        words_list = []
        for base in WORDS_BASE:
            word_id = base["id"]
            words_list.append({
                "id": word_id,
                "english": base["english"],
                "foreign": trans["words"][word_id],
                "category": base["category"],
                "difficulty": base["difficulty"]
            })

        # Build phrases list in exact base order
        phrases_list = []
        for base in PHRASES_BASE:
            phrase_id = base["id"]
            phrases_list.append({
                "id": phrase_id,
                "english": base["english"],
                "foreign": trans["phrases"][phrase_id],
                "category": base["category"],
                "difficulty": base["difficulty"]
            })

        # Write words JSON
        words_data = {
            "language": lang_code,
            "language_name": lang_name,
            "content_type": "words",
            "version": 1,
            "words": words_list
        }
        words_path = os.path.join(OUTPUT_DIR, f"{lang_code}_words.json")
        with open(words_path, "w", encoding="utf-8") as f:
            json.dump(words_data, f, ensure_ascii=False, indent=2)
        print(f"Created: {words_path}")

        # Write phrases JSON
        phrases_data = {
            "language": lang_code,
            "language_name": lang_name,
            "content_type": "phrases",
            "version": 1,
            "phrases": phrases_list
        }
        phrases_path = os.path.join(OUTPUT_DIR, f"{lang_code}_phrases.json")
        with open(phrases_path, "w", encoding="utf-8") as f:
            json.dump(phrases_data, f, ensure_ascii=False, indent=2)
        print(f"Created: {phrases_path}")

    print("\n✅ All language content files generated successfully!")
    print(f"Location: {OUTPUT_DIR}")

if __name__ == "__main__":
    generate_files()