# 📱 Mobile Push Notifications Setup Guide

## 🚀 What You Get

✅ **In-App Notifications** (like WhatsApp notification tab)
- Connection requests appear in notifications.dart
- Message notifications appear in notifications.dart  
- Real-time updates via Socket.IO
- Unread count badges

✅ **Mobile Push Notifications** (like WhatsApp mobile notifications)
- Notifications when app is closed/background
- Sound, vibration, and badge updates
- Tap to open specific chat/screen
- Works on Android & iOS

## 📋 Setup Instructions

### 1. Backend Dependencies
Add to `package.json`:
```json
{
  "dependencies": {
    "firebase-admin": "^11.10.1"
  }
}
```

Run: `npm install firebase-admin`

### 2. Flutter Dependencies  
Add to `pubspec.yaml`:
```yaml
dependencies:
  firebase_core: ^2.15.0
  firebase_messaging: ^14.6.5
  flutter_local_notifications: ^15.1.0+1
```

Run: `flutter pub get`

### 3. Firebase Project Setup

1. **Create Firebase Project:**
   - Go to https://console.firebase.google.com
   - Create new project: "SkillSocket"

2. **Add Android App:**
   - Package name: `com.example.barter_system` (or your package name)
   - Download `google-services.json`
   - Place in `android/app/google-services.json`

3. **Add iOS App:**
   - Bundle ID: `com.example.barterSystem` (or your bundle ID)
   - Download `GoogleService-Info.plist`
   - Place in `ios/Runner/GoogleService-Info.plist`

4. **Get Service Account Key:**
   - Go to Project Settings → Service Accounts
   - Generate new private key
   - Save as `lib/backend/config/firebase-service-account.json`

### 4. Android Configuration

Add to `android/app/build.gradle`:
```gradle
apply plugin: 'com.google.gms.google-services'

dependencies {
    implementation 'com.google.firebase:firebase-messaging:23.2.1'
}
```

Add to `android/build.gradle`:
```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.3.15'
}
```

### 5. iOS Configuration

Add to `ios/Runner/Info.plist`:
```xml
<key>FirebaseMessagingAutoInitEnabled</key>
<false/>
```

### 6. Initialize in Flutter

Update `lib/main.dart`:
```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:barter_system/services/firebase_messaging_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize push notifications
  await FirebaseMessagingService.initialize();
  
  runApp(MyApp());
}
```

## 🧪 How to Test

### Test In-App Notifications:
1. Send a message between users
2. Send a connection request
3. Check notifications.dart tab
4. See real-time updates

### Test Push Notifications:
1. Close the app completely
2. Send a message from another user
3. You'll get a mobile notification
4. Tap notification → opens to chat

### Test API:
```bash
# Send test notification
curl -X POST https://skillsocket-backend.onrender.com/api/notifications/test \
  -H "Authorization: Bearer YOUR_TOKEN"
```

## 📱 Notification Types

| Type | In-App | Push | Action |
|------|--------|------|--------|
| `message` | ✅ | ✅ | Opens chat |
| `connection_request` | ✅ | ✅ | Opens notifications |
| `connection_accepted` | ✅ | ✅ | Opens chat |
| `skill_match` | ✅ | ✅ | Opens profile |
| `system` | ✅ | ✅ | Opens app |

## 🔧 Troubleshooting

**No push notifications?**
- Check FCM token is saved: Look for "FCM token saved to server" in logs
- Check Firebase project setup
- Verify service account key is correct

**Notifications not appearing in app?**
- Check Socket.IO connection
- Verify notification API endpoints work
- Check notification.dart is using NotificationService

**Android notifications not working?**
- Verify google-services.json is in correct location
- Check notification channel is created
- Ensure app has notification permissions

## 🎯 Production Checklist

- [ ] Firebase project created
- [ ] Service account key added
- [ ] google-services.json added (Android)
- [ ] GoogleService-Info.plist added (iOS)
- [ ] Dependencies installed
- [ ] Firebase initialized in main.dart
- [ ] Test notifications working
- [ ] Push notifications working when app closed

## 🚀 Your App Now Has:

✅ **WhatsApp-style notifications**
✅ **Real-time in-app updates**  
✅ **Mobile push notifications**
✅ **Notification history**
✅ **Unread count badges**
✅ **Tap-to-navigate**

Just like a production messaging app! 🎉
