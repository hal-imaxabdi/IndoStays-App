import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';

class AuthController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();

  final isLoading = false.obs;

  final Rx<User?> firebaseUser = Rx<User?>(null);

  final Rx<Map<String, dynamic>?> userData = Rx<Map<String, dynamic>?>(null);

  @override
  void onInit() {
    super.onInit();

    firebaseUser.bindStream(_firebaseService.authStateChanges);


    ever(firebaseUser, _handleAuthChanged);
  }


  void _handleAuthChanged(User? user) {
    if (user == null) {
      userData.value = null;
    } else {
      loadUserData();
    }
  }


  Future<void> register({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      User? user = await _firebaseService.registerWithEmailPassword(
        email,
        password,
        name,
      );

      if (user != null) {

        await _firebaseService.updateUserProfile(user.uid, {
          'phoneNumber': phoneNumber,
        });


        await loadUserData();


        Future.delayed(const Duration(milliseconds: 500), () {
          Get.snackbar(
            "Success",
            "Account created successfully!",
            duration: const Duration(seconds: 3),
            snackPosition: SnackPosition.BOTTOM,
          );
        });


        Future.delayed(const Duration(milliseconds: 800), () {
          Get.offAllNamed('/home');
        });
      }
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      _showAuthError(e);
    } catch (e) {
      isLoading.value = false;
      print("Registration error: $e");
      _showError("Unexpected error occurred: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;


      User? user = await _firebaseService.signInWithEmailPassword(email, password);

      if (user != null) {

        await _firebaseService.ensureUserDocumentExists(user);


        await loadUserData();


        Future.delayed(const Duration(milliseconds: 500), () {
          Get.snackbar(
            "Success",
            "Welcome back!",
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
          );
        });


        Future.delayed(const Duration(milliseconds: 800), () {
          Get.offAllNamed('/home');
        });
      }
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      _showAuthError(e);
    } catch (e) {
      isLoading.value = false;
      print("Login error: $e");
      _showError("Unexpected error occurred: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> logout() async {
    try {
      await _firebaseService.signOut();


      Future.delayed(const Duration(milliseconds: 300), () {
        Get.snackbar(
          "Success",
          "Logged out successfully",
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
        );
      });


      Future.delayed(const Duration(milliseconds: 500), () {
        Get.offAllNamed('/profile');
      });
    } catch (e) {
      print("Logout error: $e");
      _showError("Logout failed");
    }
  }


  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showSuccess("Password reset link sent to $email");
    } on FirebaseAuthException catch (e) {
      _showAuthError(e);
    }
  }


  Future<void> loadUserData() async {
    final uid = firebaseUser.value?.uid;
    if (uid == null) {
      print("Cannot load user data: uid is null");
      return;
    }

    try {
      print("Loading user data for uid: $uid");
      final model = await _firebaseService.getUserData(uid);

      if (model != null) {
        userData.value = model.toJson();
        print("User data loaded successfully: ${userData.value?['name']}");
      } else {
        print("User data is null for uid: $uid");

        final user = firebaseUser.value;
        if (user != null) {
          await _firebaseService.ensureUserDocumentExists(user);

          final retryModel = await _firebaseService.getUserData(uid);
          if (retryModel != null) {
            userData.value = retryModel.toJson();
            print("User data loaded on retry: ${userData.value?['name']}");
          }
        }
      }
    } catch (e) {
      print("Error loading user data: $e");
      _showError("Failed to load profile data. Please try logging in again.");
    }
  }


  void _showAuthError(FirebaseAuthException e) {
    String msg;

    switch (e.code) {
      case 'email-already-in-use':
        msg = "This email is already registered. Please login instead.";
        break;
      case 'invalid-email':
        msg = "Invalid email address.";
        break;
      case 'weak-password':
        msg = "Password is too weak. Use at least 6 characters.";
        break;
      case 'wrong-password':
        msg = "Incorrect password.";
        break;
      case 'user-not-found':
        msg = "No account found with this email.";
        break;
      case 'user-disabled':
        msg = "This account has been disabled.";
        break;
      case 'too-many-requests':
        msg = "Too many attempts. Please try again later.";
        break;
      case 'operation-not-allowed':
        msg = "Operation not allowed. Please contact support.";
        break;
      default:
        msg = e.message ?? "Authentication error occurred";
    }

    _showError(msg);
  }

  void _showError(String message) {
    // Wait for context to be available
    Future.delayed(const Duration(milliseconds: 500), () {
      Get.snackbar(
        "Error",
        message,
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error.withOpacity(0.1),
        colorText: Get.theme.colorScheme.error,
      );
    });
  }

  void _showSuccess(String message) {
    // Wait for context to be available
    Future.delayed(const Duration(milliseconds: 500), () {
      Get.snackbar(
        "Success",
        message,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor.withOpacity(0.1),
        colorText: Get.theme.primaryColor,
      );
    });
  }


  String? get userId => firebaseUser.value?.uid;
}