import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  Future<Position?> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location service is disabled");
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      print("Location permission denied");
      return null;
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permission denied forever");
      return null;
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}

class LocalizationService extends GetxService {
  static const String keyLanguage = 'language';
  final RxString locale = 'en'.obs;

  Future<LocalizationService> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString(keyLanguage) ?? 'en';
    locale.value = savedLocale;
    Get.updateLocale(Locale(savedLocale));
    return this;
  }

  void changeLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyLanguage, languageCode);
    locale.value = languageCode;
    Get.updateLocale(Locale(languageCode));
  }

  List<String> get supportedLocales => ['en', 'es', 'fr', 'de'];
  List<String> get supportedLocalesName =>
      ['English', 'Español', 'Français', 'Deutsch'];
}
