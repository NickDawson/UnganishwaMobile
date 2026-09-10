# Unganishwa Mobile

Flutter Android and iOS client for the Unganishwa news aggregator. The UI is based on the cloned Briefing layout and consumes the Unganishwa REST API.

## API configuration

The app reads the API base URL from `--dart-define`:

```bash
flutter run --dart-define=API_BASE_URL=https://your-unganishwa-domain.example
```

For Android Emulator development against Flask on the host machine, the default is `http://10.0.2.2:5000`. For iOS Simulator, use:

```bash
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:5000
```

Available endpoints:

- `GET /api/v1/articles?country=tanzania&topic=Top%20Stories&limit=50`
- `GET /api/v1/search?q=business&limit=50`
- `GET /api/v1/countries`
- `GET /api/v1/topics`
- `POST /api/v1/subscribe`
- `POST /api/v1/notifications/subscribe`

## Run

Install Flutter 3.x, then from this directory:

```bash
flutter pub get
flutter run
```

For release builds:

```bash
flutter build apk --release --dart-define=API_BASE_URL=https://your-unganishwa-domain.example
flutter build ios --release --dart-define=API_BASE_URL=https://your-unganishwa-domain.example
```
# Briefing

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

An attempt to clone part of Google News app design using Flutter

> Hard-coded data

## Screenshots
<div background-color="grey">
    <p align="center">
      <img align="left" src="screenshots/ui_main_list.jpg" width="250">
    &nbsp;
      <img src="screenshots/ui_bottomsheet.jpg" width="250">
    &nbsp;
      <img align="right" src="screenshots/ui_list.jpg" width="250">
    </p>
</div>
