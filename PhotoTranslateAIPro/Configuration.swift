//
//  Configuration.swift
//  PhotoTranslateAIPro
//
//  Created by Orlin Kalev on 17.08.25.
//

import Foundation
import Vision

struct Configuration {
    
    // MARK: - App Configuration
    
    static let appName = "Photo Translate AI Pro"
    static let appVersion = "1.0.0"
    static let buildNumber = "1"
    
    // MARK: - Translation API Configuration
    
    // Set to true to use real DeepL API, false for demo mode
    static let useRealTranslationAPI = true
    
    // DeepL API key for real translations
    static let deepLAPIKey = "6ad1b7b1-12f1-495b-97fa-a085aae23fd7"
    
    // Check if we have a valid API key
    static var hasValidAPIKey: Bool {
        return !deepLAPIKey.isEmpty && deepLAPIKey != "YOUR_DEEPL_API_KEY_HERE"
    }
    
    // MARK: - Text Recognition Configuration
    
    struct TextRecognition {
        static let recognitionLevel: VNRequestTextRecognitionLevel = .accurate
        static let usesLanguageCorrection = true
        static let minimumTextHeight: Float = 0.01
    }
    
    // MARK: - UI Configuration
    
    struct UI {
        static let cornerRadius: CGFloat = 16
        static let shadowRadius: CGFloat = 10
        static let shadowOpacity: Float = 0.05
        static let animationDuration: Double = 0.3
        static let maxImageHeight: CGFloat = 300
    }
    
    // MARK: - Supported Languages (DeepL Full Support)
    
    static let supportedLanguages = [
        // European Languages
        "Bulgarian": "bg",
        "Czech": "cs",
        "Danish": "da",
        "Dutch": "nl",
        "English": "en",
        "Estonian": "et",
        "Finnish": "fi",
        "French": "fr",
        "German": "de",
        "Greek": "el",
        "Hungarian": "hu",
        "Italian": "it",
        "Latvian": "lv",
        "Lithuanian": "lt",
        "Norwegian": "no",
        "Polish": "pl",
        "Portuguese": "pt",
        "Romanian": "ro",
        "Russian": "ru",
        "Slovak": "sk",
        "Slovenian": "sl",
        "Spanish": "es",
        "Swedish": "sv",
        
        // Asian Languages
        "Chinese (Simplified)": "zh",
        "Indonesian": "id",
        "Japanese": "ja",
        "Korean": "ko",
        
        // Other Languages
        "Turkish": "tr",
        "Ukrainian": "uk"
    ]
    
    // MARK: - Demo Translations
    
