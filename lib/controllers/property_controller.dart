import 'package:get/get.dart';
import '../models/property_model.dart';
import '../services/firebase_service.dart';

class PropertyController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();

  RxList<PropertyModel> allProperties = <PropertyModel>[].obs;
  RxList<PropertyModel> filteredProperties = <PropertyModel>[].obs;
  RxBool isLoading = false.obs;
  Rx<PropertyModel?> selectedProperty = Rx<PropertyModel?>(null);
  RxString selectedCity = 'All Locations'.obs;
  RxString sortBy = 'Recommended'.obs;

  @override
  void onInit() {
    super.onInit();
    print('PropertyController initialized');
    loadProperties();
  }

  void loadProperties() {
    try {
      print('Loading properties...');
      isLoading.value = true;

      _firebaseService.getProperties().listen(
            (properties) {
          print('Received ${properties.length} properties');
          allProperties.value = properties;
          applyFilters();
          isLoading.value = false;
        },
        onError: (error) {
          print('Error loading properties: $error');
          isLoading.value = false;
          allProperties.value = [];
          filteredProperties.value = [];
        },
      );
    } catch (e) {
      print('Exception in loadProperties: $e');
      isLoading.value = false;
      allProperties.value = [];
      filteredProperties.value = [];
    }
  }

  void applyFilters() {
    List<PropertyModel> filtered = List.from(allProperties);


    if (selectedCity.value != 'All Locations') {
      filtered = filtered
          .where((property) => property.city == selectedCity.value)
          .toList();
    }


    if (sortBy.value == 'Price: Low to High') {
      filtered.sort((a, b) => a.price.compareTo(b.price));
    } else if (sortBy.value == 'Price: High to Low') {
      filtered.sort((a, b) => b.price.compareTo(a.price));
    } else if (sortBy.value == 'Rating') {
      filtered.sort((a, b) => b.rating.compareTo(a.rating));
    }

    filteredProperties.value = filtered;
  }

  void setSelectedCity(String city) {
    selectedCity.value = city;
    applyFilters();
  }

  void setSortBy(String sort) {
    sortBy.value = sort;
    applyFilters();
  }

  void searchProperties(String query) {
    if (query.isEmpty) {
      filteredProperties.value = List.from(allProperties);
    } else {
      filteredProperties.value = allProperties
          .where((property) =>
      property.name.toLowerCase().contains(query.toLowerCase()) ||
          property.location.toLowerCase().contains(query.toLowerCase()) ||
          property.city.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  Future<void> selectProperty(String propertyId) async {
    try {
      PropertyModel? property = await _firebaseService.getPropertyById(propertyId);
      selectedProperty.value = property;
    } catch (e) {
      print('Error selecting property: $e');
      Get.snackbar('Error', 'Failed to load property details');
    }
  }
}