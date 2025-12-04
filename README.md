🏡 Indo Stays – Find Your Stay in Indonesia

A modern Flutter-based mobile app that helps tourists easily discover and book accommodations across Indonesia. Indo Stays provides an Airbnb-style experience with property browsing, bookings, favorites, messaging, and user authentication — all powered by Firebase.

📱 Features
🔐 Authentication

Email & password login

User account registration

Secure Firebase authentication

User profile management

🏠 Property Browsing

Explore properties in different Indonesian cities

View detailed property pages

High-quality images and descriptions

Property amenities & host information

❤️ Favorites

Save favorite stays

Quick access to liked properties

📅 Bookings

Make a booking through the app

View your upcoming  bookings

Booking model stored securely in Firestore

💬 Messaging

In-app chat with hosts

Real-time chat using Firestore

🌐 Multi-language Support

Includes translations via app_translations.dart


🎨 Modern UI

Custom widgets

Material You theme

Clean and consistent design

📂 Project Structure

```bash
real_estate_app/
├── lib/
│   ├── main.dart
│   ├── firebase_options.dart
│   │
│   ├── models/
│   │   ├── property_model.dart
│   │   ├── user_model.dart
│   │   ├── booking_model.dart
│   │   └── message_model.dart
│   │
│   ├── controllers/
│   │   ├── auth_controller.dart
│   │   ├── property_controller.dart
│   │   ├── booking_controller.dart
│   │   ├── favorites_controller.dart
│   │   └── message_controller.dart
│   │
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   │
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   │
│   │   ├── home/
│   │   │   └── home_screen.dart
│   │   │
│   │   ├── explore_screen.dart
│   │   │
│   │   ├── property/
│   │   │   ├── property_details_screen.dart
│   │   │
│   │   ├── favorites/
│   │   │   └── favorites_screen.dart
│   │   │
│   │   ├── bookings/
│   │   │   └── bookings_screen.dart
│   │   │
│   │   ├── profile/
│   │   │   └── user_profile_screen.dart
│   │   │
│   │   ├── settings/
│   │   │   └── settings_screen.dart
│   │   │
│   │   └── messaging/
│   │       ├── messages_list_screen.dart
│   │       └── messaging_screen.dart
│   │
│   ├── widgets/
│   │   ├── custom_button.dart
│   │   ├── property_card_widget.dart
│   │   ├── custom_text_filed.dart
│   │
│   ├── services/
│   │   ├── firestore_service.dart
│   │   ├── ai_response_service.dart
│   │
│   ├── translations/
│   │   └── app_translations.dart
│   
│
├── assets/
│   ├── images/
│   │   ├── login_background.jpg
│   
│
├── pubspec.yaml
└── README.md
```


🚀 Getting Started
1. Clone the repo
   git clone https://github.com/hal-imaxabdi/IndoStays-App.git
   cd IndoStays-App

2. Install dependencies
   flutter pub get

3. Add Firebase (Important)

Run the Firebase CLI configuration:

flutterfire configure


This generates/updates firebase_options.dart.

4. Run the app
   flutter run

🛠️ Technologies Used

Flutter (Dart)

Firebase Authentication

Cloud Firestore


📌 Future Improvements

Payment integration (Midtrans / Stripe)

Host dashboard for uploading properties

Offline mode

Push notifications for chat