    static let demoTranslations: [String: [String: String]] = [
        "es": [
            "Hello": "Hola",
            "Hi": "Hola",
            "World": "Mundo",
            "Good morning": "Buenos días",
            "Thank you": "Gracias",
            "Thanks": "Gracias",
            "Please": "Por favor",
            "Welcome": "Bienvenido",
            "Goodbye": "Adiós",
            "Bye": "Adiós",
            "Yes": "Sí",
            "No": "No",
            "Help": "Ayuda",
            "How are you": "¿Cómo estás?",
            "I love you": "Te quiero",
            "Beautiful": "Hermoso",
            "Friend": "Amigo",
            "Family": "Familia",
            "Good": "Bueno",
            "Bad": "Malo",
            "Love": "Amor",
            "Time": "Tiempo",
            "Day": "Día",
            "Night": "Noche",
            "Water": "Agua",
            "Food": "Comida",
            "House": "Casa",
            "Car": "Coche",
            "Book": "Libro",
            "Phone": "Teléfono"
        ],
        "fr": [
            "Hello": "Bonjour",
            "Hi": "Salut",
            "World": "Monde",
            "Good morning": "Bonjour",
            "Thank you": "Merci",
            "Thanks": "Merci",
            "Please": "S'il vous plaît",
            "Welcome": "Bienvenue",
            "Goodbye": "Au revoir",
            "Bye": "Salut",
            "Yes": "Oui",
            "No": "Non",
            "Help": "Aide",
            "How are you": "Comment allez-vous?",
            "I love you": "Je t'aime",
            "Beautiful": "Beau",
            "Friend": "Ami",
            "Family": "Famille",
            "Good": "Bon",
            "Bad": "Mauvais",
            "Love": "Amour",
            "Time": "Temps",
            "Day": "Jour",
            "Night": "Nuit",
            "Water": "Eau",
            "Food": "Nourriture",
            "House": "Maison",
            "Car": "Voiture",
            "Book": "Livre",
            "Phone": "Téléphone"
        ],
        "de": [
            "Hello": "Hallo",
            "Hi": "Hallo",
            "World": "Welt",
            "Good morning": "Guten Morgen",
            "Thank you": "Danke",
            "Thanks": "Danke",
            "Please": "Bitte",
            "Welcome": "Willkommen",
            "Goodbye": "Auf Wiedersehen",
            "Bye": "Tschüss",
            "Yes": "Ja",
            "No": "Nein",
            "Help": "Hilfe",
            "How are you": "Wie geht es dir?",
            "I love you": "Ich liebe dich",
            "Beautiful": "Schön",
            "Friend": "Freund",
            "Family": "Familie",
            "Good": "Gut",
            "Bad": "Schlecht",
            "Love": "Liebe",
            "Time": "Zeit",
            "Day": "Tag",
            "Night": "Nacht",
            "Water": "Wasser",
            "Food": "Essen",
            "House": "Haus",
            "Car": "Auto",
            "Book": "Buch",
            "Phone": "Telefon"
        ],
        "it": [
            "Hello": "Ciao",
            "Hi": "Ciao",
            "Thank you": "Grazie",
            "Please": "Per favore",
            "Yes": "Sì",
            "No": "No",
            "Help": "Aiuto",
            "Good": "Buono",
            "Bad": "Cattivo",
            "Love": "Amore",
            "Time": "Tempo",
            "Day": "Giorno",
            "Night": "Notte",
            "Water": "Acqua",
            "Food": "Cibo",
            "House": "Casa",
            "Car": "Auto",
            "Book": "Libro",
            "Phone": "Telefono"
        ],
        "pt": [
            "Hello": "Olá",
            "Hi": "Oi",
            "Thank you": "Obrigado",
            "Please": "Por favor",
            "Yes": "Sim",
            "No": "Não",
            "Help": "Ajuda",
            "Good": "Bom",
            "Bad": "Mau",
            "Love": "Amor",
            "Time": "Tempo",
            "Day": "Dia",
            "Night": "Noite",
            "Water": "Água",
            "Food": "Comida",
            "House": "Casa",
            "Car": "Carro",
            "Book": "Livro",
            "Phone": "Telefone"
        ],
        "ko": [
            "Hello": "안녕하세요",
            "Hi": "안녕",
            "Thank you": "감사합니다",
            "Thanks": "고마워",
            "Please": "제발",
            "Yes": "네",
            "No": "아니요",
            "Help": "도와주세요",
            "Good": "좋은",
            "Bad": "나쁜",
            "Love": "사랑",
            "Time": "시간",
            "Day": "하루",
            "Night": "밤",
            "Water": "물",
            "Food": "음식",
            "House": "집",
            "Car": "자동차",
            "Book": "책",
            "Phone": "전화"
        ],
        "zh": [
            "Hello": "你好",
            "Hi": "嗨",
            "Thank you": "谢谢",
            "Thanks": "谢谢",
            "Please": "请",
            "Yes": "是",
            "No": "不",
            "Help": "帮助",
            "Good": "好",
            "Bad": "坏",
            "Love": "爱",
            "Time": "时间",
            "Day": "天",
            "Night": "夜",
            "Water": "水",
            "Food": "食物",
            "House": "房子",
            "Car": "汽车",
            "Book": "书",
            "Phone": "电话"
        ],
        "bg": [
            "Hello": "Здравейте",
            "Thank you": "Благодаря",
            "Yes": "Да",
            "No": "Не"
        ],
        "cs": [
            "Hello": "Ahoj",
            "Thank you": "Děkuji",
            "Yes": "Ano",
            "No": "Ne"
        ],
        "da": [
            "Hello": "Hej",
            "Thank you": "Tak",
            "Yes": "Ja",
            "No": "Nej"
        ],
        "nl": [
            "Hello": "Hallo",
            "Thank you": "Bedankt",
            "Yes": "Ja",
            "No": "Nee"
        ],
        "en": [
            "Hello": "Hello",
            "Thank you": "Thank you",
            "Yes": "Yes",
            "No": "No"
        ],
        "et": [
            "Hello": "Tere",
            "Thank you": "Aitäh",
            "Yes": "Jah",
            "No": "Ei"
        ],
        "fi": [
            "Hello": "Hei",
            "Thank you": "Kiitos",
            "Yes": "Kyllä",
            "No": "Ei"
        ],
        "el": [
            "Hello": "Γεια σας",
            "Thank you": "Ευχαριστώ",
            "Yes": "Ναι",
            "No": "Όχι"
        ],
        "hu": [
            "Hello": "Üdvözlöm",
            "Thank you": "Köszönöm",
            "Yes": "Igen",
            "No": "Nem"
        ],
        "lv": [
            "Hello": "Sveiki",
            "Thank you": "Paldies",
            "Yes": "Jā",
            "No": "Nē"
        ],
        "lt": [
            "Hello": "Sveiki",
            "Thank you": "Ačiū",
            "Yes": "Taip",
            "No": "Ne"
        ],
        "no": [
            "Hello": "Hei",
            "Thank you": "Takk",
            "Yes": "Ja",
            "No": "Nei"
        ],
        "pl": [
            "Hello": "Cześć",
            "Thank you": "Dziękuję",
            "Yes": "Tak",
            "No": "Nie"
        ],
        "ro": [
            "Hello": "Bună",
            "Thank you": "Mulțumesc",
            "Yes": "Da",
            "No": "Nu"
        ],
        "sk": [
            "Hello": "Ahoj",
            "Thank you": "Ďakujem",
            "Yes": "Áno",
            "No": "Nie"
        ],
        "sl": [
            "Hello": "Pozdravljeni",
            "Thank you": "Hvala",
            "Yes": "Da",
            "No": "Ne"
        ],
        "sv": [
            "Hello": "Hej",
            "Thank you": "Tack",
            "Yes": "Ja",
            "No": "Nej"
        ],
        "id": [
            "Hello": "Halo",
            "Thank you": "Terima kasih",
            "Yes": "Ya",
            "No": "Tidak"
        ],
        "tr": [
            "Hello": "Merhaba",
            "Thank you": "Teşekkürler",
            "Yes": "Evet",
            "No": "Hayır"
        ],
        "uk": [
            "Hello": "Привіт",
            "Thank you": "Дякую",
            "Yes": "Так",
            "No": "Ні"
        ],
        "ja": [
            "Hello": "こんにちは",
            "Hi": "やあ",
            "Thank you": "ありがとう",
            "Thanks": "ありがとう",
            "Please": "お願いします",
            "Yes": "はい",
            "No": "いいえ",
            "Help": "助けて",
            "Good": "良い",
            "Bad": "悪い",
            "Love": "愛",
            "Time": "時間",
            "Day": "日",
            "Night": "夜",
            "Water": "水",
            "Food": "食べ物",
            "House": "家",
            "Car": "車",
            "Book": "本",
            "Phone": "電話"
        ],
        "ar": [
            "Hello": "مرحبا",
            "Hi": "أهلا",
            "Thank you": "شكرا لك",
            "Thanks": "شكرا",
            "Please": "من فضلك",
            "Yes": "نعم",
            "No": "لا",
            "Help": "مساعدة",
            "Good": "جيد",
            "Bad": "سيء",
            "Love": "حب",
            "Time": "وقت",
            "Day": "يوم",
            "Night": "ليل",
            "Water": "ماء",
            "Food": "طعام",
            "House": "بيت",
            "Car": "سيارة",
            "Book": "كتاب",
            "Phone": "هاتف"
        ],
        "ru": [
            "Hello": "Привет",
            "Hi": "Привет",
            "Thank you": "Спасибо",
            "Thanks": "Спасибо",
            "Please": "Пожалуйста",
            "Yes": "Да",
            "No": "Нет",
            "Help": "Помощь",
            "Good": "Хорошо",
            "Bad": "Плохо",
            "Love": "Любовь",
            "Time": "Время",
            "Day": "День",
            "Night": "Ночь",
            "Water": "Вода",
            "Food": "Еда",
            "House": "Дом",
            "Car": "Машина",
            "Book": "Книга",
            "Phone": "Телефон"
        ]
    ]
    
