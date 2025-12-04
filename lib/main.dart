import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/firebase_service.dart';
import 'controllers/auth_controller.dart';
import 'controllers/property_controller.dart';
import 'controllers/booking_controller.dart';
import 'controllers/favorites_controller.dart';
import 'controllers/message_controller.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/property/property_details_screen.dart';
import 'screens/favorites/favorites_screen.dart';
import 'screens/bookings/bookings_screen.dart';
import 'screens/profile/user_profile_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/messaging/messages_list_screen.dart';
import 'screens/messaging/messaging_screen.dart';
import 'translations/app_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  Get.put(FirebaseService());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'IndoStays',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        primaryColor: Color(0xFF9C27B0),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.purple,
          accentColor: Color(0xFF00BCD4),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Color(0xFF9C27B0),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF9C27B0),
          foregroundColor: Colors.white,
        ),
      ),
      translations: AppTranslations(),
      locale: Get.deviceLocale,
      fallbackLocale: Locale('en', 'US'),
      popGesture: true,
      defaultTransition: Transition.cupertino,
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController(), permanent: true);
      }),
      initialRoute: '/splash',
      getPages: [
        GetPage(
          name: '/splash',
          page: () => SplashScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/login',
          page: () => LoginScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/register',
          page: () => RegisterScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/home',
          page: () => HomeScreen(),
          transition: Transition.fadeIn,
          binding: BindingsBuilder(() {
            _initializeAppControllers();
          }),
        ),
        GetPage(
          name: '/explore',
          page: () => ExploreScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/property-detail',
          page: () => PropertyDetailsScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/wishlist',
          page: () => FavoritesScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/bookings',
          page: () => BookingsScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/profile',
          page: () => UserProfileScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/settings',
          page: () => SettingsScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/messages',
          page: () => MessagesListScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/chat',
          page: () => MessagingScreen(),
          transition: Transition.rightToLeft,
        ),
      ],
    );
  }

  void _initializeAppControllers() {
    if (!Get.isRegistered<PropertyController>()) {
      Get.put(PropertyController(), permanent: true);
    }
    if (!Get.isRegistered<BookingController>()) {
      Get.put(BookingController(), permanent: true);
    }
    if (!Get.isRegistered<FavoritesController>()) {
      Get.put(FavoritesController(), permanent: true);
    }
    if (!Get.isRegistered<MessageController>()) {
      Get.put(MessageController(), permanent: true);
    }
  }
}