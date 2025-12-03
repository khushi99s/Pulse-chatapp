# Pulse Chat - Technical Documentation

## Overview
Pulse Chat is a feature-rich, real-time messaging application built with Flutter and Firebase. The application provides seamless communication capabilities with modern features like instant messaging, media sharing, and AI integration.

## Architecture

### Technology Stack
- **Frontend Framework**: Flutter (Dart)
- **Backend Services**: Firebase Suite
  - Firebase Authentication
  - Cloud Firestore (Real-time Database)
  - Firebase Storage
  - Firebase Cloud Messaging (FCM)
- **AI Integration**: Google Gemini API
- **State Management**: Flutter's built-in StatefulWidget with StreamBuilder

### Project Structure
```
lib/
├── api/
│   ├── apis.dart                    # Core API layer for Firebase operations
│   └── notification_access_token.dart  # FCM token management
├── models/
│   ├── chat_user.dart              # User data model
│   └── message.dart                # Message data model
├── screens/
│   ├── auth/
│   │   └── login_screen.dart       # Google authentication
│   ├── splash_screen.dart          # App initialization
│   ├── home_screen.dart            # User list and chat overview
│   ├── chat_screen.dart            # Individual chat interface
│   ├── profile_screen.dart         # User profile management
│   ├── view_profile_screen.dart    # View other user profiles
│   └── ai_screen.dart              # AI chatbot interface
├── widgets/
│   ├── chat_user_card.dart         # User list item widget
│   ├── message_card.dart           # Message bubble widget
│   ├── profile_image.dart          # Reusable profile image widget
│   ├── ai_message_card.dart        # AI chat message widget
│   └── dialogs/
│       └── profile_dialog.dart     # Quick profile view dialog
└── helper/
    ├── dialogs.dart                # Common dialog utilities
    └── my_date_util.dart           # Date/time formatting utilities
```

## Core Features Implementation

### 1. Real-time Messaging
**Implementation**: Using Firebase Firestore's `StreamBuilder` for real-time data synchronization.

**Message Flow**:
1. User sends a message through the chat interface
2. Message is stored in Firestore with timestamp and metadata
3. StreamBuilder automatically updates the UI for both sender and receiver
4. Message read receipts are tracked and updated in real-time

**Database Structure**:
```
chats/
  └── {conversation_id}/
      └── messages/
          └── {message_timestamp}/
              ├── fromId
              ├── toId
              ├── msg
              ├── type (text/image)
              ├── sent
              └── read
```

### 2. User Authentication
**Method**: Google Sign-In via Firebase Authentication

**Flow**:
1. User initiates Google Sign-In from login screen
2. Google authentication credentials are obtained
3. Firebase creates/retrieves user account
4. User profile is stored in Firestore
5. Session is maintained across app restarts

### 3. User Presence System
**Implementation**: Online/offline status tracking

**Mechanism**:
- Status updates on app lifecycle events (resume/pause)
- Last active timestamp stored for offline users
- Real-time status display in chat interface
- Automatic status updates when app state changes

### 4. Push Notifications
**Service**: Firebase Cloud Messaging (FCM)

**Implementation**:
1. Device token is obtained and stored in user profile
2. When a message is sent, FCM notification is triggered
3. Notification includes sender name and message preview
4. Notifications are sent via Firebase HTTP v1 API

### 5. Media Sharing
**Capabilities**:
- Image upload from camera or gallery
- Images stored in Firebase Storage
- Image URLs stored in Firestore messages
- Automatic image compression and optimization
- Image preview with caching (using cached_network_image)

### 6. Message Management
**Features**:
- Edit messages after sending
- Delete messages (removes from both database and storage)
- Message read receipts
- Time-stamped messages with formatted display
- Support for both text and image messages

### 7. AI Chatbot Integration
**Service**: Google Gemini API

**Implementation**:
- Separate dedicated AI chat interface
- Context-aware responses
- Safety settings configured for appropriate content
- Streaming response handling
- Message history maintained in local state

### 8. User Discovery
**Features**:
- Add users by email address
- Search existing contacts by name or email
- Only connected users appear in chat list
- Profile quick view with dialog

## Data Models

