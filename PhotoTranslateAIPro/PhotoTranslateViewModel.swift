//
//  PhotoTranslateViewModel.swift
//  PhotoTranslateAIPro
//
//  Created by Orlin Kalev on 17.08.25.
//

import Foundation
import Vision
import UIKit

class PhotoTranslateViewModel: ObservableObject {
    
    private let deepLService: DeepLTranslationService?
    
    init() {
        // Initialize DeepL service if API key is available
        print("🔧 Initializing PhotoTranslateViewModel...")
        print("🔑 API Key available: \(Configuration.hasValidAPIKey)")
        print("🚀 Use Real API: \(Configuration.useRealTranslationAPI)")
        print("🔑 API Key: \(Configuration.deepLAPIKey)")
        
        if Configuration.hasValidAPIKey {
            self.deepLService = DeepLTranslationService(apiKey: Configuration.deepLAPIKey)
            print("✅ DeepL service initialized successfully")
        } else {
            self.deepLService = nil
            print("❌ DeepL service not initialized - no valid API key")
        }
    }
    
    // MARK: - Text Recognition
    
    func recognizeText(in image: UIImage, completion: @escaping (String) -> Void) {
        guard let cgImage = image.cgImage else {
            print("Error: Could not get CGImage from UIImage")
            completion("")
            return
        }
        
        // Check if Vision framework is available
        guard #available(iOS 13.0, *) else {
            print("Error: Vision framework requires iOS 13.0+")
            completion("")
            return
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                print("Text recognition error: \(error)")
                completion("")
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion("")
                return
            }
            
            let recognizedText = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }.joined(separator: " ")
            
            completion(recognizedText)
        }
        
        // Configure the request for better accuracy
        request.recognitionLevel = Configuration.TextRecognition.recognitionLevel
        request.usesLanguageCorrection = Configuration.TextRecognition.usesLanguageCorrection
        
        do {
            try requestHandler.perform([request])
        } catch {
            print("Failed to perform text recognition: \(error)")
            DispatchQueue.main.async {
                completion("")
            }
        }
    }
    
    // MARK: - Translation
    
    func translateText(_ text: String, to language: String, completion: @escaping (String) -> Void) {
        print("🔍 Translation request - Text: '\(text)', Language: '\(language)'")
        print("🔑 DeepL service available: \(deepLService != nil)")
        print("🚀 Use Real API setting: \(Configuration.useRealTranslationAPI)")
        
        // Check if we have DeepL API available
        if let deepLService = deepLService, Configuration.useRealTranslationAPI {
            print("🚀 Using DeepL API for translation")
            deepLService.translate(text: text, to: language) { result in
                switch result {
                case .success(let translatedText):
                    print("✅ DeepL translation result: '\(translatedText)'")
                    completion(translatedText)
                case .failure(let error):
                    print("❌ DeepL translation failed: \(error.localizedDescription)")
                    // Fallback to demo translation
                    self.fallbackToDemoTranslation(text, to: language, completion: completion)
                }
            }
        } else {
            print("🔄 Using demo translation (DeepL API not available)")
            print("🔍 Reason: deepLService=\(deepLService != nil), useRealAPI=\(Configuration.useRealTranslationAPI)")
            fallbackToDemoTranslation(text, to: language, completion: completion)
        }
    }
    
    private func fallbackToDemoTranslation(_ text: String, to language: String, completion: @escaping (String) -> Void) {
        let targetLanguage = getLanguageCode(for: language)
        print("🔤 Language code for '\(language)': '\(targetLanguage)'")
        
        // Simulate API call delay
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            let translatedText = self.simulateTranslation(text, to: targetLanguage)
            print("🔄 Demo translation result: '\(translatedText)'")
            completion(translatedText)
        }
    }
    
    private func getLanguageCode(for language: String) -> String {
        return Configuration.getLanguageCode(for: language)
    }
    
    private func simulateTranslation(_ text: String, to languageCode: String) -> String {
        print("🔍 Looking for translation of '\(text)' to '\(languageCode)'")
        
        // Use the configuration for demo translations
        if let translation = Configuration.getDemoTranslation(for: text, to: languageCode) {
            print("✅ Found demo translation: '\(translation)'")
            return translation
        }
        
        print("❌ No demo translation found, using fallback")
        // If no exact matches, return a simulated translation
        return "[\(languageCode.uppercased())] \(text)"
    }
}

// MARK: - Real Translation API Integration (Example)

extension PhotoTranslateViewModel {
    
    // Example of how to integrate with a real translation API
    func translateWithRealAPI(_ text: String, to languageCode: String, completion: @escaping (String) -> Void) {
        // You would need to sign up for a translation service and get an API key
        // Example services: Google Translate, DeepL, Microsoft Translator, etc.
        
        let apiKey = "YOUR_API_KEY_HERE" // Store this securely
        let baseURL = "https://translation-api.example.com/translate"
        
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "text", value: text),
            URLQueryItem(name: "target", value: languageCode),
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        guard let url = components?.url else {
            completion("")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Translation API error: \(error)")
                completion("")
                return
            }
            
            guard let data = data else {
                completion("")
                return
            }
            
            // Parse the response based on your chosen API
            // This is just an example structure
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let translatedText = json["translatedText"] as? String {
                    completion(translatedText)
                } else {
                    completion("")
                }
            } catch {
                print("Failed to parse translation response: \(error)")
                completion("")
            }
        }
        
        task.resume()
    }
}
