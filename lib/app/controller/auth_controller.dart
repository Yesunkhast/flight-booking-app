import 'dart:async';

import 'package:dio/dio.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flight_app/app/config/env.dart';
import 'package:flight_app/app/controller/user_controller.dart';
import 'package:flight_app/app/data/database/database_service.dart';
import 'package:flight_app/app/storage/token_storage.dart';
import 'package:flight_app/models/realModel/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import '../app_link.dart';

class AuthController extends GetxController {
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  final userController = Get.find<UserController>();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final isLoading = false.obs;
  final isCodeSent = false.obs;
  final errorMessage = ''.obs;
  final countdown = 0.obs;

  // int? _resendToken;
  // String? _verificationId;
  Timer? _timer;

  //undsen api tai holbogdoh heseg
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
  void onClose() {
    phoneController.dispose();
    otpController.dispose();
    _timer?.cancel();
    super.onClose();
  }

  //utasnii dugar noramlchlah heseg
  String normalizePhone(String input) {
    final trimmed = input.trim().replaceAll(' ', '');
    if (trimmed.startsWith('+')) return trimmed;
    // Example default for Mongolia. Change if needed.
    return '+976$trimmed';
  }

  Future<void> login({
    required String identifier,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final db = await DatabaseService.instance.database;

      final response = await dio.post(
        '/api/auth/login',
        data: {
          'phone': identifier,
          'password': password,
        },
      );

      print(response.data);

      userController.user.value = User.fromJson(response.data["data"]["user"]);
      // final data = response.data;
      final accessToken = response.data["data"]["token"];
      // final refreshToken = data['refreshToken'];
      print(
          "##########req info##########: ${response.data["data"]["user"]["id"]}");
      print(userController.user.value!.toMap());
      // if (accessToken == null) {
      //   errorMessage.value = 'Login failed. Please try again';
      //   return;
      // }

      print("here1 $accessToken");
      await TokenStorage.saveAccessToken(accessToken);
      print("here2 ${response.data["data"]["user"]["lastname"]}");
      await db.insert(
          'user',
          {
            'id': response.data["data"]["user"]["id"],
            'lastname': response.data["data"]["user"]["lastname"],
            'firstname': response.data["data"]["user"]["firstname"],
            'email': response.data["data"]["user"]["email"],
            'phone': response.data["data"]["user"]["phone"],
            'image': response.data["data"]["user"]["image"],
            'birthday': response.data["data"]["user"]["birthday"],
            'isoperator': response.data["data"]["user"]["isoperator"],
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
      print("here3");
      final result = await db.query('user');

      print("queryd_user: $result");

      print("login success ${userController.user.value!.toMap()}");
      userController.userIsAvailable = true;

      Get.offAllNamed(AppLink.home);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;

      if (statusCode == 400 || statusCode == 401) {
        errorMessage.value = 'Incorrect email or password';
      } else if (statusCode == 404) {
        errorMessage.value = 'No account found with this email or phone';
      } else if (statusCode == 403) {
        errorMessage.value = 'Your account has been disabled';
      } else {
        // fallback: try to get message from server response body
        final serverMessage = e.response?.data?['message']?.toString();
        errorMessage.value = serverMessage ?? 'Login failed. Please try again';
      }
    } catch (e) {
      print(e);
      errorMessage.value = 'Something went wrong. Check your connection';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(
      {required String firstName,
      required String phone,
      required String password,
      required}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print("${firstName} - ${phone} - ${password}");
      final response = await dio.post(
        '/api/auth/register',
        data: {
          'firstname': firstName,
          'phone': phone,
          // 'email': phone,
          'password': password,
        },
      );

      print(response.data);
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;

      if (statusCode == 400) {
        errorMessage.value = 'Please fill in all required fields';
      } else if (statusCode == 409) {
        errorMessage.value =
            'An account with this email or phone already exists';
      } else {
        final serverMessage = e.response?.data?['message']?.toString();
        errorMessage.value =
            serverMessage ?? 'Registration failed. Please try again';
      }
    } catch (e) {
      errorMessage.value = 'Something went wrong. Check your connection';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    userController.user.value = null;
    userController.userIsAvailable = false;
    await TokenStorage.clear();
    await DatabaseService.instance.deletedb();
    Get.offAllNamed(AppLink.home);
  }

  Future<void> refreshToken() async {
    try {
      final savedRefreshToken = await TokenStorage.getRefreshToken();
      if (savedRefreshToken != null) {
        final response = await dio.post('/auth/refresh',
            data: {'refreshToken': savedRefreshToken, 'expiresInMins': 30});
        final data = response.data;
        final accessToken = data['accessToken'];
        final refreshToken = data['refreshToken'];
        await TokenStorage.saveAccessToken(accessToken);
        await TokenStorage.saveRefreshToken(refreshToken);
      }
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      if (statusCode == 401) {
        await logout();
        Get.offAndToNamed(AppLink.login);
      }
    }
  }
}


//###### opt code yvuuldag bolgoh hiih gsenc h tulburiin asuudaltai turlgarsan #######


  // tsag tooluur
  // void _startCountdown([int seconds = 30]) {
  //   _timer?.cancel();
  //   countdown.value = seconds;

  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     if (countdown.value <= 1) {
  //       timer.cancel();
  //       countdown.value = 0;
  //     } else {
  //       countdown.value--;
  //     }
  //   });
  // }

  // // sending OTP
  // Future<void> sendOtp() async {
  //   errorMessage.value = '';

  //   final rawPhone = phoneController.text;
  //   if (rawPhone.trim().isEmpty) {
  //     errorMessage.value = 'Please enter phone number';
  //     return;
  //   }

  //   final phoneNumber = normalizePhone(rawPhone);

  //   isLoading.value = true;

  //   try {
  //     await _auth.verifyPhoneNumber(
  //       phoneNumber: phoneNumber,
  //       forceResendingToken: _resendToken,
  //       verificationCompleted: (PhoneAuthCredential credential) async {
  //         try {
  //           await _auth.signInWithCredential(credential);
  //           errorMessage.value = '';
  //           Get.snackbar('Success', 'Phone number verified automatically');
  //         } on FirebaseAuthException catch (e) {
  //           errorMessage.value = e.message ?? 'Auto verification failed';
  //         }
  //       },
  //       verificationFailed: (FirebaseAuthException e) {
  //         errorMessage.value = e.message ?? 'Verification failed';
  //       },
  //       codeSent: (String verificationId, int? resendToken) {
  //         _verificationId = verificationId;
  //         _resendToken = resendToken;
  //         isCodeSent.value = true;
  //         _startCountdown();
  //         Get.snackbar('Code sent', 'Please check your phone');
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {
  //         _verificationId = verificationId;
  //       },
  //       timeout: const Duration(seconds: 60),
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     errorMessage.value = e.message ?? 'Failed to send code';
  //   } catch (e) {
  //     errorMessage.value = 'Unexpected error: $e';
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // Future<void> verifyOtp() async {
  //   errorMessage.value = '';

  //   final smsCode = otpController.text.trim();

  //   if ((_verificationId ?? '').isEmpty) {
  //     errorMessage.value = 'Verification ID is missing';
  //     return;
  //   }

  //   if (smsCode.length < 6) {
  //     errorMessage.value = 'Please enter the 6-digit code';
  //     return;
  //   }

  //   isLoading.value = true;

  //   try {
  //     final credential = PhoneAuthProvider.credential(
  //       verificationId: _verificationId!,
  //       smsCode: smsCode,
  //     );

  //     final userCredential = await _auth.signInWithCredential(credential);

  //     if (userCredential.user != null) {
  //       Get.snackbar('Success', 'Phone number verified');
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     errorMessage.value = e.message ?? 'Invalid code';
  //   } catch (e) {
  //     errorMessage.value = 'Unexpected error: $e';
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // Future<void> resendOtp() async {
  //   if (countdown.value > 0) return;
  //   await sendOtp();
  // }