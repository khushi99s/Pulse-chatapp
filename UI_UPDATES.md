# UI Updates - Dark Mode & Telegram Style

## Changes Summary

This update adds dark mode support and implements a Telegram-inspired design throughout the application.

## 1. Login Screen Updates

### Before:
- Single "Login with Google" button
- Light green background
- Stadium-shaped button
- No theme toggle

### After:
- **Two buttons**: "Sign In with Google" (filled) and "Sign Up with Google" (outlined)
- Modern rounded rectangle buttons
- Theme toggle button in app bar (sun/moon icon)
- Welcome message: "Get Started"
- Description text explaining the purpose
- Telegram-style blue color scheme
- Both buttons use same Google authentication (creating user if new)

## 2. Dark Mode Implementation

### Light Theme (Telegram-inspired):
- **Primary Color**: Blue (#517DA2)
- **App Bar**: Blue background with white text
- **Background**: White
- **Card Color**: White
- **Dividers**: Light gray

### Dark Theme (Telegram-inspired):
- **Primary Color**: Dark blue (#2B5278)
- **App Bar**: Dark gray (#17212B) with white text
- **Background**: Very dark blue-gray (#0E1621)
- **Card Color**: Dark gray (#17212B)
- **Dividers**: Dark gray-blue (#2B3842)

### Theme Switching:
- Toggle button available on:
  - Login screen (top right)
  - Home screen (top right, before search)
  - Persists across app restarts using SharedPreferences
- Icon changes: Sun (light mode) / Moon (dark mode)

## 3. Message Bubble Redesign (Telegram Style)

### Sent Messages (User's messages):
**Light Mode:**
- Background: Light green (#E1FFC7)
- Text: White
- Position: Right-aligned
- Corners: Top-left rounded, top-right rounded, bottom-left rounded, bottom-right sharp (4px)

**Dark Mode:**
- Background: Dark blue (#2B5278)
- Text: White
- Position: Right-aligned
- Same corner styling

**Features:**
- Time displayed inside bubble (bottom-right)
- Read receipts: Double checkmark (blue) when read, single checkmark when sent
- Compact design with minimal margins

### Received Messages (Other user's messages):
**Light Mode:**
- Background: White
- Border: Light gray
- Text: Dark gray/black
- Position: Left-aligned
- Corners: Top-left sharp (4px), others rounded (12px)

**Dark Mode:**
- Background: Dark gray (#17212B)
- Border: Darker gray
- Text: White
- Position: Left-aligned
- Same corner styling

**Features:**
- Time displayed inside bubble (bottom-left)
- No read receipts (as these are received messages)
- Compact design

## 4. Chat Screen Background

### Light Mode:
- Background: Warm beige (#E4DDD4) - Telegram's signature chat background

### Dark Mode:
- Background: Very dark blue (#0E1621) - Dark version of Telegram chat

## 5. Theme Toggle Button

**Location**: App bar (top right)
**Icons**:
- Light mode shows: Moon icon (dark_mode)
- Dark mode shows: Sun icon (light_mode)

**Tooltip**:
- Light mode: "Dark Mode"
- Dark mode: "Light Mode"

## 6. Home Screen Updates

- Theme toggle added before search icon
- All UI elements adapt to current theme
- Cards use theme-appropriate colors
- Text colors adjust based on theme

## Technical Implementation

### New Files:
- `lib/helper/theme_helper.dart` - Theme management and color definitions

### Modified Files:
- `lib/main.dart` - Theme switching logic, StatefulWidget for theme state
- `lib/screens/splash_screen.dart` - Pass theme toggle callback
- `lib/screens/auth/login_screen.dart` - New UI with Sign In/Sign Up buttons
- `lib/screens/home_screen.dart` - Theme toggle button
- `lib/screens/chat_screen.dart` - Telegram-style background
- `lib/widgets/message_card.dart` - Telegram-style message bubbles
- `pubspec.yaml` - Added shared_preferences dependency

### New Dependencies:
- `shared_preferences: ^2.3.3` - For storing theme preference

## Color Palette

### Light Theme:
- Primary: #517DA2 (Telegram blue)
- Secondary: #6EC6E0 (Light blue)
- Sent Message: #E1FFC7 (Light green)
- Received Message: #FFFFFF (White)
- Chat Background: #E4DDD4 (Beige)
- Border: #E0E0E0 (Light gray)

### Dark Theme:
- Primary: #2B5278 (Dark blue)
- Secondary: #6EC6E0 (Light blue)
- Sent Message: #2B5278 (Dark blue)
- Received Message: #17212B (Dark gray)
- Chat Background: #0E1621 (Very dark blue)
- Border: #2B3842 (Dark gray-blue)

## User Experience Improvements

1. **Clear Authentication Options**: Separate buttons make it clear users can either sign in or sign up
2. **Persistent Theme**: Theme choice is remembered across app sessions
3. **Eye Comfort**: Dark mode reduces eye strain in low-light conditions
4. **Modern Design**: Telegram-inspired UI is clean, modern, and familiar
5. **Better Readability**: Message bubbles have improved contrast and spacing
6. **Professional Look**: Rounded corners and proper spacing create a polished appearance

## Usage

### To Toggle Theme:
1. Tap the sun/moon icon in the app bar
2. Theme switches immediately
3. Preference is saved automatically
4. Works on any screen (login, home, chat, etc.)

### Sign In vs Sign Up:
- Both buttons perform Google authentication
- If user exists: Sign in to existing account
- If new user: Create new account automatically
- No separate flows needed - Google handles the complexity

---

**Design Philosophy**: Clean, simple, and familiar - inspired by Telegram's excellent UX design.