### ChatUser Model
```dart
class ChatUser {
  String id;              // Unique user ID from Firebase Auth
  String name;            // Display name
  String email;           // Email address
  String about;           // User status/bio
  String image;           // Profile picture URL
  String createdAt;       // Account creation timestamp
  bool isOnline;          // Current online status
  String lastActive;      // Last seen timestamp
  String pushToken;       // FCM device token
}
```

### Message Model
```dart
class Message {
  String fromId;          // Sender's user ID
  String toId;            // Recipient's user ID
  String msg;             // Message content (text or image URL)
  Type type;              // text or image enum
  String sent;            // Sent timestamp
  String read;            // Read timestamp (empty if unread)
}
```

## Real-time Data Synchronization

The application leverages Firestore's real-time capabilities through strategic use of `StreamBuilder` widgets:

1. **Home Screen**: Listens to user connections and their last messages
2. **Chat Screen**: Listens to all messages in a conversation
3. **User Status**: Listens to online/offline status changes
4. **Message Updates**: Automatically reflects edits and deletions

## Security Considerations

### Firebase Security Rules
- Users can only read/write their own data
- Messages are accessible only to sender and recipient
- Profile pictures stored with user-specific paths
- Push tokens protected and only updated by the owner

### Authentication
- Google Sign-In provides OAuth 2.0 security
- No password storage or management required
- Token-based session management
- Automatic session refresh

## Performance Optimizations

1. **Image Caching**: Uses `cached_network_image` for efficient image loading
2. **Lazy Loading**: Messages loaded on-demand with pagination support
3. **Indexed Queries**: Firestore indexes for fast query performance
4. **Minimized Rebuilds**: Strategic use of StreamBuilder scope
5. **Asset Optimization**: Compressed images and Lottie animations

## Dependencies

### Core Dependencies
- `firebase_core`: Firebase SDK initialization
- `firebase_auth`: User authentication
- `cloud_firestore`: Real-time database
- `firebase_storage`: File storage
- `firebase_messaging`: Push notifications

### UI & UX
- `cached_network_image`: Efficient image loading
- `emoji_picker_flutter`: Emoji support
- `lottie`: Animated graphics
- `image_picker`: Camera/gallery access
- `google_sign_in`: Google authentication UI

### Utilities
- `http`: REST API calls for notifications
- `intl`: Date/time formatting
- `googleapis_auth`: OAuth for FCM
- `gallery_saver_plus`: Save images to device

## Setup Instructions

### Prerequisites
1. Flutter SDK (3.5.4 or higher)
2. Firebase project with Authentication, Firestore, and Storage enabled
3. Google Cloud project for Google Sign-In
4. (Optional) Google Gemini API key for AI features

### Configuration
1. Place `google-services.json` in `android/app/`
2. Configure Firebase options in `firebase_options.dart`
3. Update package name in Android and iOS configurations
4. Add Google Gemini API key in `ai_screen.dart` (line 65)

### Build & Run
```bash
# Install dependencies
flutter pub get

# Run on device/simulator
flutter run

# Build release APK
flutter build apk --release
```

## Future Enhancements

Potential features for future development:
- Group chat functionality
- Voice and video calling
- Message reactions
- File sharing (documents, videos)
- End-to-end encryption
- Message search
- Chat backup and restore
- Multiple language support
- Dark mode theme
- Status/stories feature

## Performance Metrics

- **App Size**: ~20-50 MB depending on build configuration
- **Startup Time**: ~2 seconds (including Firebase initialization)
- **Message Latency**: <500ms for real-time delivery
- **Image Upload**: Variable based on network (optimized for size)

## Testing Recommendations

1. **Authentication Flow**: Test Google Sign-In with multiple accounts
2. **Real-time Sync**: Verify message delivery across multiple devices
3. **Offline Handling**: Test app behavior without internet connection
4. **Push Notifications**: Verify FCM delivery in foreground/background
5. **Media Handling**: Test image upload/download with various sizes
6. **Edge Cases**: Empty states, network errors, permission denials

## Maintenance

### Regular Updates Required
- Firebase SDK updates for security patches
- Flutter framework updates for performance improvements
- Google Sign-In library updates for API compatibility
- FCM token refresh handling
- Storage cleanup for deleted images

### Monitoring
- Firebase Console for usage analytics
- Crashlytics integration recommended for error tracking
- FCM delivery reports for notification success rates

---

**Version**: 1.0.2
**Last Updated**: December 2024
**Maintainer**: Development Team
