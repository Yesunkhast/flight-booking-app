import 'package:dio/dio.dart';
// import 'package:flight_app/app/app_link.dart';
// import 'package:flight_app/app/controller/auth_controller.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/src/extension_instance.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:flight_app/app/config/env.dart';
import 'package:flight_app/app/data/database/database_service.dart';
import 'package:flight_app/app/storage/token_storage.dart';
// import 'package:flight_app/app/storage/token_storage.dart';
import 'package:flight_app/models/realModel/user.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class UserController extends GetxController {
  final Rxn<User> user = Rxn<User>();
  late bool userIsAvailable = false;
  final isLoading = false.obs;

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: Env.baseUrl,
      connectTimeout: const Duration(seconds: 90),
      receiveTimeout: const Duration(seconds: 90),
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
      print("No user found in local DB $result");
    }
  }

  Future<void> editUser({
    required String id,
    String? lastName,
    String? firstName,
    String? image,
    String? idCard,
    String? birthday,
    String? phone,
    String? email,
    String? password,
  }) async {
    try {
      isLoading.value = true;

      final token = await TokenStorage.getAccessToken();
      print("Token: $token");
      dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await dio.patch(
        '/api/auth/profile/',
        data: {
          if (lastName != null && lastName.isNotEmpty) 'lastname': lastName,
          if (firstName != null && firstName.isNotEmpty) 'firstname': firstName,
          if (image != null && image.isNotEmpty) 'image': image,
          if (idCard != null && idCard.isNotEmpty) 'idcard': idCard,
          if (birthday != null && birthday.isNotEmpty) 'birthday': birthday,
          if (phone != null && phone.isNotEmpty) 'phone': phone,
          if (email != null && email.isNotEmpty) 'email': email,
        },
      );

      // Update local DB
      print(
          "editUser called with id: $id, lastName: $lastName, firstName: $firstName, image: $image, idCard: $idCard, birthday: $birthday, phone: $phone, email: $email");

      final data = response.data;
      print("API response for user: ${data["data"]}");
      user.value = User.fromJson(data['data']);
      print("here1 ${user.value!.lastName}");

      await DatabaseService.instance.editUser(
        id: id,
        lastName: user.value!.lastName,
        firstName: user.value!.firstName,
        image: user.value!.image,
        idCard: user.value!.idCard,
        birthday: user.value!.birthday,
        phone: user.value!.phone,
        email: user.value!.email,
      );

      await getUserFromDb();
    } on DioException catch (e) {
      print('Error editing user: ${e.response?.data}');
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
}
