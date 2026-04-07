import 'package:flight_app/app/controller/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    final locationController = Get.put(LocationController());
    locationController.fetchLocation();
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 3));

    // TODO: check JWT token here
    //     final token = await TokenStorage.getAccessToken();

    //     if (token == null || token.isEmpty) {
    //       Get.offAllNamed('/login');
    //       return;
    //     }

    // // optional validate token from API
    //     Get.offAllNamed('/home');
    // final bool isLoggedIn = false;

    // if (isLoggedIn) {
    //   Get.offAllNamed('/home');
    // } else {
    //   Get.offAllNamed('/login');
    // }

    Get.offAllNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF003B6F),
      body: Center(
        child: Image.asset(
          'assets/images/splash_logo.png',
          width: 240,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
