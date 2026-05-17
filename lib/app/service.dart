import 'dart:async';

import 'package:flight_app/app/data/database/database_service.dart';
import 'package:flight_app/models/realModel/notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:android_intent_plus/android_intent.dart';

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

class NotificationService {
  final List<NotificationModel> sentNotifications = [];
  static final NotificationService instance = NotificationService._();
  NotificationService._();
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;
  Timer? _scheduleTimer;

  // initialize
  Future<void> initNotif() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();
    // final currentTimeZone = await FlutterTimezone.getLocalTimezone();
    // print("currentTimeZone: ${currentTimeZone.localizedName}");
    tz.setLocalLocation(tz.getLocation('Asia/Ulaanbaatar'));

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await notificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: onNotifTap,
    );
    _isInitialized = true;
  }

  //notificationsDetail setup
  NotificationDetails notificationDetails() {
    const androidDetails = AndroidNotificationDetails(
      'daily_channel_id',
      'Promotions',
      channelDescription: 'Channel for promotional notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    return const NotificationDetails(android: androidDetails, iOS: iosDetails);
  }

  //show notification

// Арга 1 — Timestamp ашиглах
  Future<void> showNotification(
      {required String title,
      required String body,
      String? payload,
      String? type}) async {
    final db = await DatabaseService.instance.database;
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      payload: payload, //route
      notificationDetails: notificationDetails(),
    );

    sentNotifications.add(
      NotificationModel(
        id: id,
        title: title,
        body: body,
        payload: payload,
        sentAt: DateTime.now(),
        type: type,
      ),
    );
    db.insert('notification', {
      'id': id,
      'title': title,
      'body': body,
      'payload': payload,
      'sentAt': DateTime.now().toIso8601String(),
      'type': type,
    });
  }

  // permission асуух
// ─── Permission ────────────────────────────────────
  Future<bool> requestPermission() async {
    // Android 13+
    final android = notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }

    // iOS
    final ios = notificationsPlugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      final granted = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return false;
  }

  //on notif tap
  static void onNotifTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;

    // payload-аас route руу navigate
    Get.toNamed(payload);
  }

  //schedule notification
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
  }) async {
    print("Scheduling notification for $hour:$minute with title: $title");
    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final now = tz.TZDateTime.now(tz.local);

    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    await notificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: notificationDetails(),
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  Future<void> scheduleAfterMinutes({
    required String title,
    required String body,
    required int minutes,
    String? payload,
  }) async {
    _scheduleTimer?.cancel();

    _scheduleTimer = Timer(Duration(minutes: minutes), () {
      showNotification(title: title, body: body);
    });

    print("Timer set: $minutes minutes");
  }

  // cancel all notification

  Future<void> cancelAll() async {
    await notificationsPlugin.cancelAll();
    await DatabaseService.instance.clearNotif();
  }

  Future<void> requestExactAlarmPermission() async {
    final android = notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final granted = await android.requestExactAlarmsPermission();
      if (granted != true) {
        // Settings хуудас руу шилжүүлнэ
        const intent = AndroidIntent(
          action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
        );
        await intent.launch();
      }
    }
  }
}
//   List<> getSentNotifications() {
//     return sentNotifications;
//   }
// }

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
