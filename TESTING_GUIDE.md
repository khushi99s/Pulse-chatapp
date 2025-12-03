# Testing Guide - Pulse Chat Application

## Quick Start Testing

### Prerequisites

Before testing this app, ensure you have:

1. **Flutter SDK** (version 3.5.4 or higher)
   ```bash
   flutter --version
   ```

2. **Android Studio or VS Code** with Flutter plugin

3. **A physical device or emulator**
   - Android device/emulator, OR
   - iOS device/simulator (macOS only)

4. **Firebase Project** (for full functionality)
   - Google Sign-In enabled
   - Firestore database
   - Firebase Storage

---

## Setup Instructions

### Step 1: Install Flutter Dependencies

```bash
cd /path/to/Pulse-chatapp
flutter pub get
```

This will download all required packages including:
- Firebase dependencies
- shared_preferences (for theme persistence)
- Google Sign-In
- And 14 other packages

### Step 2: Firebase Configuration

#### Option A: Use Existing Configuration (Quick Test)
The repository already includes Firebase configuration files. You can test immediately with:

```bash
flutter run
```

**Note**: You'll be using the existing Firebase project which may have limited functionality.

#### Option B: Set Up Your Own Firebase (Recommended for Full Testing)

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com)
   - Create a new project
   - Enable Google Analytics (optional)

2. **Enable Required Services**
   - **Authentication**: Enable Google Sign-In
   - **Firestore Database**: Create database in test mode
   - **Storage**: Enable Firebase Storage
   - **Cloud Messaging**: Enable for push notifications

3. **Download Configuration Files**
   
   **For Android:**
   - Download `google-services.json`
   - Place it in `android/app/`
   
   **For iOS:**
   - Download `GoogleService-Info.plist`
   - Place it in `ios/Runner/`

4. **Update Firebase Options**
   - Run `flutterfire configure` OR
   - Manually update `lib/firebase_options.dart`

### Step 3: (Optional) Configure Gemini AI

To test the AI chatbot feature:

