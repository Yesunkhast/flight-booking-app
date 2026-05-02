import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:flight_app/app/data/database/database_service.dart';

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

// app/services/id_generator_service.dart

// class IdGeneratorService {
//   static final IdGeneratorService instance = IdGeneratorService._internal();
//   final Random _random = Random();
//   static const String _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

//   IdGeneratorService._internal();

//   // Generate passenger ID with format: P-XXXXXXXX
//   Future<String> generatePassengerId() async {
//     final existingIds = await _getExistingPassengerIds();
//     final Set<String> usedIds = existingIds.toSet();

//     String newId;
//     int attempts = 0;
//     const maxAttempts = 1000;

//     do {
//       newId = 'P-${_generateCode(length: 8)}';
//       attempts++;

//       if (attempts > maxAttempts) {
//         throw Exception(
//             'Unable to generate unique passenger ID after $maxAttempts attempts');
//       }
//     } while (usedIds.contains(newId));

//     return newId;
//   }

//   // Generate booking reference: BK-XXXXXX
//   Future<String> generateBookingReference() async {
//     final timestamp =
//         DateTime.now().millisecondsSinceEpoch.toString().substring(7);
//     final random = _generateCode(length: 4);
//     return 'BK-$timestamp$random';
//   }

//   // Generate ticket number: TK-YYYYMMDD-XXXX
//   Future<String> generateTicketNumber() async {
//     final date = DateTime.now();
//     final dateStr =
//         '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}';
//     final random = _generateCode(length: 4);
//     return 'TK-$dateStr-$random';
//   }

//   String _generateCode({int length = 6}) {
//     return String.fromCharCodes(List.generate(
//         length, (_) => _chars.codeUnitAt(_random.nextInt(_chars.length))));
//   }

//   Future<List<String>> _getExistingPassengerIds() async {
//     try {
//       final db = await DatabaseService.instance.database;
//       final result = await db.query('passenger', columns: ['id']);
//       return result.map((row) => row['id'] as String).toList();
//     } catch (e) {
//       print('Error fetching existing IDs: $e');
//       return [];
//     }
//   }

//   // Check if ID already exists
//   Future<bool> doesIdExist(String id) async {
//     try {
//       final db = await DatabaseService.instance.database;
//       final result = await db.query(
//         'passenger',
//         where: 'id = ?',
//         whereArgs: [id],
//       );
//       return result.isNotEmpty;
//     } catch (e) {
//       print('Error checking ID existence: $e');
//       return false;
//     }
//   }
// }
