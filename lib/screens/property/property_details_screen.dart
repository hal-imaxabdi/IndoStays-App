import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/property_controller.dart';
import '../../controllers/favorites_controller.dart';
import '../../controllers/booking_controller.dart';
import '../../controllers/message_controller.dart';

class PropertyDetailsScreen extends StatelessWidget {
  final PropertyController _propertyController = Get.find<PropertyController>();
  final FavoritesController _favoritesController = Get.find<FavoritesController>();
  final BookingController _bookingController = Get.find<BookingController>();
  final MessageController _messageController = Get.find<MessageController>();

  @override
  Widget build(BuildContext context) {
    final String propertyId = Get.arguments;
    _propertyController.selectProperty(propertyId);

    return Scaffold(
      body: Obx(() {
        final property = _propertyController.selectedProperty.value;

        if (property == null) {
          return Center(child: CircularProgressIndicator());
        }

        return CustomScrollView(
          slivers: [
            // Image Gallery
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              backgroundColor: Colors.white,
              leading: Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Get.back(),
                ),
              ),
              actions: [
                Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Obx(() => IconButton(
                    icon: Icon(
                      _favoritesController.isFavorite(property.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: _favoritesController.isFavorite(property.id)
                          ? Colors.red
                          : Colors.black,
                    ),
                    onPressed: () {
                      _favoritesController.toggleFavorite(property);
                    },
                  )),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: PageView.builder(
                  itemCount: property.images.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      property.images[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            // Property Details
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Price
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                property.name,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined, size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    property.location,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '\$${property.price}',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF10B981),
                              ),
                            ),
                            Text(
                              'per night',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Rating and Type
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFF7ED),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.star, size: 16, color: Color(0xFFF59E0B)),
                              SizedBox(width: 4),
                              Text(
                                '${property.rating}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF000000),
                                ),
                              ),
                              Text(
                                ' (${property.reviewCount} reviews)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            property.type,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    // Property Info
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            Icons.people_outline,
                            '${property.maxGuests} Guests',
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoCard(
                            Icons.bed_outlined,
                            '${property.bedrooms} Bedrooms',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Divider(),
                    SizedBox(height: 16),
                    // Host Info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Color(0xFF10B981),
                          child: Text(
                            property.hostName[0].toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hosted by ${property.hostName}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Joined ${property.createdAt.year}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            _messageController.createConversation(
                              hostId: property.hostId,
                              propertyId: property.id,
                              propertyName: property.name,
                            );
                            Get.toNamed('/messages');
                          },
                          icon: Icon(Icons.message_outlined, size: 18),
                          label: Text('Message'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Divider(),
                    SizedBox(height: 16),
                    // Description
                    Text(
                      'About this place',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      property.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 24),
                    // Amenities
                    Text(
                      'Amenities',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: property.amenities.map((amenity) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                size: 16,
                                color: Color(0xFF10B981),
                              ),
                              SizedBox(width: 4),
                              Text(amenity),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(),
              blurRadius: 10,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Obx(() {
          final property = _propertyController.selectedProperty.value;
          if (property == null) return SizedBox();

          return SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                _showBookingBottomSheet(context, property.id, property.name,
                    property.images.first, property.price, property.maxGuests);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF10B981),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Book Now',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Color(0xFF10B981)),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _showBookingBottomSheet(BuildContext context, String propertyId,
      String propertyName, String propertyImage, double price, int maxGuests) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Book Your Stay',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            Text('Check-in Date', style: TextStyle(fontWeight: FontWeight.w500)),
            SizedBox(height: 8),
            Obx(() => InkWell(
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (date != null) {
                  _bookingController.checkInDate.value = date;
                }
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 12),
                    Text(
                      _bookingController.checkInDate.value == null
                          ? 'Select date'
                          : '${_bookingController.checkInDate.value!.day}/${_bookingController.checkInDate.value!.month}/${_bookingController.checkInDate.value!.year}',
                    ),
                  ],
                ),
              ),
            )),
            SizedBox(height: 16),
            Text('Check-out Date', style: TextStyle(fontWeight: FontWeight.w500)),
            SizedBox(height: 8),
            Obx(() => InkWell(
              onTap: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: _bookingController.checkInDate.value ??
                      DateTime.now().add(Duration(days: 1)),
                  firstDate: _bookingController.checkInDate.value ??
                      DateTime.now().add(Duration(days: 1)),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (date != null) {
                  _bookingController.checkOutDate.value = date;
                }
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 12),
                    Text(
                      _bookingController.checkOutDate.value == null
                          ? 'Select date'
                          : '${_bookingController.checkOutDate.value!.day}/${_bookingController.checkOutDate.value!.month}/${_bookingController.checkOutDate.value!.year}',
                    ),
                  ],
                ),
              ),
            )),
            SizedBox(height: 24),
            Obx(() {
              double total = _bookingController.calculateTotal(price);
              return total > 0
                  ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total:', style: TextStyle(fontSize: 18)),
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                ],
              )
                  : SizedBox();
            }),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  _bookingController.createBooking(
                    propertyId: propertyId,
                    propertyName: propertyName,
                    propertyImage: propertyImage,
                    pricePerNight: price,
                    maxGuests: maxGuests,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF10B981),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Confirm Booking',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}