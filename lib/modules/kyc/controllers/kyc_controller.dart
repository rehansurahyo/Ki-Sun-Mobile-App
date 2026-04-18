import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../app/routes/app_routes.dart';

class KYCController extends GetxController {
  // final KYCService _kycService = Get.find<KYCService>(); // Unused for now

  var isLoading = false.obs;

  // Captured Images
  var frontIdPath = "".obs;
  var backIdPath = "".obs;
  var selfiePath = "".obs;

  void startProcess() {
    // Start the flow
    Get.toNamed(Routes.KYC_SCAN_FRONT);
  }

  void onFrontIdCaptured(String path) {
    frontIdPath.value = path;
    debugPrint("✅ Front ID Captured: $path");
    // Navigate to Back Scan
    Get.toNamed(Routes.KYC_SCAN_BACK);
  }

  void onBackIdCaptured(String path) {
    backIdPath.value = path;
    debugPrint("✅ Back ID Captured: $path");
    // Navigate to Selfie or Result (Mocking directly to Result for now if Selfie view not ready/requested)
    // Assuming next step is Result or Selfie. Let's send to Result for now or check routes.
    // Based on previous flow usually: Intro -> Front -> Back -> Selfie (if liveness) -> Result
    // Let's assume Selfie is next but user didn't mention it. Let's go to Result expecting Success.
    submitKyc();
  }

  Future<void> submitKyc() async {
    try {
      isLoading.value = true;
      // Mock Submission
      await Future.delayed(const Duration(seconds: 2));

      // Navigate to Result
      Get.offNamed(Routes.KYC_COMPLETION);
    } catch (e) {
      Get.snackbar("Error", "KYC Submission Failed");
    } finally {
      isLoading.value = false;
    }
  }
}
