import 'package:flight_app/app/data/database/database_service.dart';
import 'package:flight_app/models/realModel/notification.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;

  final RxInt notCount = 0.obs;

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getNotifByDb();
  }

  Future<void> insertNotification(NotificationModel notification) async {
    try {
      final db = await DatabaseService.instance.database;

      await db.insert(
        'notification',
        notification.toJson(),
      );

      notifications.insert(0, notification);

      notCount.value = notifications.length;
    } catch (e) {
      print("Insert notification error: $e");
    }
  }

  Future<List<NotificationModel>> getNotifByDb() async {
    try {
      isLoading.value = true;

      final db = await DatabaseService.instance.database;

      final result = await db.query(
        'notification',
        orderBy: 'sentAt DESC',
      );

      print("Sent notifications from DB: $result");

      final data = result.map((json) {
        return NotificationModel.fromJson(
          Map<String, dynamic>.from(json),
        );
      }).toList();

      notifications.assignAll(data);

      notCount.value = data.length;
      print("getting notif: ${data}");

      return data;
    } catch (e) {
      print("Get notification error: $e");
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteNotification(int id) async {
    try {
      final db = await DatabaseService.instance.database;

      await db.delete(
        'notification',
        where: 'id = ?',
        whereArgs: [id],
      );

      notifications.removeWhere((e) => e.id == id);

      notCount.value = notifications.length;
    } catch (e) {
      print("Delete notification error: $e");
    }
  }

  Future<void> clearNotifications() async {
    try {
      final db = await DatabaseService.instance.database;

      await db.delete('notification');

      notifications.clear();

      notCount.value = 0;
    } catch (e) {
      print("Clear notifications error: $e");
    }
  }
}
