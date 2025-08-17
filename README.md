# Photo Translate AI Pro

A beautiful iOS app that recognizes text in photos and provides instant translations in multiple languages. Built with SwiftUI and following Apple's design guidelines.

## Features

- 📸 **Camera Integration**: Capture photos directly from the app
- 🖼️ **Photo Library Access**: Select existing photos from your device
- 🔍 **Text Recognition**: Advanced OCR using Apple's Vision framework
- 🌍 **Multi-language Translation**: Support for 10+ languages
- 🎨 **Apple Design**: Native iOS interface following Apple's Human Interface Guidelines
- ⚡ **Real-time Processing**: Instant text recognition and translation

## Supported Languages

- Spanish
- French
- German
- Italian
- Portuguese
- Russian
- Japanese
- Korean
- Chinese
- Arabic

## Screenshots

The app features a clean, modern interface with:
- Elegant header with language selector
- Image capture section with camera and photo library options
- Text recognition display
- Translation results
- Smooth animations and transitions

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+
- Camera access permission
- Photo library access permission

## Installation

1. Clone the repository
2. Open `PhotoTranslateAIPro.xcodeproj` in Xcode
3. Select your target device or simulator
4. Build and run the project

## Setup

### 1. Camera and Photo Library Permissions

The app automatically requests permissions when needed. The required permissions are defined in `Info.plist`:

- `NSCameraUsageDescription`: Camera access for photo capture
- `NSPhotoLibraryUsageDescription`: Photo library access for image selection

### 2. Translation API Integration

Currently, the app uses a simulated translation service for demonstration. To integrate with a real translation API:

1. **Choose a Translation Service**:
   - Google Translate API
   - DeepL API
   - Microsoft Translator
   - Amazon Translate

2. **Get API Key**: Sign up for your chosen service and obtain an API key

3. **Update the ViewModel**: Replace the `simulateTranslation` method with real API calls in `PhotoTranslateViewModel.swift`

Example integration with Google Translate:

```swift
func translateWithGoogleAPI(_ text: String, to languageCode: String, completion: @escaping (String) -> Void) {
    let apiKey = "YOUR_GOOGLE_API_KEY"
    let baseURL = "https://translation.googleapis.com/language/translate/v2"
    
    var components = URLComponents(string: baseURL)
    components?.queryItems = [
        URLQueryItem(name: "q", value: text),
        URLQueryItem(name: "target", value: languageCode),
        URLQueryItem(name: "key", value: apiKey)
    ]
    
    // Implementation details...
}
```

## Architecture

The app follows MVVM architecture:

- **ContentView**: Main UI and user interactions
- **PhotoTranslateViewModel**: Business logic for text recognition and translation
- **ImagePicker**: Camera and photo library integration
- **Vision Framework**: Apple's text recognition engine

## Key Components

### Text Recognition
Uses Apple's Vision framework for accurate OCR:
- High-accuracy recognition
- Language correction
- Support for multiple text orientations

### Translation
- Simulated translation service (demo mode)
- Easy integration with real APIs
- Support for multiple target languages

### UI/UX
- Native iOS design language
- Adaptive layouts for different screen sizes
- Smooth animations and transitions
- Accessibility support

## Usage

1. **Launch the App**: Open Photo Translate AI Pro
2. **Select Language**: Choose your target translation language
3. **Capture Text**: Use camera or select from photo library
4. **View Recognition**: See the recognized text
5. **Get Translation**: View the translated result

## Customization

### Adding New Languages

To add support for additional languages:

1. Update the `supportedLanguages` array in `ContentView.swift`
2. Add language codes in `PhotoTranslateViewModel.swift`
3. Implement translations for the new language

### UI Customization

The app uses SwiftUI with Apple's system colors and fonts. To customize:

- Modify color schemes in the view modifiers
- Adjust spacing and padding values
- Update font weights and sizes

## Troubleshooting

### Common Issues

1. **Camera Not Working**: Ensure camera permissions are granted
2. **Text Recognition Fails**: Check image quality and text clarity
3. **Translation Errors**: Verify API key and internet connection

### Debug Mode

Enable debug logging by setting breakpoints in:
- `PhotoTranslateViewModel.recognizeText`
- `PhotoTranslateViewModel.translateText`

## Future Enhancements

- [ ] Offline translation support
- [ ] Voice input for text
- [ ] History of translations
- [ ] Share translations
- [ ] Batch processing
- [ ] Custom language models

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Create an issue in the repository
- Check the troubleshooting section
- Review Apple's documentation for Vision and VisionKit

## Acknowledgments

- Apple for Vision framework and SwiftUI
- SwiftUI community for best practices
- Design inspiration from Apple's Human Interface Guidelines
