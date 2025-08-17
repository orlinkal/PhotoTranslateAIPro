# Info.plist Setup Guide - Step by Step

## 🚨 **Problem: No Info.plist in Info Tab**

If you don't see Info.plist configuration in the Info tab, follow these steps:

## 🛠️ **Method 1: Create New Info.plist File**

### **Step 1: Create the File**
1. **Right-click on PhotoTranslateAIPro folder** in project navigator
2. **Select "New File..."**
3. **Choose "Property List"** under Resource section
4. **Name: "Info.plist"**
5. **Target: Make sure "PhotoTranslateAIPro" is checked**
6. **Click "Create"**

### **Step 2: Add Permissions**
1. **Click on Info.plist** in project navigator
2. **Right-click in editor → "Add Row"**
3. **Add first permission:**
   - **Key**: `Privacy - Camera Usage Description`
   - **Type**: String
   - **Value**: `This app needs camera access to capture photos for text recognition and translation.`

4. **Add second permission:**
   - **Key**: `Privacy - Photo Library Usage Description`
   - **Type**: String
   - **Value**: `This app needs access to your photo library to select images for text recognition and translation.`

## 🔍 **Method 2: Check Project Configuration**

### **Step 1: Verify Target Settings**
1. **Click on project name** (PhotoTranslateAIPro)
2. **Select PhotoTranslateAIPro target**
3. **Go to "Build Settings" tab**
4. **Search for "Info.plist"**
5. **Look for "Info.plist File" setting**

### **Step 2: If Info.plist File is Empty**
- This means you need to create one (use Method 1)
- Or configure permissions in project settings

## 📱 **Step 3: Add Camera Capability**

1. **Go to "Signing & Capabilities" tab**
2. **Click "+ Capability"**
3. **Add "Camera" capability**

## 🧹 **Step 4: Clean and Build**

1. **Product → Clean Build Folder** (Cmd + Shift + K)
2. **Build project** (Cmd + B)

## ✅ **Verification**

After setup, you should have:
- [ ] Info.plist file in project navigator
- [ ] Camera permission in Info.plist
- [ ] Photo library permission in Info.plist
- [ ] Camera capability added
- [ ] Project builds without errors

## 🆘 **Common Issues**

### **Issue: "Info.plist not found"**
- **Solution**: Make sure Info.plist is added to your target
- **Solution**: Check "Info.plist File" setting in Build Settings

### **Issue: "Multiple commands produce Info.plist"**
- **Solution**: Don't have both project settings AND separate file
- **Solution**: Choose one method only

### **Issue: Camera still not working**
- **Solution**: Check device settings → Privacy & Security → Camera
- **Solution**: Verify camera capability is added

## 📋 **Complete Info.plist Content**

Your Info.plist should look like this:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>NSCameraUsageDescription</key>
    <string>This app needs camera access to capture photos for text recognition and translation.</string>
    <key>NSPhotoLibraryUsageDescription</key>
    <string>This app needs access to your photo library to select images for text recognition and translation.</string>
</dict>
</plist>
```

## 🎯 **Next Steps**

1. **Create Info.plist** using Method 1 above
2. **Add permissions** as shown
3. **Add camera capability**
4. **Clean and build**
5. **Test camera functionality**
