// import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class EmailAuthController extends GetxController {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   final isLoading = false.obs;
//   final isEmailSent = false.obs;
//   final emailVerified = false.obs;
//   final errorMessage = ''.obs;
//   final countdown = 0.obs;

//   Timer? _timer;

//   @override
//   void onClose() {
//     nameController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     _timer?.cancel();
//     super.onClose();
//   }

//   void _startCountdown([int seconds = 30]) {
//     _timer?.cancel();
//     countdown.value = seconds;

//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (countdown.value <= 1) {
//         timer.cancel();
//         countdown.value = 0;
//       } else {
//         countdown.value--;
//       }
//     });
//   }

//   Future<void> register() async {
//     errorMessage.value = '';

//     final name = nameController.text.trim();
//     final email = emailController.text.trim();
//     final password = passwordController.text.trim();

//     if (name.isEmpty) {
//       errorMessage.value = 'Please enter your name';
//       return;
//     }
//     if (email.isEmpty) {
//       errorMessage.value = 'Please enter your email';
//       return;
//     }
//     if (password.length < 6) {
//       errorMessage.value = 'Password must be at least 6 characters';
//       return;
//     }

//     isLoading.value = true;

//     try {
//       final credential = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       await credential.user?.updateDisplayName(name);
//       await credential.user?.sendEmailVerification();

//       isEmailSent.value = true;
//       _startCountdown();

//       Get.snackbar(
//         'Verification email sent',
//         'Please check your email inbox',
//       );
//     } on FirebaseAuthException catch (e) {
//       errorMessage.value = _mapAuthError(e);
//     } catch (_) {
//       errorMessage.value = 'Something went wrong';
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> resendVerificationEmail() async {
//     if (countdown.value > 0) return;

//     isLoading.value = true;
//     errorMessage.value = '';

//     try {
//       final user = _auth.currentUser;
//       if (user == null) {
//         errorMessage.value = 'No user found';
//         return;
//       }

//       await user.sendEmailVerification();
//       _startCountdown();

//       Get.snackbar(
//         'Email sent again',
//         'Please check your email inbox',
//       );
//     } on FirebaseAuthException catch (e) {
//       errorMessage.value = _mapAuthError(e);
//     } catch (_) {
//       errorMessage.value = 'Failed to resend email';
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> checkEmailVerified() async {
//     isLoading.value = true;
//     errorMessage.value = '';

//     try {
//       final user = _auth.currentUser;
//       if (user == null) {
//         errorMessage.value = 'No user found';
//         return;
//       }

//       await user.reload();
//       final refreshedUser = _auth.currentUser;

//       if (refreshedUser != null && refreshedUser.emailVerified) {
//         emailVerified.value = true;

//         Get.snackbar(
//           'Success',
//           'Your email has been verified',
//         );

//         // TODO:
//         // call your backend here and create the user profile
//         // Get.offAllNamed('/');
//       } else {
//         errorMessage.value = 'Email is not verified yet';
//       }
//     } on FirebaseAuthException catch (e) {
//       errorMessage.value = _mapAuthError(e);
//     } catch (_) {
//       errorMessage.value = 'Could not refresh verification status';
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   String _mapAuthError(FirebaseAuthException e) {
//     switch (e.code) {
//       case 'email-already-in-use':
//         return 'This email is already in use';
//       case 'invalid-email':
//         return 'Invalid email address';
//       case 'weak-password':
//         return 'Password is too weak';
//       case 'too-many-requests':
//         return 'Too many requests, please try again later';
//       default:
//         return e.message ?? 'Authentication error';
//     }
//   }
// }
