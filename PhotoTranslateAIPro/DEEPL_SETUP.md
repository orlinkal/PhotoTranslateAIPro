# DeepL API Setup Guide

## 🚀 Enable Real Translation API

Your app now supports DeepL API for high-quality translations! Here's how to set it up:

### Step 1: Get Your DeepL API Key

1. Go to [DeepL API](https://www.deepl.com/pro-api)
2. Sign up for a free account
3. Get your API key (starts with `deepL-`)

### Step 2: Update Configuration

1. Open `PhotoTranslateAIPro/Configuration.swift`
2. Find this line:
   ```swift
   static let deepLAPIKey = "YOUR_DEEPL_API_KEY_HERE"
   ```
3. Replace `YOUR_DEEPL_API_KEY_HERE` with your actual API key:
   ```swift
   static let deepLAPIKey = "deepL-12345678-abcdef12-34567890"
   ```

### Step 3: Enable Real API

1. In the same file, find:
   ```swift
   static let useRealTranslationAPI = false
   ```
2. Change it to:
   ```swift
   static let useRealTranslationAPI = true
   ```

### Step 4: Build and Test

1. Build and run the app
2. Take a photo with text
3. Select any language
4. You should see "🚀 Using DeepL API for translation" in the console

## 🌟 Benefits of DeepL API

- **Full sentence translation** instead of word-by-word
- **Context-aware** translations
- **Higher quality** than demo translations
- **Supports 29 languages** with excellent accuracy
- **Very affordable** (~$6 per million characters)

## 🔄 Fallback System

- If DeepL API fails, the app automatically falls back to demo translations
- If no API key is provided, demo translations are used
- This ensures the app always works, even offline

## 💰 Cost Example

- **1 photo with 100 words** = ~$0.0006 (less than 1 cent)
- **100 photos per month** = ~$0.06
- **Very affordable** for personal use!

## 🚨 Important Notes

- Keep your API key private and secure
- The free tier has usage limits
- DeepL works best with European languages
- For production apps, consider paid plans

## 🆘 Troubleshooting

If you see "❌ DeepL translation failed":
1. Check your API key is correct
2. Ensure you have internet connection
3. Verify your DeepL account is active
4. Check console for specific error messages

The app will automatically fall back to demo translations if there are any issues!
