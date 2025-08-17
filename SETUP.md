# Photo Translate AI Pro - Setup Guide

## Quick Start

1. **Open the Project**
   - Open `PhotoTranslateAIPro.xcodeproj` in Xcode
   - Wait for Xcode to index the project

2. **Select Target Device**
   - Choose a physical iOS device (recommended for camera testing)
   - Or use iOS Simulator (limited camera functionality)

3. **Build and Run**
   - Press `Cmd + R` or click the Play button
   - The app should build successfully and launch

## Required Permissions

The app will request these permissions when needed:

- **Camera Access**: For taking photos
- **Photo Library Access**: For selecting existing photos

## Testing the App

### Demo Mode (Default)
- The app comes with simulated translations for common phrases
- Test with images containing English text like "Hello", "Thank you", "Good morning"
- Supported demo languages: Spanish, French, German

### Real Translation API (Optional)
To use real translation services:

1. **Get API Key** from one of these services:
   - Google Translate API
   - DeepL API
   - Microsoft Translator

2. **Update Configuration.swift**:
   ```swift
   static let useRealTranslationAPI = true
   static let googleAPIKey = "YOUR_ACTUAL_API_KEY"
   ```

3. **Update PhotoTranslateViewModel.swift** to use real API calls

## Troubleshooting

### Build Errors
- Ensure Xcode version is 13.0+
- iOS deployment target should be 15.0+
- Clean build folder: `Cmd + Shift + K`

### Camera Issues
- Test on physical device (simulator has limited camera support)
- Check camera permissions in device settings
- Ensure camera is not being used by another app

### Text Recognition Issues
- Use clear, high-contrast images
- Ensure text is readable and well-lit
- Try different text orientations

## Project Structure

```
PhotoTranslateAIPro/
├── ContentView.swift          # Main UI
├── PhotoTranslateViewModel.swift  # Business logic
├── ImagePicker.swift          # Camera/Photo library
├── Configuration.swift         # App settings
├── Info.plist                 # Permissions
└── Assets.xcassets/           # App icons
```

## Next Steps

1. **Test Basic Functionality**: Camera, photo selection, text recognition
2. **Customize UI**: Modify colors, fonts, layouts in ContentView.swift
3. **Add Real API**: Integrate with translation service of your choice
4. **Enhance Features**: Add offline support, voice input, history

## Support

- Check the main README.md for detailed documentation
- Review Apple's Vision and VisionKit documentation
- Test on different devices and iOS versions