    // MARK: - Helper Methods
    
    static func getLanguageCode(for language: String) -> String {
        return supportedLanguages[language] ?? "es"
    }
    
    static func getDemoTranslation(for text: String, to languageCode: String) -> String? {
        guard let languageTranslations = demoTranslations[languageCode] else { return nil }
        
        // Try to find exact matches first
        for (english, translation) in languageTranslations {
            if text.lowercased().contains(english.lowercased()) {
                return text.replacingOccurrences(of: english, with: translation, options: .caseInsensitive)
            }
        }
        
        // If no exact matches, try to translate common phrases
        let lowercasedText = text.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check for common phrases
        if lowercasedText == "hello" || lowercasedText == "hi" {
            return languageTranslations["Hello"] ?? "[\(languageCode.uppercased())] \(text)"
        }
        
        if lowercasedText == "thank you" || lowercasedText == "thanks" {
            return languageTranslations["Thank you"] ?? "[\(languageCode.uppercased())] \(text)"
        }
        
        if lowercasedText == "good morning" || lowercasedText == "goodmorning" {
            return languageTranslations["Good morning"] ?? "[\(languageCode.uppercased())] \(text)"
        }
        
        // If still no match, return a simulated translation
        return "[\(languageCode.uppercased())] \(text)"
    }
}
