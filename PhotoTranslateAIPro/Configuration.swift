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
    
    // Set to true to use real translation API, false for demo mode
    static let useRealTranslationAPI = false
    
    // Translation service configuration
    struct TranslationAPI {
        // Google Translate API
        static let googleAPIKey = "YOUR_GOOGLE_API_KEY_HERE"
        static let googleBaseURL = "https://translation.googleapis.com/language/translate/v2"
        
        // DeepL API
        static let deepLAPIKey = "YOUR_DEEPL_API_KEY_HERE"
        static let deepLBaseURL = "https://api-free.deepl.com/v2/translate"
        
        // Microsoft Translator
        static let microsoftAPIKey = "YOUR_MICROSOFT_API_KEY_HERE"
        static let microsoftBaseURL = "https://api.cognitive.microsofttranslator.com/translate"
        static let microsoftRegion = "YOUR_AZURE_REGION_HERE"
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
    
    // MARK: - Supported Languages
    
    static let supportedLanguages = [
        "Spanish": "es",
        "French": "fr", 
        "German": "de",
        "Italian": "it",
        "Portuguese": "pt",
        "Russian": "ru",
        "Japanese": "ja",
        "Korean": "ko",
        "Chinese": "zh",
        "Arabic": "ar"
    ]
    
    // MARK: - Demo Translations
    
    static let demoTranslations: [String: [String: String]] = [
        "es": [
            "Hello": "Hola",
            "World": "Mundo",
            "Good morning": "Buenos días",
            "Thank you": "Gracias",
            "Please": "Por favor",
            "Welcome": "Bienvenido",
            "Goodbye": "Adiós",
            "Yes": "Sí",
            "No": "No",
            "Help": "Ayuda",
            "How are you": "¿Cómo estás?",
            "I love you": "Te quiero",
            "Beautiful": "Hermoso",
            "Friend": "Amigo",
            "Family": "Familia"
        ],
        "fr": [
            "Hello": "Bonjour",
            "World": "Monde",
            "Good morning": "Bonjour",
            "Thank you": "Merci",
            "Please": "S'il vous plaît",
            "Welcome": "Bienvenue",
            "Goodbye": "Au revoir",
            "Yes": "Oui",
            "No": "Non",
            "Help": "Aide",
            "How are you": "Comment allez-vous?",
            "I love you": "Je t'aime",
            "Beautiful": "Beau",
            "Friend": "Ami",
            "Family": "Famille"
        ],
        "de": [
            "Hello": "Hallo",
            "World": "Welt",
            "Good morning": "Guten Morgen",
            "Thank you": "Danke",
            "Please": "Bitte",
            "Welcome": "Willkommen",
            "Goodbye": "Auf Wiedersehen",
            "Yes": "Ja",
            "No": "Nein",
            "Help": "Hilfe",
            "How are you": "Wie geht es dir?",
            "I love you": "Ich liebe dich",
            "Beautiful": "Schön",
            "Friend": "Freund",
            "Family": "Familie"
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
        
        return nil
    }
}
