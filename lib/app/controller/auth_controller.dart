import 'dart:async';

import 'package:dio/dio.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flight_app/app/config/env.dart';
import 'package:flight_app/app/controller/user_controller.dart';
import 'package:flight_app/app/data/database/database_service.dart';
import 'package:flight_app/app/storage/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_link.dart';

class AuthController extends GetxController {
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  final UserController userController = Get.find();
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

      final response = await dio.post(
        '/auth/login',
        data: {
          'username': identifier,
          'password': password,
          'expiresInMins': 30,
        },
      );

      final data = response.data;
      final accessToken = data['accessToken'];
      final refreshToken = data['refreshToken'];

      if (accessToken == null) {
        errorMessage.value = 'Login failed. Please try again';
        return;
      }

      await TokenStorage.saveAccessToken(accessToken);
      if (refreshToken != null) {
        await TokenStorage.saveRefreshToken(refreshToken);
      }
      // print(accessToken);
      // print(refreshToken);
      print("login success");

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
      errorMessage.value = 'Something went wrong. Check your connection';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(
      {required String userName,
      required String phone,
      required String password,
      required}) async {
    // print("${userName} - ${phone} - ${password}");
  }

  Future<void> logout() async {
    userController.user.value = null;
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