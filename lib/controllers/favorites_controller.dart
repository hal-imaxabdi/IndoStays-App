import 'package:get/get.dart';
import '../models/property_model.dart';
import '../services/firebase_service.dart';
import '../controllers/auth_controller.dart';
import 'package:flutter/material.dart';

class FavoritesController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  final favoriteProperties = <PropertyModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
  }

  void _loadFavorites() {
    final authController = Get.find<AuthController>();
    final userId = authController.userId;

    if (userId != null) {
      print('Loading favorites for user: $userId');
      favoriteProperties.bindStream(
        _firebaseService.getFavoriteProperties(userId),
      );
    } else {
      print('No user logged in, favorites not loaded');
      favoriteProperties.value = [];
    }
  }

  Future<void> toggleFavorite(PropertyModel property) async {
    try {
      final authController = Get.find<AuthController>();
      final userId = authController.userId;


      if (userId == null) {

        Future.delayed(Duration.zero, () {
          Get.showSnackbar(
            GetSnackBar(
              title: 'Login Required',
              message: 'Please login to save favorites',
              icon: Icon(Icons.login, color: Colors.white),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.orange,
              snackPosition: SnackPosition.BOTTOM,
              margin: EdgeInsets.all(16),
              borderRadius: 12,
            ),
          );
        });


        Future.delayed(Duration(seconds: 2), () {
          Get.toNamed('/login');
        });
        return;
      }

      isLoading.value = true;


      await _firebaseService.toggleFavorite(userId, property.id);


      bool isFavorite = favoriteProperties.any((p) => p.id == property.id);

      Future.delayed(Duration.zero, () {
        Get.showSnackbar(
          GetSnackBar(
            title: isFavorite ? 'Removed from Favorites' : 'Added to Favorites',
            message: isFavorite
                ? '${property.name} removed from your wishlist'
                : '${property.name} added to your wishlist',
            icon: Icon(
              isFavorite ? Icons.favorite_border : Icons.favorite,
              color: Colors.white,
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Color(0xFF10B981),
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.all(16),
            borderRadius: 12,
          ),
        );
      });
    } catch (e) {
      print('Error toggling favorite: $e');
      Future.delayed(Duration.zero, () {
        Get.showSnackbar(
          GetSnackBar(
            title: 'Error',
            message: 'Failed to update favorites',
            icon: Icon(Icons.error, color: Colors.white),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.all(16),
            borderRadius: 12,
          ),
        );
      });
    } finally {
      isLoading.value = false;
    }
  }

  bool isFavorite(String propertyId) {
    return favoriteProperties.any((property) => property.id == propertyId);
  }

  void clearFavorites() {
    favoriteProperties.clear();
  }
}