import 'package:cloud_firestore/cloud_firestore.dart';
class BookingModel {
  final String id;
  final String propertyId;
  final String propertyName;
  final String propertyImage;
  final String userId;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final double totalPrice;
  final String status;
  final String? specialRequests;
  final DateTime createdAt;

  BookingModel({
    required this.id,
    required this.propertyId,
    required this.propertyName,
    required this.propertyImage,
    required this.userId,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.totalPrice,
    required this.status,
    this.specialRequests,
    required this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      propertyId: json['propertyId'] ?? '',
      propertyName: json['propertyName'] ?? '',
      propertyImage: json['propertyImage'] ?? '',
      userId: json['userId'] ?? '',
      checkIn: _parseDateTime(json['checkIn']),
      checkOut: _parseDateTime(json['checkOut']),
      guests: json['guests'] ?? 1,
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      specialRequests: json['specialRequests'],
      createdAt: _parseDateTime(json['createdAt']),
    );
  }


  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.parse(value);
    return DateTime.now();
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propertyId': propertyId,
      'propertyName': propertyName,
      'propertyImage': propertyImage,
      'userId': userId,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut.toIso8601String(),
      'guests': guests,
      'totalPrice': totalPrice,
      'status': status,
      'specialRequests': specialRequests,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  int get nights => checkOut.difference(checkIn).inDays;
}