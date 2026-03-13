import 'package:flight_app/app/service.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class FlightSearchController extends GetxController {
  RxString from = ''.obs;
  RxString to = ''.obs;
  RxString departureDate = ''.obs;
  RxString returnDate = ''.obs;

  RxDouble adults = 0.0.obs;
  RxDouble children = 0.0.obs;
  RxDouble infants = 0.0.obs;

  RxString classType = 'Economy'.obs;

  void setFrom(String city) {
    from.value = city;
  }

  void setTo(String city) {
    to.value = city;
  }

  void setAdults(double count) {
    adults.value = count;
  }

  void setChildren(double count) {
    children.value = count;
  }

  void setInfants(double count) {
    infants.value = count;
  }

  void setClassType(String type) {
    classType.value = type;
  }
}

class UserController extends GetxController {
  RxString name = ''.obs;
  RxString email = ''.obs;
  RxString avatarUrl = ''.obs;
  RxString location = ''.obs;

  void setName(String newName) {
    name.value = newName;
  }

  void setEmail(String newEmail) {
    email.value = newEmail;
  }

  void setAvatarUrl(String newAvatarUrl) {
    avatarUrl.value = newAvatarUrl;
  }

  void setLocation(String newLocation) {
    location.value = newLocation;
  }
}

class PassengerController extends GetxController {
  RxString name = ''.obs;
  RxString parentName = ''.obs;
  RxString passportNumber = ''.obs;
  RxString date = ''.obs;
  RxString passwordExpireDate = ''.obs;
  RxString sex = ''.obs;
}

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
      print('Location error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
