import Foundation

class DeepLTranslationService {
    private let apiKey: String
    private let baseURL = "https://api.deepl.com/v2/translate"
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func translate(text: String, to targetLanguage: String, completion: @escaping (Result<String, TranslationError>) -> Void) {
        // Convert our language names to DeepL language codes
        let deepLLanguageCode = convertToDeepLLanguageCode(targetLanguage)
        
        print("🌍 DeepL: Translating '\(text)' to '\(targetLanguage)' (code: \(deepLLanguageCode))")
        
        // Prepare the request
        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("DeepL-Auth-Key \(apiKey)", forHTTPHeaderField: "Authorization")
        
        // Prepare the body parameters - send the FULL text, not just individual words
        let bodyParameters = [
            "text": text,
            "target_lang": deepLLanguageCode
        ]
        
        let bodyString = bodyParameters.map { key, value in
            "\(key)=\(value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? value)"
        }.joined(separator: "&")
        
        request.httpBody = bodyString.data(using: .utf8)
        
        // Make the API call
        print("🌐 DeepL: Making API request to \(baseURL)")
        print("📝 DeepL: Request body: \(bodyString)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ DeepL: Network error: \(error)")
                    completion(.failure(.networkError(error)))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("📡 DeepL: HTTP Response: \(httpResponse.statusCode)")
                }
                
                guard let data = data else {
                    print("❌ DeepL: No data received")
                    completion(.failure(.noData))
                    return
                }
                
                print("📄 DeepL: Received data: \(String(data: data, encoding: .utf8) ?? "Unable to decode")")
                
                do {
                    let translationResponse = try JSONDecoder().decode(DeepLResponse.self, from: data)
                    if let translatedText = translationResponse.translations.first?.text {
                        print("✅ DeepL: Translation successful: '\(translatedText)'")
                        completion(.success(translatedText))
                    } else {
                        print("❌ DeepL: No translation in response")
                        completion(.failure(.noTranslation))
                    }
                } catch {
                    print("❌ DeepL: Parsing error: \(error)")
                    completion(.failure(.parsingError(error)))
                }
            }
        }.resume()
    }
    
    private func convertToDeepLLanguageCode(_ language: String) -> String {
        // DeepL language codes mapping
        let languageMapping: [String: String] = [
            "Spanish": "ES",
            "French": "FR",
            "German": "DE",
            "Italian": "IT",
            "Portuguese": "PT",
            "Russian": "RU",
            "Japanese": "JA",
            "Chinese": "ZH",
            "Korean": "KO",
            "Arabic": "AR"
        ]
        
        return languageMapping[language] ?? "EN"
    }
}

// MARK: - DeepL API Response Models
struct DeepLResponse: Codable {
    let translations: [Translation]
}

struct Translation: Codable {
    let text: String
    let detectedSourceLanguage: String
    
    enum CodingKeys: String, CodingKey {
        case text
        case detectedSourceLanguage = "detected_source_language"
    }
}

// MARK: - Translation Errors
enum TranslationError: Error, LocalizedError {
    case networkError(Error)
    case noData
    case noTranslation
    case parsingError(Error)
    case invalidAPIKey
    
    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .noData:
            return "No data received from translation service"
        case .noTranslation:
            return "No translation available"
        case .parsingError(let error):
            return "Failed to parse response: \(error.localizedDescription)"
        case .invalidAPIKey:
            return "Invalid API key"
        }
    }
}
