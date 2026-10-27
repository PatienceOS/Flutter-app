# MindConnect (Flutter)

Flutter port of the MindConnect web app: Home, Mood Journal, Peer Forum, Resources, Newsletter.
Data is stored on-device with `shared_preferences`.

## Run it
```bash
cd mindconnect_flutter
flutter create . --project-name mindconnect   # generates android/ios/web folders
rm -f test/widget_test.dart                    # default test refers to a MyApp that doesn't exist here
flutter pub get
flutter run
```

## Android: allow phone/web links (needed for url_launcher on Android 11+)
In `android/app/src/main/AndroidManifest.xml`, inside `<manifest>` (above `<application>`), add:
```xml
<queries>
  <intent><action android:name="android.intent.action.VIEW"/><data android:scheme="tel"/></intent>
  <intent><action android:name="android.intent.action.VIEW"/><data android:scheme="https"/></intent>
</queries>
```

## Structure
- `lib/models.dart`  – MoodEntry, Story, mood colours, trigger-word check
- `lib/store.dart`   – storage, export/import, delete, streak, insights
- `lib/screens/`    – one file per page

## TODO
- Replace placeholder helpline numbers in `resources_screen.dart` with real local ones
- Forum is local-only; add a backend (Firebase/Supabase) + moderation for a shared forum
- Newsletter has no backend yet
- Daily reminders: add `flutter_local_notifications`
