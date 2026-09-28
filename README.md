# Indo Stays

Indo Stays is a Flutter-based mobile application designed for tourists looking to discover and book accommodation across Indonesia. The app offers a smooth booking experience inspired by leading travel and lodging platforms, with a focus on usability, trust, and convenience.

## Overview

The platform allows users to:
- browse available stays in different Indonesian cities
- view detailed property information
- save favorite listings
- manage reservations from within the app
- communicate with hosts through a built-in messaging flow
- access a consistent and modern mobile interface

## Features

### Authentication
- email and password login
- user registration
- secure Firebase authentication
- profile management

### Property discovery
- explore accommodation listings by location
- view property details, amenities, and host information
- browse high-quality images and descriptions

### Favorites
- save preferred properties for later
- quickly return to shortlisted stays

### Bookings
- create bookings inside the app
- review upcoming trips
- store booking records in Firestore

### Messaging
- message hosts directly from the app
- manage communication using Firebase-backed data storage

### User experience
- responsive, modern interface
- reusable custom widgets
- Material Design-inspired UI
- localization-ready structure for multi-language support

## Tech Stack

- Flutter
- Dart
- Firebase Authentication
- Cloud Firestore
- Android / iOS mobile development

## Project Structure

```bash
lib/
├── main.dart
├── firebase_options.dart
├── models/
│   ├── property_model.dart
│   ├── user_model.dart
│   ├── booking_model.dart
│   └── message_model.dart
├── controllers/
│   ├── auth_controller.dart
│   ├── property_controller.dart
│   ├── booking_controller.dart
│   ├── favorites_controller.dart
│   └── message_controller.dart
├── screens/
│   ├── splash_screen.dart
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── home/
│   │   └── home_screen.dart
│   ├── explore_screen.dart
│   ├── property/
│   │   └── property_details_screen.dart
│   ├── favorites/
│   │   └── favorites_screen.dart
│   ├── bookings/
│   │   └── bookings_screen.dart
│   ├── profile/
│   │   └── user_profile_screen.dart
│   ├── settings/
│   │   └── settings_screen.dart
│   └── messaging/
│       ├── messages_list_screen.dart
│       └── messaging_screen.dart
├── widgets/
│   ├── custom_button.dart
│   ├── property_card_widget.dart
│   └── custom_text_field.dart
├── services/
│   ├── firestore_service.dart
│   └── ai_response_service.dart
├── translations/
│   └── app_translations.dart
└── assets/
    └── images/
```

## Getting Started

### Prerequisites
- Flutter SDK installed
- Dart SDK installed
- Firebase project configured
- Android Studio or Xcode for local testing

### Installation

1. Clone the repository
   ```bash
   git clone https://github.com/hal-imaxabdi/IndoStays-App.git
   cd IndoStays-App
   ```

2. Install dependencies
   ```bash
   flutter pub get
   ```

3. Configure Firebase
   ```bash
   flutterfire configure
   ```

4. Run the app
   ```bash
   flutter run
   ```

## Roadmap

- payment integration
- host dashboard for property management
- offline support
- push notifications
- search and filtering improvements
- user reviews and ratings
