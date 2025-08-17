//
//  ContentView.swift
//  PhotoTranslateAIPro
//
//  Created by Orlin Kalev on 17.08.25.
//

import SwiftUI
import Vision
import VisionKit

struct ContentView: View {
    @StateObject private var viewModel = PhotoTranslateViewModel()
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var selectedImage: UIImage?
    @State private var recognizedText = ""
    @State private var translatedText = ""
    @State private var selectedLanguage = "English"
    @State private var detectedLanguage = "Unknown"
    @State private var isProcessing = false
    @State private var showingLanguagePicker = false
    @State private var showingMagicWandSelector = false
    @State private var textFromMagicWand = false
    @State private var translationRefreshTrigger = false
    
    private let supportedLanguages = Array(Configuration.supportedLanguages.keys)
    
    // Debug: Print available languages
    init() {
        print("🌍 Available languages: \(Array(Configuration.supportedLanguages.keys))")
        print("🌍 Language codes: \(Array(Configuration.supportedLanguages.values))")
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Main content
                ScrollView {
                    VStack(spacing: 24) {
                        // Image capture section
                        imageCaptureSection
                        
                        // Text recognition section
                        if !recognizedText.isEmpty {
                            textRecognitionSection
                        }
                        
                        // Translation section
                        if !translatedText.isEmpty {
                            translationSection
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 30)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
        }
        .sheet(isPresented: $showingCamera) {
            ImagePicker(selectedImage: $selectedImage, sourceType: .camera)
        }
        .sheet(isPresented: $showingLanguagePicker) {
            LanguagePickerView(selectedLanguage: $selectedLanguage, languages: supportedLanguages)
        }
        .sheet(isPresented: $showingMagicWandSelector) {
            if let image = selectedImage {
                NavigationView {
                    MagicWandTextSelector(image: image, selectedText: $recognizedText)
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationTitle("Magic Wand Selection")
                        .onDisappear {
                            print("🔍 Magic wand sheet disappeared")
                            print("📝 Current recognizedText: '\(recognizedText)'")
                            // If we have text and the magic wand is closing, mark it as from magic wand
                            if !recognizedText.isEmpty {
                                textFromMagicWand = true
                                print("✅ Marked text as from magic wand")
                                // Immediately trigger translation refresh
                                DispatchQueue.main.async {
                                    print("🔄 Triggering immediate translation refresh")
                                    self.translatedText = ""
                                    self.translateText(self.recognizedText, to: self.selectedLanguage)
                                }
                            }
                        }
                }
                .navigationViewStyle(StackNavigationViewStyle())
            }
        }
        .onChange(of: selectedImage) { oldValue, newImage in
            if let image = newImage {
                // Reset magic wand flag for new image
                textFromMagicWand = false
                // Only process the full image if we don't have recognized text from magic wand
                if recognizedText.isEmpty && !textFromMagicWand {
                    processImage(image)
                }
            }
        }
        .onChange(of: selectedLanguage) { oldValue, newLanguage in
            print("🌍 Language changed from '\(oldValue)' to '\(newLanguage)'")
            print("📝 Current recognizedText: '\(recognizedText)'")
            print("🔮 textFromMagicWand flag: \(textFromMagicWand)")
            if !recognizedText.isEmpty && !textFromMagicWand {
                print("🚀 Triggering translation of recognized text (full image)")
                translateText(recognizedText, to: newLanguage)
            } else if textFromMagicWand && !recognizedText.isEmpty {
                print("🎯 Magic wand active, translating selected text")
                translateText(recognizedText, to: newLanguage)
            }
        }
        .onChange(of: recognizedText) { oldValue, newText in
            print("📝 recognizedText changed from '\(oldValue)' to '\(newText)'")
            print("🔮 textFromMagicWand flag: \(textFromMagicWand)")
            
            // If text comes from magic wand, translate it immediately
            if textFromMagicWand && !newText.isEmpty {
                print("🎯 Magic wand text detected, translating immediately")
                // Clear any previous translation
                translatedText = ""
                // Trigger translation refresh
                translationRefreshTrigger.toggle()
            }
        }
        .onChange(of: translationRefreshTrigger) { oldValue, newValue in
            if textFromMagicWand && !recognizedText.isEmpty {
                print("🔄 Translation refresh triggered for magic wand text")
                translateText(recognizedText, to: selectedLanguage)
            }
        }
    }
    

    
    private var headerView: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Photo Translate")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Capture text and translate instantly")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    showingLanguagePicker = true
                }) {
                    HStack(spacing: 8) {
                        Text(selectedLanguage)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Image(systemName: "chevron.down")
                            .font(.caption)
                    }
                    .foregroundColor(.blue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(20)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            Divider()
        }
        .background(Color(.systemBackground))
    }
    
    private var imageCaptureSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Capture Text")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            if let image = selectedImage {
                VStack(spacing: 12) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 300)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                    
                    Button(action: {
                        showingMagicWandSelector = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "wand.and.stars")
                                .font(.system(size: 16, weight: .medium))
                            Text("Magic Wand Text Selection")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color.purple)
                        .cornerRadius(12)
                    }
                }
            } else {
                placeholderView
            }
            
            HStack(spacing: 16) {
                Button(action: {
                    showingCamera = true
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 16, weight: .medium))
                        Text("Camera")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                
                Button(action: {
                    showingImagePicker = true
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "photo.fill")
                            .font(.system(size: 16, weight: .medium))
                        Text("Photo Library")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                }
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
    }
    
    private var placeholderView: some View {
        VStack(spacing: 16) {
            Image(systemName: "camera.viewfinder")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("No image selected")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("Use the camera or photo library to capture text")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private var textRecognitionSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Recognized Text")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(detectedLanguage)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                
                if isProcessing {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }
            
            Text(recognizedText)
                .font(.body)
                .foregroundColor(.primary)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(12)
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
    }
    
    private var translationSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Translation")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text("→")
                        .font(.caption)
                        .foregroundColor(.blue)
                    Text(selectedLanguage)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
            
            Text(translatedText)
                .font(.body)
                .foregroundColor(.primary)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(12)
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
    }
    
    private func processImage(_ image: UIImage) {
        print("🖼️ processImage called - processing full image")
        print("🔮 textFromMagicWand flag: \(textFromMagicWand)")
        
        // Don't process full image if magic wand is active
        if textFromMagicWand {
            print("🚫 Skipping full image processing - magic wand is active")
            return
        }
        
        isProcessing = true
        recognizedText = ""
        translatedText = ""
        detectedLanguage = "Unknown"
        
        viewModel.recognizeText(in: image) { text in
            DispatchQueue.main.async {
                print("📝 Full image recognition result: '\(text)'")
                self.recognizedText = text
                self.isProcessing = false
                
                if !text.isEmpty {
                    // Detect the language of the recognized text
                    self.detectLanguage(text)
                    self.translateText(text, to: selectedLanguage)
                }
            }
        }
    }
    
    private func detectLanguage(_ text: String) {
        // Simple language detection based on common words
        let lowercasedText = text.lowercased()
        
        if lowercasedText.contains("hello") || lowercasedText.contains("the") || lowercasedText.contains("and") {
            detectedLanguage = "English"
        } else if lowercasedText.contains("hola") || lowercasedText.contains("gracias") || lowercasedText.contains("por") {
            detectedLanguage = "Spanish"
        } else if lowercasedText.contains("bonjour") || lowercasedText.contains("merci") || lowercasedText.contains("pour") {
            detectedLanguage = "French"
        } else if lowercasedText.contains("hallo") || lowercasedText.contains("danke") || lowercasedText.contains("für") {
            detectedLanguage = "German"
        } else if lowercasedText.contains("ciao") || lowercasedText.contains("grazie") || lowercasedText.contains("per") {
            detectedLanguage = "Italian"
        } else if lowercasedText.contains("olá") || lowercasedText.contains("obrigado") || lowercasedText.contains("para") {
            detectedLanguage = "Portuguese"
        } else if lowercasedText.contains("привет") || lowercasedText.contains("спасибо") || lowercasedText.contains("для") {
            detectedLanguage = "Russian"
        } else if lowercasedText.contains("こんにちは") || lowercasedText.contains("ありがとう") || lowercasedText.contains("の") {
            detectedLanguage = "Japanese"
        } else if lowercasedText.contains("안녕하세요") || lowercasedText.contains("감사합니다") || lowercasedText.contains("을") {
            detectedLanguage = "Korean"
        } else if lowercasedText.contains("你好") || lowercasedText.contains("谢谢") || lowercasedText.contains("的") {
            detectedLanguage = "Chinese"
        } else {
            detectedLanguage = "Unknown"
        }
    }
    
    private func translateText(_ text: String, to language: String) {
        isProcessing = true
        print("🔄 ContentView translateText called with:")
        print("📝 Text to translate: '\(text)'")
        print("🌍 Target language: '\(language)'")
        print("🔮 textFromMagicWand flag: \(textFromMagicWand)")
        
        viewModel.translateText(text, to: language) { translated in
            DispatchQueue.main.async {
                print("✅ Translation completed: '\(translated)'")
                self.translatedText = translated
                self.isProcessing = false
            }
        }
    }
}

struct LanguagePickerView: View {
    @Binding var selectedLanguage: String
    let languages: [String]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List(languages, id: \.self) { language in
                Button(action: {
                    selectedLanguage = language
                    dismiss()
                }) {
                    HStack {
                        Text(language)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        if language == selectedLanguage {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Select Language")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
