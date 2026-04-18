import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../app/routes/app_routes.dart';
import '../../../widgets/sunny_loader.dart';

class AuthController extends GetxController {
  // Repository and Storage removed as Firebase handles auth directly

  final loginFormKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  var isLoading = false.obs;
  var currentPhone = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  var verificationId = "".obs;

  // Wrapper for LoginView compatibility
  void sendOtp() {
    if (loginFormKey.currentState?.validate() ?? false) {
      final phone = phoneController.text.trim();
      verifyPhoneNumber(phone);
    }
  }

  void verifyPhoneNumber(String phoneNumber) async {
    // Show Beautiful Loader
    Get.dialog(
      const Center(child: SunnyLoader(size: 80)),
      barrierDismissible: false,
    );
    isLoading.value = true;

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60), // Extended timeout
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-resolution (Android only)
          await _auth.signInWithCredential(credential);

          if (Get.isDialogOpen ?? false) Get.back(); // Close Loader

          Get.offAllNamed(Routes.HOME);
        },
        verificationFailed: (FirebaseAuthException e) {
          isLoading.value = false;
          if (Get.isDialogOpen ?? false) Get.back(); // Close Loader
          Get.snackbar(
            "Sorry",
            "Something went wrong. Please check your phone number.",
          );
        },
        codeSent: (String vid, int? resendToken) {
          verificationId.value = vid;
          isLoading.value = false;
          if (Get.isDialogOpen ?? false) Get.back(); // Close Loader

          Get.snackbar(
            "Code Sent",
            "OTP sent to $phoneNumber",
            backgroundColor: const Color(0xFF1A1A1A),
            colorText: const Color(0xFFFFC105),
          );
        },
        codeAutoRetrievalTimeout: (String vid) {
          verificationId.value = vid;
        },
      );
    } catch (e) {
      isLoading.value = false;
      if (Get.isDialogOpen ?? false) Get.back(); // Close Loader
      Get.snackbar("Sorry", "We couldn't verify your phone. Please try again.");
    }
  }

  Future<void> verifyOtp(String smsCode) async {
    if (verificationId.value.isEmpty) {
      Get.snackbar("Error", "No verification ID found. Try resending code.");
      return;
    }

    isLoading.value = true;

    // Show Beautiful Loader
    Get.dialog(
      const Center(child: SunnyLoader(size: 80)),
      barrierDismissible: false,
    );

    try {
      print(
        "DEBUG: Creating credential with verificationId: ${verificationId.value} and code: $smsCode",
      );
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: smsCode,
      );

      print("DEBUG: Signing in with credential...");
      await _auth.signInWithCredential(credential);
      print(
        "DEBUG: Sign in successful. Current user: ${_auth.currentUser?.phoneNumber}",
      );

      if (Get.isDialogOpen ?? false) Get.back(); // Close Loader

      print("DEBUG: Navigating to CONSENT...");
      Get.offAllNamed(
        Routes.CONSENT,
        arguments: <String, dynamic>{
          'phoneNumber': _auth.currentUser?.phoneNumber ?? "",
        },
      );
      print("DEBUG: Navigation initiated.");

      Get.snackbar("Success", "Verified! Welcome.");
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back(); // Close Loader

      print("DEBUG: Error in verifyOtp catch block: $e");
      // ... existing error handling
      Get.snackbar("Sorry", "Invalid code. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
