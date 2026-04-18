import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/kyc_controller.dart';
import '../../../shared/constants/app_colors.dart';

class KYCCameraView extends GetView<KYCController> {
  const KYCCameraView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan ID Document")),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                    const SizedBox(height: 20),
                    const Text("Camera Preview Here"),
                    const SizedBox(height: 20),
                    // Just a mock button to proceed for now till we wire up real camera logic
                    ElevatedButton(
                      onPressed: () {
                        // Simulate capture
                        Get.snackbar("Capture", "ID Captured Successfully");
                        // controller.nextStep();
                      },
                      child: const Text("CAPTURE PHOTO"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            color: AppColors.surface,
            child: const Text(
              "Place your ID within the frame. Ensure good lighting and no glare.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
