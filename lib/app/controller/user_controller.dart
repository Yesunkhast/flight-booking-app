import 'package:dio/dio.dart';
import 'package:flight_app/app/app_link.dart';
import 'package:flight_app/app/config/env.dart';
import 'package:flight_app/app/controller/auth_controller.dart';
import 'package:flight_app/app/data/database/database_service.dart';
import 'package:flight_app/app/storage/token_storage.dart';
import 'package:flight_app/models/user.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class UserController extends GetxController {
  final Rxn<User> user = Rxn<User>();
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
    } else {
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
        'username': user.value!.username,
        'email': user.value!.email,
        'phone': user.value!.phone,
        'image': user.value!.image,
        'dateOfBirth': user.value!.dateOfBirth
      });

      final result = await db.query('user');

      print("queryd_user: $result");
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await Get.find<AuthController>().logout();
        Get.offAllNamed(AppLink.login);
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> insertUser(User user) async {
  //   final db = await DatabaseService.instance.database;
  //   await db.insert('user', {
  //     'id': user.id,
  //     'name': user.username,
  //     'image': user.image,
  //     'idCard': user.idCard,
  //     'dateOfBirth': user.dateOfBirth,
  //     'phone': user.phone,
  //     'email': user.email,
  //   });

  //   // ignore: avoid_print
  //   print("user inserted to sqlite: ${user.toMap()}");
  // }

  Future<void> updateUser(User user) async {}
}
