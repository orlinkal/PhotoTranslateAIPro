# Project Setup Guide

## Xcode Project Configuration

After opening the project in Xcode, you need to configure the following settings:

### 1. Target Settings

1. **Select the PhotoTranslateAIPro target** in the project navigator
2. **Go to the "Info" tab**
3. **Add the following keys to Info.plist**:

```
Privacy - Camera Usage Description (NSCameraUsageDescription)
Value: This app needs camera access to capture photos for text recognition and translation.

Privacy - Photo Library Usage Description (NSPhotoLibraryUsageDescription)
Value: This app needs access to your photo library to select images for text recognition and translation.
```

### 2. Build Settings

1. **Go to "Build Settings" tab**
2. **Search for "iOS Deployment Target"**
3. **Set it to iOS 15.0 or higher**

### 3. Capabilities

1. **Go to "Signing & Capabilities" tab**
2. **Click "+ Capability"**
3. **Add "Camera" capability**

### 4. Clean Build

1. **Product → Clean Build Folder** (Cmd + Shift + K)
2. **Product → Build** (Cmd + B)

## Alternative: Add Info.plist Manually

If you prefer to have a separate Info.plist file:

1. **Right-click on the PhotoTranslateAIPro folder** in Xcode
2. **New File → Property List**
3. **Name it "Info.plist"**
4. **Add the permission keys above**

## Common Issues & Solutions

### Build Error: "cannot find type 'VNRequestTextRecognitionLevel'"
- **Solution**: Ensure `import Vision` is added to Configuration.swift

### Build Error: "Multiple commands produce Info.plist"
- **Solution**: Remove duplicate Info.plist files or ensure only one exists

### Camera Permission Denied
- **Solution**: Check device settings → Privacy & Security → Camera → PhotoTranslateAIPro

### Photo Library Permission Denied
- **Solution**: Check device settings → Privacy & Security → Photos → PhotoTranslateAIPro

## Testing

1. **Build and run on a physical device** (recommended for camera testing)
2. **Grant permissions when prompted**
3. **Test camera and photo library access**
4. **Verify text recognition works**

## Troubleshooting

If you still have build issues:

1. **Clean build folder** (Cmd + Shift + K)
2. **Delete derived data**: Xcode → Preferences → Locations → Derived Data → Delete
3. **Restart Xcode**
4. **Check that all files are included in the target**

## File Structure

Your project should now have this structure:
```
PhotoTranslateAIPro/
├── ContentView.swift          # Main UI
├── PhotoTranslateViewModel.swift  # Business logic
├── ImagePicker.swift          # Camera/Photo library
├── Configuration.swift         # App settings
├── PhotoTranslateAIProApp.swift  # App entry point
└── Assets.xcassets/           # App icons
```

## Next Steps

1. **Configure the project settings** as described above
2. **Build and test** the app
3. **Test camera and photo library** functionality
4. **Verify text recognition** works with sample images
5. **Test translation** functionality
