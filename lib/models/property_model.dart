class PropertyModel {
  final String id;
  final String name;
  final String description;
  final String location;
  final String city;
  final double price;
  final int bedrooms;
  final int maxGuests;
  final String type;
  final List<String> images;
  final List<String> amenities;
  final double rating;
  final int reviewCount;
  final String hostId;
  final String hostName;
  final DateTime createdAt;

  PropertyModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.city,
    required this.price,
    required this.bedrooms,
    required this.maxGuests,
    required this.type,
    required this.images,
    required this.amenities,
    required this.rating,
    required this.reviewCount,
    required this.hostId,
    required this.hostName,
    required this.createdAt,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      city: json['city'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      bedrooms: json['bedrooms'] ?? 0,
      maxGuests: json['maxGuests'] ?? 0,
      type: json['type'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      amenities: List<String>.from(json['amenities'] ?? []),
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      hostId: json['hostId'] ?? '',
      hostName: json['hostName'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'location': location,
      'city': city,
      'price': price,
      'bedrooms': bedrooms,
      'type': type,
      'images': images,
      'amenities': amenities,
      'rating': rating,
      'reviewCount': reviewCount,
      'hostId': hostId,
      'hostName': hostName,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}