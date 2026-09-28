# Indo Stays

> Discover and book accommodations across Indonesia with ease.

![Indo Stays Login](assets/images/login_background.jpg)

Indo Stays is a mobile accommodation booking platform built with Flutter, enabling tourists to explore properties, make bookings, and connect with hosts throughout Indonesia.

**Tech Stack:** Flutter (Dart) • Firebase • Firestore

---

## Features

### 🔐 Authentication
- Email & password login
- User registration & account management
- Secure Firebase authentication
- User profile customization

### 🏠 Property Discovery
- Browse properties across Indonesian cities
- Detailed property pages with images
- Amenities & host information
- Quick search & filtering

### ❤️ Favorites
- Save favorite properties
- Quick-access bookmark list

### 📅 Bookings
- Create new reservations
- View upcoming bookings
- Secure Firestore storage

### 💬 Messaging
- Real-time in-app chat with hosts
- Firestore-backed messaging system

### 🌐 Multi-Language Support
- Localization ready via `app_translations.dart`

### 🎨 Modern UI
- Material You design system
- Custom reusable widgets
- Clean, consistent interface

---

## Project Structure

```
lib/
├── main.dart
├── firebase_options.dart
│
├── models/
│   ├── property_model.dart
│   ├── user_model.dart
│   ├── booking_model.dart
│   └── message_model.dart
│
├── controllers/
│   ├── auth_controller.dart
│   ├── property_controller.dart
│   ├── booking_controller.dart
│   ├── favorites_controller.dart
│   └── message_controller.dart
│
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
│
├── widgets/
│   ├── custom_button.dart
│   ├── property_card_widget.dart
│   └── custom_text_field.dart
│
├── services/
│   ├── firestore_service.dart
│   └── ai_response_service.dart
│
└── translations/
    └── app_translations.dart
```

---

## Getting Started

### Prerequisites
- Flutter SDK (latest stable)
- Dart SDK
- Firebase account
- Android Studio / Xcode (for emulator)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/hal-imaxabdi/IndoStays-App.git
   cd IndoStays-App
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   ```bash
   flutterfire configure
   ```
   This generates/updates `firebase_options.dart` with your Firebase credentials.

4. **Run the app**
   ```bash
   flutter run
   ```

---

## Tech Stack

| Component | Technology |
|-----------|-----------|
| Frontend | Flutter (Dart) |
| Backend | Firebase |
| Database | Cloud Firestore |
| Authentication | Firebase Auth |
| Real-time Messaging | Firestore |

---

## Roadmap

- [ ] Payment integration (Midtrans / Stripe)
- [ ] Host dashboard for property uploads
- [ ] Offline mode support
- [ ] Push notifications for chat
- [ ] Advanced filtering & search
- [ ] User reviews & ratings

---

## Contributing

Contributions are welcome! Please feel free to submit pull requests.

---

## License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## Contact

For questions or feedback, reach out via GitHub Issues.
