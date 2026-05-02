import 'package:dio/dio.dart';
import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/app/config/env.dart';
import 'package:flight_app/app/controller/auth_controller.dart';
import 'package:flight_app/app/data/database/database_service.dart';
import 'package:flight_app/app/storage/token_storage.dart';
import 'package:flight_app/models/realModel/user.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class UserController extends GetxController {
  final Rxn<User> user = Rxn<User>();
  late bool userIsAvailable = false;
  final isLoading = false.obs;

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: Env.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  @override
  void onInit() {
    super.onInit();
    getUserFromDb();
  }

  Future<void> getUserFromDb() async {
    final db = await DatabaseService.instance.database;

    // Query the first user row
    final result = await db.query('user');

    if (result.isNotEmpty) {
      // Map the first row into your User model
      user.value = User.fromJson(result.first);
      print("Loaded user from DB: ${user.value!.toMap()}");
      userIsAvailable = true;
    } else {
      userIsAvailable = false;
      print("No user found in local DB");
    }
  }

  Future<void> getUserToApi() async {
    final db = await DatabaseService.instance.database;
    try {
      isLoading.value = true;
      final response = await dio.get('/user/me',
          options: Options(headers: {
            'Authorization': 'Bearer ${await TokenStorage.getAccessToken()}'
          }));
      final data = response.data;
      user.value = User.fromJson(data);
      print("getted user: ${user.value!.toMap()}");
      db.insert('user', {
        'id': user.value!.id,
        'lastName': user.value!.lastName,
        'firstName': user.value!.firstName,
        'email': user.value!.email,
        'phone': user.value!.phone,
        'image': user.value!.image,
        'birthday': user.value!.birthday
      });

      final result = await db.query('user');

      print("queryd_user: $result");
      userIsAvailable = true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        userIsAvailable = false;
        await Get.find<AuthController>().logout();
        Get.offAllNamed(AppLink.login);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editUser({
    required String id,
    String? token,
    String? lastName,
    String? firstName,
    String? image,
    String? idCard,
    String? birthday,
    String? phone,
    String? email,
  }) async {
    try {
      isLoading.value = true;

      await DatabaseService.instance.editUser(
        id: id,
        token: token,
        lastName: lastName,
        firstName: firstName,
        image: image,
        idCard: idCard,
        birthday: birthday,
        phone: phone,
        email: email,
      );

      await getUserFromDb();
    } catch (e) {
      print('Error editing user: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Delete ──────────────────────────────────────────────────────────────────
  Future<void> deleteUser() async {
    try {
      isLoading.value = true;
      await DatabaseService.instance.deleteUser();
      user.value = null; // ✅ clear from state
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────
  bool get isLoggedIn => user.value != null;
  String get fullName =>
      '${user.value?.lastName ?? ''} ${user.value?.firstName ?? ''}'.trim();
  String get displayPhone => user.value?.phone ?? '';
  String get displayEmail => user.value?.email ?? '';

  // Future<void> insertUser(User user) async {
  //   final db = await DatabaseService.instance.database;
  //   await db.insert('user', {
  //     'id': user.id,
  //     'name': user.username,
  //     'image': user.image,
  //     'passportId': user.passportId,
  //     'dateOfBirth': user.dateOfBirth,
  //     'phone': user.phone,
  //     'email': user.email,
  //   });

  //   // ignore: avoid_print
  //   print("user inserted to sqlite: ${user.toMap()}");
  // }
}
