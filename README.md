# Unganishwa Mobile

Flutter Android and iOS client for the Unganishwa news aggregator. The app is based on the Briefing layout and consumes the Unganishwa REST API.

## 1. Prerequisites

Install:

- Git
- Flutter 3.x
- Dart included with Flutter
- Visual Studio Code
- VS Code Flutter and Dart extensions
- Android Studio and an Android emulator for Android development
- Xcode and CocoaPods for iOS development on macOS

Check Flutter:

```bash
flutter doctor
```

Resolve every required item reported by `flutter doctor` before running the app.

## 2. Clone in VS Code

Open VS Code, press `Ctrl+Shift+P`, choose `Git: Clone`, and enter:

```text
https://github.com/NickDawson/UnganishwaMobile.git
```

Choose a parent folder, then select `Open` when VS Code asks to open the cloned repository.

You can also clone from a terminal:

```bash
git clone https://github.com/NickDawson/UnganishwaMobile.git
cd UnganishwaMobile
code .
```

## 3. Install packages

From the VS Code terminal:

```bash
flutter pub get
```

## 4. Start the Unganishwa Engine

The mobile app needs the Flask engine to be running. Follow the engine README first:

```text
https://github.com/NickDawson/UnganishwaEngine
```

The engine must be reachable at one of these URLs:

- Android Emulator: `http://10.0.2.2:5000`
- iOS Simulator: `http://127.0.0.1:5000`
- Physical phone: `http://YOUR_COMPUTER_LAN_IP:5000`

For a physical phone, connect the phone and computer to the same network and allow port 5000 through the development firewall.

## 5. Run in VS Code

Open `Run and Debug` in VS Code, select a connected Android or iOS device, and start the app with one of these commands.

Android Emulator:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5000
```

iOS Simulator:

```bash
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:5000
```

Physical device:

```bash
flutter run --dart-define=API_BASE_URL=http://YOUR_COMPUTER_LAN_IP:5000
```

The app reads the API URL from `API_BASE_URL`; no API keys are stored in the Flutter source code.

## 6. Features

- News feed by country and topic
- Search through the aggregator API
- Pull to refresh
- Save article links locally in the current session
- Open original articles in the device browser
- Android and iOS compatible REST client

## 7. API endpoints used

- `GET /api/v1/articles?country=tanzania&topic=Top%20Stories&limit=50`
- `GET /api/v1/search?q=business&limit=50`
- `GET /api/v1/countries`
- `GET /api/v1/topics`
- `POST /api/v1/subscribe`
- `POST /api/v1/notifications/subscribe`

## 8. Release builds

Android:

```bash
flutter build apk --release --dart-define=API_BASE_URL=https://your-unganishwa-domain.example
```

iOS, on macOS:

```bash
flutter build ios --release --dart-define=API_BASE_URL=https://your-unganishwa-domain.example
```

The Flutter SDK and native mobile toolchains are required to build the Android APK or iOS application.
