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
    @State private var selectedLanguage = "Spanish"
    @State private var isProcessing = false
    @State private var showingLanguagePicker = false
    
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
        .onChange(of: selectedImage) { oldValue, newImage in
            if let image = newImage {
                processImage(image)
            }
        }
        .onChange(of: selectedLanguage) { oldValue, newLanguage in
            if !recognizedText.isEmpty {
                translateText(recognizedText, to: newLanguage)
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
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 300)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
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
                
                Text(selectedLanguage)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray5))
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
        isProcessing = true
        recognizedText = ""
        translatedText = ""
        
        viewModel.recognizeText(in: image) { text in
            DispatchQueue.main.async {
                self.recognizedText = text
                self.isProcessing = false
                
                if !text.isEmpty {
                    self.translateText(text, to: selectedLanguage)
                }
            }
        }
    }
    
    private func translateText(_ text: String, to language: String) {
        isProcessing = true
        print("🔄 Starting translation...")
        print("📝 Original text: '\(text)'")
        print("🌍 Target language: '\(language)'")
        
        viewModel.translateText(text, to: language) { translated in
            DispatchQueue.main.async {
                print("✅ Translation result: '\(translated)'")
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
