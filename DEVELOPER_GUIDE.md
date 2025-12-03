# Developer Guide - Pulse Chat Application

## Getting Started

### Prerequisites
Before you begin working with the Pulse Chat codebase, ensure you have:

1. **Flutter SDK** (version 3.5.4 or higher)
   ```bash
   flutter --version
   ```

2. **Dart SDK** (comes with Flutter)

3. **IDE Setup**
   - VS Code with Flutter extension, or
   - Android Studio with Flutter plugin

4. **Firebase Account**
   - Create a project at [Firebase Console](https://console.firebase.google.com)
   - Enable Authentication, Firestore, and Storage

5. **Google Cloud Account** (for Google Sign-In)

### Initial Setup

1. **Clone and Install**
   ```bash
   git clone <repository-url>
   cd Pulse-chatapp
   flutter pub get
   ```

2. **Firebase Configuration**
   - Download `google-services.json` from Firebase Console
   - Place it in `android/app/` directory
   - Update `firebase_options.dart` with your Firebase config

3. **Run the App**
   ```bash
   flutter run
   ```

## Project Architecture

### Directory Structure

```
lib/
├── api/               # Backend integration layer
├── models/            # Data models and entities
├── screens/           # UI screens and pages
├── widgets/           # Reusable UI components
├── helper/            # Utility functions and helpers
├── main.dart          # Application entry point
└── firebase_options.dart  # Firebase configuration
```

### Design Patterns

**1. Repository Pattern**
- All Firebase operations centralized in `APIs` class
- Single source of truth for backend operations
- Easy to mock for testing

**2. Widget Composition**
- Small, reusable widgets
- Separation of UI and business logic
- Props-based communication

**3. Stream-Based Updates**
- Real-time data via Firestore streams
- Reactive UI with StreamBuilder
- Automatic UI updates on data changes

## Core Components Deep Dive

### 1. APIs Class (`lib/api/apis.dart`)

The central hub for all Firebase operations.

**Key Methods:**

```dart
// User Management
static Future<void> createUser()              // Create new user profile
static Future<bool> userExists()              // Check if user exists
static Future<void> getSelfInfo()             // Get current user data
static Future<void> updateUserInfo()          // Update user profile
static Future<bool> addChatUser(String email) // Add contact by email

// Messaging
static Future<void> sendMessage(ChatUser, String, Type)  // Send message
static Stream<QuerySnapshot> getAllMessages(ChatUser)    // Get message stream
static Future<void> updateMessageReadStatus(Message)     // Mark as read
static Future<void> deleteMessage(Message)               // Delete message
static Future<void> updateMessage(Message, String)       // Edit message

// Media
static Future<void> sendChatImage(ChatUser, File)       // Send image
static Future<void> updateProfilePicture(File)          // Update profile pic

// Presence
static Future<void> updateActiveStatus(bool)            // Update online status

// Notifications
static Future<void> sendPushNotification(ChatUser, String)  // Send FCM
```

**Usage Example:**
```dart
// Send a text message
await APIs.sendMessage(
  chatUser,          // Recipient
  "Hello!",          // Message text
  Type.text          // Message type
);

// Listen to messages
StreamBuilder(
  stream: APIs.getAllMessages(chatUser),
  builder: (context, snapshot) {
    // Handle message stream
  }
)
```

### 2. Data Models

**ChatUser Model** (`lib/models/chat_user.dart`)
```dart
class ChatUser {
  String id;          // Firebase Auth UID
  String name;        // Display name
  String email;       // Email address
  String about;       // Status message
  String image;       // Profile picture URL
  String createdAt;   // Registration timestamp
  bool isOnline;      // Current online status
  String lastActive;  // Last seen timestamp
  String pushToken;   // FCM token
  
  // Serialization
  ChatUser.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
```

**Message Model** (`lib/models/message.dart`)
```dart
class Message {
  String toId;        // Recipient ID
  String fromId;      // Sender ID
  String msg;         // Content (text or image URL)
  Type type;          // text or image
  String sent;        // Sent timestamp
  String read;        // Read timestamp (empty if unread)
  
  // Serialization
  Message.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}

enum Type { text, image }
```

### 3. Screen Components

**Splash Screen** (`lib/screens/splash_screen.dart`)
- Shows app logo during initialization
- Checks authentication status
- Routes to Login or Home screen

**Login Screen** (`lib/screens/auth/login_screen.dart`)
- Google Sign-In implementation
- User creation on first login
- Error handling for network issues

**Home Screen** (`lib/screens/home_screen.dart`)
- Lists all chat contacts
- Search functionality
- Add new contacts
- Navigation to chat, profile, and AI screens

**Chat Screen** (`lib/screens/chat_screen.dart`)
- Message list with StreamBuilder
- Text input with emoji picker
- Image sharing (camera/gallery)
- Message actions (edit, delete, copy)

**Profile Screen** (`lib/screens/profile_screen.dart`)
- View/edit profile information
- Update profile picture
- Logout functionality

**AI Screen** (`lib/screens/ai_screen.dart`)
- Google Gemini integration
- Chat interface with AI
- Message history

## Common Development Tasks

### Adding a New Feature

1. **Create Feature Branch**
   ```bash
   git checkout -b feature/feature-name
   ```

2. **Plan the Implementation**
   - Identify required models
   - Design UI components
   - Plan data flow

3. **Implement Backend Logic**
   - Add methods to APIs class if needed
   - Handle Firebase operations
   - Add error handling

4. **Create UI Components**
   - Build widgets in appropriate directory
   - Use existing patterns for consistency
   - Add proper state management

5. **Test Thoroughly**
   - Test with real Firebase data
   - Check edge cases
   - Verify UI responsiveness

### Modifying Message Types

To add a new message type (e.g., video):

1. **Update Message Model**
   ```dart
   enum Type { text, image, video }  // Add video
   ```

2. **Update APIs**
   ```dart
   static Future<void> sendVideo(ChatUser user, File file) {
     // Implementation
   }
   ```

3. **Update Message Card Widget**
   ```dart
   // Add video player widget
   if (message.type == Type.video) {
     return VideoPlayer(url: message.msg);
   }
   ```

### Working with Firestore

**Query Structure:**
```
users/                              # User profiles
  └── {userId}/
      ├── my_users/                # User's contacts
      │   └── {contactId}          # Contact reference
      └── [user_data]              # User profile fields

chats/                             # Conversations
  └── {conversationId}/            # Unique conversation ID
      └── messages/                # Messages collection
          └── {timestamp}/         # Message document
              └── [message_data]   # Message fields
```

**Adding a New Collection:**
```dart
static Future<void> addNewData() async {
  await firestore
    .collection('new_collection')
    .doc('doc_id')
    .set({'key': 'value'});
}
```

### Handling Real-time Updates

**Pattern:**
```dart
StreamBuilder(
  stream: yourStream,
  builder: (context, snapshot) {
    // Handle connection states
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    
    if (snapshot.hasError) {
      return ErrorWidget(snapshot.error);
    }
    
    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return EmptyStateWidget();
    }
    
    // Process data
    final items = snapshot.data!.docs
      .map((doc) => YourModel.fromJson(doc.data()))
      .toList();
      
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => ItemWidget(items[index]),
    );
  }
)
```

## Best Practices

### Code Style

1. **Naming Conventions**
   - Classes: PascalCase (e.g., `ChatUserCard`)
   - Variables: camelCase (e.g., `isOnline`)
   - Constants: UPPER_SNAKE_CASE (e.g., `API_KEY`)
   - Private members: prefix with underscore (e.g., `_list`)

2. **Widget Organization**
   - Extract reusable widgets
   - Keep widget tree shallow
   - Use const constructors when possible

3. **State Management**
   - Use StatefulWidget for local state
   - StreamBuilder for real-time data
   - Minimize rebuilds with proper scoping

### Error Handling

```dart
try {
  await someOperation();
} catch (e) {
  log('Operation failed: $e');
  if (mounted) {
    Dialogs.showSnackbar(context, 'Error message');
  }
}
```

### Async Operations

```dart
Future<void> performAsyncTask() async {
  // Show loading
  Dialogs.showLoading(context);
  
  try {
    await asyncOperation();
    Navigator.pop(context); // Hide loading
    // Success handling
  } catch (e) {
    Navigator.pop(context); // Hide loading
    // Error handling
  }
}
```

### Memory Management

1. **Dispose Controllers**
   ```dart
   @override
   void dispose() {
     _textController.dispose();
     _scrollController.dispose();
     super.dispose();
   }
   ```

2. **Cancel Subscriptions**
   ```dart
   StreamSubscription? _subscription;
   
   @override
   void dispose() {
     _subscription?.cancel();
     super.dispose();
   }
   ```

## Testing

### Unit Tests
```dart
test('Message serialization', () {
  final message = Message(
    fromId: '1',
    toId: '2',
    msg: 'test',
    type: Type.text,
    sent: '12345',
    read: '',
  );
  
  final json = message.toJson();
  final decoded = Message.fromJson(json);
  
  expect(decoded.msg, equals('test'));
});
```

### Widget Tests
```dart
testWidgets('Login button appears', (tester) async {
  await tester.pumpWidget(MyApp());
  await tester.pumpAndSettle();
  
  expect(find.text('Login with Google'), findsOneWidget);
});
```

## Debugging

### Common Issues

**1. Firebase Not Initialized**
```dart
// Ensure this is in main()
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform
);
```

**2. Null Safety Issues**
```dart
// Use null-aware operators
final value = data?.field ?? 'default';

// Check before using
if (user != null) {
  print(user.name);
}
```

**3. Context Issues**
```dart
// Check if widget is mounted
if (mounted) {
  Navigator.pop(context);
}
```

### Debug Tools

1. **Flutter DevTools**
   ```bash
   flutter pub global activate devtools
   flutter pub global run devtools
   ```

2. **Logging**
   ```dart
   import 'dart:developer' show log;
   log('Debug message: $variable');
   ```

3. **Firebase Console**
   - Monitor Firestore queries
   - Check Authentication logs
   - View Storage usage

## Performance Optimization

### Image Optimization
```dart
// Use cached_network_image
CachedNetworkImage(
  imageUrl: url,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

### List Optimization
```dart
ListView.builder(
  itemCount: items.length,
  physics: BouncingScrollPhysics(),  // Smooth scrolling
  itemBuilder: (context, index) {
    return ItemWidget(key: ValueKey(items[index].id));  // Stable keys
  }
)
```

### Query Optimization
```dart
// Limit query results
.limit(50)

// Use indexes for complex queries
.where('field1', isEqualTo: value1)
.where('field2', isEqualTo: value2)
.orderBy('timestamp', descending: true)
```

## Security Considerations

1. **API Keys**
   - Never commit API keys to version control
   - Use environment variables for sensitive data
   - Configure Firebase security rules

2. **User Data**
   - Validate all user inputs
   - Sanitize data before storage
   - Respect user privacy

3. **Firebase Rules**
   ```javascript
   // Example Firestore rules
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId} {
         allow read, write: if request.auth.uid == userId;
       }
     }
   }
   ```

## Deployment

### Android
```bash
# Build release APK
flutter build apk --release

# Build App Bundle (recommended)
flutter build appbundle --release
```

### iOS
```bash
# Build for iOS
flutter build ios --release
```

### Web
```bash
# Build for web
flutter build web
```

## Resources

- [Flutter Documentation](https://docs.flutter.dev)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Material Design Guidelines](https://material.io/design)

## Getting Help

- Check existing issues in the repository
- Review Firebase Console logs
- Use Flutter DevTools for debugging
- Consult Flutter and Firebase documentation

---

**Happy Coding!** 🚀