1. Get API key from [Google AI Studio](https://aistudio.google.com/app/apikey)
2. Open `lib/screens/ai_screen.dart`
3. Replace line 65: `const apiKey = '';` with your key:
   ```dart
   const apiKey = 'your-api-key-here';
   ```

---

## Running the App

### On Android Device/Emulator

```bash
# List available devices
flutter devices

# Run on connected device
flutter run

# Run in debug mode
flutter run --debug

# Run in release mode (for performance testing)
flutter run --release
```

### On iOS Simulator (macOS only)

```bash
# Open iOS simulator
open -a Simulator

# Run on iOS
flutter run -d ios

# Or specify device
flutter run -d "iPhone 14 Pro"
```

### On Web (Limited functionality)

```bash
flutter run -d chrome
```

**Note**: Some features (push notifications, image picker) may not work on web.

---

## Testing Features

### 1. Test Dark Mode

**Steps:**
1. Launch the app
2. Look for sun/moon icon in the app bar (top right)
3. Tap to toggle between light and dark themes
4. Verify:
   - ✅ Theme changes immediately
   - ✅ All screens adapt to new theme
   - ✅ Message bubbles change colors
   - ✅ Chat background changes (beige → dark blue)
5. Close and reopen app
6. Verify theme persists

### 2. Test Login/Sign Up

**Steps:**
1. On login screen, you'll see TWO buttons:
   - "Sign In with Google" (blue filled)
   - "Sign Up with Google" (blue outlined)
2. Tap either button
3. Complete Google authentication
4. Verify:
   - ✅ Google account picker appears
   - ✅ Successfully logs in
   - ✅ Redirects to home screen
   - ✅ Profile picture appears

### 3. Test Telegram-Style Messaging

**Steps:**
1. Add a contact (tap + icon, enter email)
2. Tap on contact to open chat
3. Send a text message
4. Verify sent message:
   - ✅ Blue background (light mode) or dark blue (dark mode)
   - ✅ Right-aligned
   - ✅ Sharp bottom-right corner
   - ✅ Time shown inside bubble
   - ✅ Single checkmark (✓) when sent
   - ✅ Double checkmark (✓✓) when read

5. Receive a message (use second device/account)
6. Verify received message:
   - ✅ White (light mode) or dark gray (dark mode)
   - ✅ Left-aligned
   - ✅ Sharp top-left corner
   - ✅ Time shown inside bubble

### 4. Test Chat Background

**Light Mode:**
- Should see warm beige background (#E4DDD4)

**Dark Mode:**
- Should see dark blue background (#0E1621)

### 5. Test Real-time Messaging

**Requirements:** Two devices or use web + mobile

**Steps:**
1. Login on Device 1
2. Login on Device 2 (different account)
3. Add each other as contacts
4. Send message from Device 1
5. Verify Device 2 receives instantly
6. Reply from Device 2
7. Verify Device 1 receives instantly

### 6. Test Image Sharing

**Steps:**
1. Open a chat
2. Tap camera icon in input area
3. Choose "Camera" or "Gallery"
4. Select/capture an image
5. Verify:
   - ✅ Image uploads (loading indicator)
   - ✅ Image appears in chat
   - ✅ Thumbnail displays correctly
   - ✅ Tap image for full view

### 7. Test Message Actions

**Edit Message:**
1. Long-press your own message
2. Tap "Edit Message"
3. Modify text and save
4. Verify message updates

**Delete Message:**
1. Long-press your own message
2. Tap "Delete Message"
3. Confirm deletion
4. Verify message removed

**Copy Text:**
1. Long-press any text message
2. Tap "Copy Text"
3. Paste elsewhere to verify

### 8. Test User Profile

**Steps:**
1. Tap profile picture (top left on home screen)
2. Update profile information:
   - Change name
   - Update about/status
   - Change profile picture
3. Save changes
4. Verify updates appear throughout app

### 9. Test Contact Management

**Add Contact:**
1. Tap + icon on home screen
2. Enter contact's email address
3. Verify contact appears in list

**Search Contacts:**
1. Tap search icon
2. Type name or email
3. Verify filtering works

### 10. Test AI Chatbot (if configured)

**Steps:**
1. Tap floating AI button on home screen
2. Type a question
3. Verify AI responds
4. Test multiple conversations

### 11. Test Push Notifications

**Requirements:** Physical device recommended

**Steps:**
1. Login on device
2. Send message from another account
3. Put app in background
4. Verify notification appears
5. Tap notification
6. Verify opens to correct chat

### 12. Test Theme Toggle Across Screens

**Test on each screen:**
- ✅ Login screen
- ✅ Home screen
- ✅ Chat screen
- ✅ Profile screen
- ✅ AI chat screen

---

## Troubleshooting

### Flutter Not Found

```bash
# Add Flutter to PATH
export PATH="$PATH:/path/to/flutter/bin"

# Verify installation
flutter doctor
```

### Build Errors

```bash
# Clean build
flutter clean

# Get dependencies
flutter pub get

# Try again
flutter run
```

### Firebase Authentication Fails

1. Verify `google-services.json` is in `android/app/`
2. Check SHA-1 fingerprint is added in Firebase Console:
   ```bash
   cd android
   ./gradlew signingReport
   ```
3. Add SHA-1 to Firebase Console → Project Settings

### Google Sign-In Not Working

1. Enable Google Sign-In in Firebase Authentication
2. Add OAuth client ID in Google Cloud Console
3. Verify package name matches Firebase project

### Images Not Uploading

1. Enable Firebase Storage in Firebase Console
2. Update Storage rules to allow uploads
3. Check internet connection

### Theme Not Persisting

1. Ensure `shared_preferences` is installed:
   ```bash
   flutter pub get
   ```
2. Clear app data and try again

---

## Performance Testing

### Check App Performance

```bash
# Run with performance overlay
flutter run --profile

# Or add overlay in code:
MaterialApp(
  showPerformanceOverlay: true,
  ...
)
```

### Monitor Memory Usage

```bash
# Use DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

---

## Manual Testing Checklist

Use this checklist to ensure all features work:

### Authentication
- [ ] Google Sign-In works
- [ ] Sign-Up creates new account
- [ ] Profile loads correctly
- [ ] Logout works

### Messaging
- [ ] Send text messages
- [ ] Send images
- [ ] Messages appear in real-time
- [ ] Read receipts work
- [ ] Edit messages
- [ ] Delete messages
- [ ] Copy text

### UI/UX
- [ ] Dark mode toggles correctly
- [ ] Theme persists after restart
- [ ] Telegram-style bubbles display correctly
- [ ] Chat backgrounds show correctly
- [ ] All icons visible in both themes

### Features
- [ ] Add contacts by email
- [ ] Search contacts
- [ ] View contact profiles
- [ ] Update own profile
- [ ] AI chatbot works (if configured)
- [ ] Push notifications work
- [ ] Online/offline status updates

### Cross-Platform
- [ ] Works on Android
- [ ] Works on iOS (if testing)
- [ ] Basic functionality on web

---

## Automated Testing (Optional)

### Run Unit Tests

```bash
flutter test
```

### Run Integration Tests

```bash
flutter test integration_test/
```

**Note**: This project may not have extensive tests yet. Manual testing is recommended.

---

## Getting Help

If you encounter issues:

1. Check `DEVELOPER_GUIDE.md` for detailed setup
2. Review `TECHNICAL_DOCUMENTATION.md` for architecture
3. Check Flutter logs: `flutter logs`
4. Enable verbose logging: `flutter run -v`

---

## Tips for Best Testing Experience

1. **Use Real Devices**: Some features (notifications, camera) work best on physical devices
2. **Test Both Themes**: Switch between light and dark mode frequently
3. **Two Accounts**: Create two Google accounts for full chat testing
4. **Check Different Screen Sizes**: Test on phone and tablet if possible
5. **Test Offline Mode**: Turn off internet to verify error handling
6. **Clear App Data**: Occasionally clear data to test fresh install experience

---

## Quick Test Commands

```bash
# Install and run
flutter pub get && flutter run

# Run on specific device
flutter run -d <device-id>

# Hot reload (while app is running)
Press 'r' in terminal

# Hot restart
Press 'R' in terminal

# Clear and rebuild
flutter clean && flutter pub get && flutter run

# Check for issues
flutter doctor
flutter analyze
```

---

**Happy Testing!** 🚀

If you find any bugs, please report them in the Issues section of the repository.
