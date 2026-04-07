import 'package:flight_app/app/service.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationController extends GetxController {
  final LocationService _locationService = LocationService();

  RxString city = ''.obs;
  RxString country = ''.obs;
  RxBool isLoading = false.obs;
  RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLocation();
  }

  Future<void> fetchLocation() async {
    try {
      isLoading.value = true;
      error.value = '';

      final Position? result = await _locationService.getCurrentLocation();

      if (result == null) {
        city.value = 'Location unavailable';
        country.value = '';
        return;
      }

      final placemarks = await placemarkFromCoordinates(
        result.latitude,
        result.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        city.value = place.locality ??
            place.subAdministrativeArea ??
            place.administrativeArea ??
            'Unknown city';
        country.value = place.country ?? 'Unknown country';
      } else {
        city.value = 'Unknown city';
        country.value = 'Unknown country';
      }
    } catch (e) {
      error.value = e.toString();
      city.value = 'Location error';
      country.value = '';
      // ignore: avoid_print
      print('Location error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
