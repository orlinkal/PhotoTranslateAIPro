# Xcode Configuration Guide - Fix Duplicate Info.plist

## 🚨 **Current Issue**
Multiple commands produce Info.plist - this means Xcode is trying to create the same file from multiple sources.

## 🔍 **Step-by-Step Fix**

### **1. Remove All Info.plist References**

#### **Check Project Navigator:**
- Look for any Info.plist files in your project
- If you see multiple, keep only one or none
- Right-click → Delete → Move to Trash

#### **Check Target Build Phases:**
1. Select PhotoTranslateAIPro target
2. Go to "Build Phases" tab
3. Expand "Copy Bundle Resources"
4. **Remove Info.plist if present** (drag out or click -)

#### **Check Target Build Settings:**
1. Go to "Build Settings" tab
2. Search for "Info.plist"
3. Find "Info.plist File" setting
4. **Clear/delete the value** (leave it empty)

### **2. Configure Permissions in Project Settings**

#### **Method A: Use Target Info Tab (Recommended)**
1. Select your target
2. Go to "Info" tab
3. Add these keys:

```
Key: Privacy - Camera Usage Description
Value: This app needs camera access to capture photos for text recognition and translation.

Key: Privacy - Photo Library Usage Description  
Value: This app needs access to your photo library to select images for text recognition and translation.
```

#### **Method B: Create New Info.plist (Alternative)**
1. Right-click on PhotoTranslateAIPro folder
2. New File → Property List
3. Name: "Info.plist"
4. **Make sure it's added to your target**
5. Add the permission keys above

### **3. Add Required Capabilities**

1. Go to "Signing & Capabilities" tab
2. Click "+ Capability"
3. Add "Camera" capability

### **4. Verify iOS Deployment Target**

1. Go to "Build Settings" tab
2. Search for "iOS Deployment Target"
3. Set to iOS 15.0 or higher

### **5. Clean and Rebuild**

1. Product → Clean Build Folder (Cmd + Shift + K)
2. Xcode → Preferences → Locations → Derived Data → Delete
3. Restart Xcode
4. Build the project

## 🚫 **What NOT to Do**

- ❌ Don't have Info.plist in both project settings AND separate file
- ❌ Don't have Info.plist in Copy Bundle Resources
- ❌ Don't have multiple Info.plist files
- ❌ Don't set "Info.plist File" path if using project settings

## ✅ **What TO Do**

- ✅ Use ONE method: either project settings OR separate file
- ✅ Clean build folder after changes
- ✅ Delete derived data
- ✅ Restart Xcode if needed

## 🔍 **Troubleshooting**

### **Still Getting Error?**
1. Check if Info.plist appears in multiple places
2. Verify no duplicate references in build phases
3. Ensure only one Info.plist configuration method

### **Build Succeeds but App Crashes?**
1. Check device permissions in Settings
2. Verify camera capability is added
3. Test with debug button first

## 📱 **Final Verification**

After configuration:
- [ ] No duplicate Info.plist files
- [ ] Permissions configured (camera + photo library)
- [ ] Camera capability added
- [ ] iOS deployment target set correctly
- [ ] Clean build successful
- [ ] App runs without crashing

## 🆘 **Need Help?**

If you're still having issues:
1. Take a screenshot of your project navigator
2. Show your target build phases
3. Show your target build settings (Info.plist section)
4. Share any error messages
