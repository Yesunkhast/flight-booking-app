import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  Future<Position?> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // ignore: avoid_print
      print("Location service is disabled");
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      // ignore: avoid_print
      print("Location permission denied");
      return null;
    }

    if (permission == LocationPermission.deniedForever) {
      // ignore: avoid_print
      print("Location permission denied forever");
      return null;
    }

    return Geolocator.getCurrentPosition(
      // ignore: deprecated_member_use
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
    return this;
  }

  Future<void> changeLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyLanguage, languageCode);
    locale.value = languageCode;
    Get.updateLocale(Locale(languageCode));
  }

  List<String> get supportedLocales => ['en', 'mn'];
  List<String> get supportedLocalesName => ['English', 'Монгол'];
}
