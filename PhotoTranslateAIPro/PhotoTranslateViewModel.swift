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
        // For demo purposes, we'll use a simple translation service
        // In a real app, you would integrate with Google Translate API, DeepL, or similar
        
        let targetLanguage = getLanguageCode(for: language)
        
        // Simulate API call delay
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            let translatedText = self.simulateTranslation(text, to: targetLanguage)
            completion(translatedText)
        }
    }
    
    private func getLanguageCode(for language: String) -> String {
        return Configuration.getLanguageCode(for: language)
    }
    
    private func simulateTranslation(_ text: String, to languageCode: String) -> String {
        // Use the configuration for demo translations
        if let translation = Configuration.getDemoTranslation(for: text, to: languageCode) {
            return translation
        }
        
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
