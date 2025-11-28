# HealthMate

A comprehensive health tracking Flutter application for monitoring daily activities, sleep patterns, BMI, and health goals.

## Overview

HealthMate is a personal health companion app that helps users track steps, calories, water intake, sleep quality, and manage health goals. Built with Flutter using clean architecture and Provider state management.

## Features

- **User Authentication**: Local signup and login with SQLite storage
- **Health Records**: Track daily steps, calories, and water intake with CRUD operations
- **Dashboard**: Real-time stats, goal progress, and weekly trend charts
- **Sleep Tracker**: Log sleep sessions with quality ratings and view averages
- **BMI Calculator**: Calculate and track BMI with health recommendations
- **Goals Management**: Set and monitor daily step and water intake goals
- **Date Filtering**: Search health records by single date or date range

## Setup Instructions

### Prerequisites

- Flutter SDK 3.0.0 or higher
- Android SDK for Android development
- Dart SDK (bundled with Flutter)

### Installation

1. Clone the repository
2. Navigate to project directory
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

### Build APK

```bash
flutter build apk
```

## Architecture

### Folder Structure

```
lib/
├── core/                    # Core utilities and constants
│   ├── theme.dart          # App theme configuration
│   ├── constants.dart      # Colors, text styles, sizes
│   └── helpers.dart        # Date, validation, BMI helpers
├── services/
│   └── database_helper.dart # SQLite database operations
├── models/                  # Data models
│   ├── user.dart
│   ├── health_record.dart
│   ├── detailed_record.dart
│   ├── sleep_session.dart
│   └── goal.dart
├── providers/               # State management
│   ├── auth_provider.dart
│   ├── health_records_provider.dart
│   ├── sleep_provider.dart
│   ├── goals_provider.dart
│   └── bmi_provider.dart
├── screens/                 # UI screens
│   ├── auth/               # Login and signup
│   ├── dashboard/          # Main dashboard
│   ├── records/            # Health records CRUD
│   ├── sleep/              # Sleep tracker
│   ├── bmi/                # BMI calculator
│   └── goals/              # Goals settings
├── widgets/                 # Reusable components
│   ├── stat_card.dart
│   ├── chart_card.dart
│   ├── custom_button.dart
│   └── custom_text_field.dart
└── main.dart               # App entry point
```

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────┐
│                     Presentation Layer                  │
│  (Screens: Auth, Dashboard, Records, Sleep, BMI, Goals) │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────┐
│                   Business Logic Layer                  │
│      (Providers: Auth, HealthRecords, Sleep, etc.)      │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────┐
│                      Data Layer                         │
│         (DatabaseHelper, Models, Local Storage)         │
└─────────────────────────────────────────────────────────┘
```

### State Management

- Uses **Provider** package for state management
- Separate providers for each feature domain
- Clean separation between UI and business logic

### Database

- **SQLite** via sqflite package
- Tables:
  - `users`: User authentication
  - `health_records`: Daily health metrics
  - `detailed_records`: Granular activity tracking
  - `sleep_sessions`: Sleep tracking data
  - `goals`: User health goals
- Full CRUD operations for all entities
- Dummy data seeded on first run

## Dependencies

- `provider`: State management
- `sqflite`: Local SQLite database
- `path_provider`: File system paths
- `fl_chart`: Charts and graphs
- `intl`: Date formatting
- `shared_preferences`: Simple data persistence
- `crypto`: Password hashing

## Key Screens

1. **Login/Signup**: Secure authentication with validation
2. **Dashboard**: Overview of today's stats, goal progress, weekly charts
3. **Records**: List, add, edit, delete health records with date filtering
4. **Sleep Tracker**: Log sleep sessions with quality ratings
5. **BMI Calculator**: Calculate BMI with category and recommendations
6. **Goals**: Set and update daily health goals

## Database Schema

### health_records
- id (PK), date (TEXT), steps (INT), calories (INT), water (INT)

### sleep_sessions
- id (PK), start_time (INT), end_time (INT), duration_minutes (INT), quality (INT), date (TEXT)

### goals
- id (PK), daily_step_goal (INT), daily_water_goal_ml (INT), target_weight (REAL)

## Testing

Run flutter analyze to check for issues:
```bash
flutter analyze
```

## Screenshots

Screenshots will be added after running the application on a device or emulator.

## Notes

- Password hashing uses SHA-256 (for demo purposes; use proper auth in production)
- Material Design 3 components with custom theme
- Clean, calm UI with soft colors for health-focused design
