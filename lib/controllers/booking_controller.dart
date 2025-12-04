import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/booking_model.dart';
import '../services/firebase_service.dart';
import 'package:flutter/material.dart';

class BookingController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();

  RxList<BookingModel> bookings = <BookingModel>[].obs;
  RxBool isLoading = false.obs;

  Rx<DateTime?> checkInDate = Rx<DateTime?>(null);
  Rx<DateTime?> checkOutDate = Rx<DateTime?>(null);
  RxInt numberOfGuests = 1.obs;
  RxString specialRequests = ''.obs;

  @override
  void onInit() {
    super.onInit();
    print('BookingController initialized');
    loadBookings();
  }

  void loadBookings() {
    try {
      User? user = _firebaseService.getCurrentUser();
      if (user != null) {
        print('Loading bookings for user: ${user.uid}');
        isLoading.value = true;

        _firebaseService.getUserBookings(user.uid).listen(
              (bookingsList) {
            print('Received ${bookingsList.length} bookings');
            bookings.value = bookingsList;
            isLoading.value = false;
          },
          onError: (error) {
            print('Error loading bookings: $error');
            isLoading.value = false;
            bookings.value = [];
          },
        );
      } else {
        print('No user logged in for bookings');
        bookings.value = [];
      }
    } catch (e) {
      print('Exception in loadBookings: $e');
      isLoading.value = false;
      bookings.value = [];
    }
  }

  Future<void> createBooking({
    required String propertyId,
    required String propertyName,
    required String propertyImage,
    required double pricePerNight,
    required int maxGuests,
  }) async {
    if (checkInDate.value == null || checkOutDate.value == null) {
      Get.snackbar(
        'Error',
        'Please select check-in and check-out dates',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (numberOfGuests.value < 1) {
      Get.snackbar(
        'Error',
        'Please select number of guests',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (numberOfGuests.value > maxGuests) {
      Get.snackbar(
        'Error',
        'Maximum $maxGuests guests allowed',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      User? user = _firebaseService.getCurrentUser();

      if (user != null) {
        int nights = checkOutDate.value!.difference(checkInDate.value!).inDays;
        double totalPrice = pricePerNight * nights;

        BookingModel booking = BookingModel(
          id: '',
          propertyId: propertyId,
          propertyName: propertyName,
          propertyImage: propertyImage,
          userId: user.uid,
          checkIn: checkInDate.value!,
          checkOut: checkOutDate.value!,
          guests: numberOfGuests.value,
          totalPrice: totalPrice,
          status: 'pending',
          specialRequests:
          specialRequests.value.isEmpty ? null : specialRequests.value,
          createdAt: DateTime.now(),
        );

        await _firebaseService.createBooking(booking);

        // Reset data
        resetBookingData();
        isLoading.value = false;


        Get.back();


        Future.delayed(Duration(milliseconds: 500), () {

          Get.showSnackbar(
            GetSnackBar(
              title: 'Success',
              message: 'Booking created successfully!',
              icon: Icon(Icons.check_circle, color: Colors.white),
              duration: Duration(seconds: 3),
              backgroundColor: Color(0xFF10B981),
              snackPosition: SnackPosition.BOTTOM,
              margin: EdgeInsets.all(16),
              borderRadius: 12,
            ),
          );
        });
      }
    } catch (e) {
      print('Error creating booking: $e');
      isLoading.value = false;


      Get.showSnackbar(
        GetSnackBar(
          title: 'Error',
          message: 'Failed to create booking: ${e.toString()}',
          icon: Icon(Icons.error, color: Colors.white),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(16),
          borderRadius: 12,
        ),
      );
    }
  }

  Future<void> confirmPayment(String bookingId) async {
    if (bookingId.isEmpty) {
      print('Error: Empty booking ID');
      throw Exception('Invalid booking ID');
    }

    try {
      print('Confirming payment for booking: $bookingId');
      await _firebaseService.confirmBookingPayment(bookingId);
      print('Payment confirmed successfully');
    } catch (e) {
      print('Error confirming payment: $e');
      throw Exception('Failed to confirm payment: $e');
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    if (bookingId.isEmpty) {
      print('Error: Empty booking ID');
      throw Exception('Invalid booking ID');
    }

    try {
      print('Cancelling booking: $bookingId');
      await _firebaseService.cancelBooking(bookingId);
      print('Booking cancelled successfully');
    } catch (e) {
      print('Error cancelling booking: $e');
      throw Exception('Failed to cancel booking: $e');
    }
  }

  void resetBookingData() {
    checkInDate.value = null;
    checkOutDate.value = null;
    numberOfGuests.value = 1;
    specialRequests.value = '';
  }

  double calculateTotal(double pricePerNight) {
    if (checkInDate.value != null && checkOutDate.value != null) {
      int nights = checkOutDate.value!.difference(checkInDate.value!).inDays;
      return pricePerNight * nights;
    }
    return 0;
  }
}