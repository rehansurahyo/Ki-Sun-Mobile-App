import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../widgets/sunny_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../auth/repository/auth_repository.dart';
import '../../../app/routes/app_routes.dart';
import '../../home/controllers/home_controller.dart';
import '../../../services/api_client.dart';

class ProfileController extends GetxController {
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  // Observables
  final userName = "Sunny Member".obs;
  final userPhone = "Loading...".obs;
  // Start with a valid network image, but allow it to be updated
  final Rx<dynamic> userAvatar = Rx<dynamic>(
    "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png",
  );

  final marketingEmailsEnabled = true.obs;

  final ImagePicker _picker = ImagePicker();

  final ApiClient _apiClient = Get.find<ApiClient>();
  // userPhone already defined above as observable

  @override
  void onInit() {
    super.onInit();

    // 1. Try to get phone from arguments
    if (Get.arguments != null && Get.arguments is Map) {
      userPhone.value = Get.arguments['phoneNumber'] ?? "";
    }

    // 2. Fallback to HomeController if empty (and pre-fill data for better UX)
    if (Get.isRegistered<HomeController>()) {
      final homeCtrl = Get.find<HomeController>();

      // If phone is still empty, grab from Home
      if (userPhone.value.isEmpty) {
        userPhone.value = homeCtrl.phoneNumber.value;
      }

      // Pre-fill UI data from Home while fresh data fetches
      if (homeCtrl.userName.value != "Welcome" &&
          homeCtrl.userName.value.isNotEmpty) {
        userName.value = homeCtrl.userName.value;
      }

      // Pre-fill Avatar if valid
      final homeAvatar = homeCtrl.userProfileImage.value;
      if (homeAvatar != null && homeAvatar.toString().contains('http')) {
        userAvatar.value = homeAvatar;
      }
    }

    if (userPhone.value.isEmpty) {
      debugPrint(
        "⚠️ ProfileController: No phone number found in args or HomeController!",
      );
    } else {
      debugPrint(
        "✅ ProfileController initialized with phone: ${userPhone.value}",
      );
      fetchProfile();
    }
  }

  Future<void> fetchProfile() async {
    try {
      if (userPhone.value.isEmpty) {
        debugPrint("❌ fetchProfile aborted: userPhone is empty");
        return;
      }

      final res = await _apiClient.get(
        '/customers',
        queryParameters: {'phoneNumber': userPhone.value},
      );

      final List data = res.data;
      if (data.isNotEmpty) {
        final profile = data.first;
        debugPrint("📥 Profile Data Fetched: $profile"); // Log entire object

        userName.value = profile['firstName'] ?? "Sunny Member";

        // Update avatar if we have URL
        if (profile['profileImage'] != null &&
            profile['profileImage'].toString().isNotEmpty) {
          debugPrint("🖼️ Found profile image: ${profile['profileImage']}");
          userAvatar.value = profile['profileImage'];

          // Sync with Home if registered
          if (Get.isRegistered<HomeController>()) {
            Get.find<HomeController>().userProfileImage.value =
                profile['profileImage'];
          }
        } else {
          debugPrint("⚠️ No profile image found in backend response.");
        }
      } else {
        debugPrint(
          "⚠️ No customer profile found for phone: ${userPhone.value}",
        );
      }
    } catch (e) {
      debugPrint("❌ Error loading profile: $e");
      // Fail silently or show generic toast if critical
    }
  }

  Future<void> updateName() async {
    final TextEditingController nameController = TextEditingController(
      text: userName.value,
    );
    final GlobalKey<FormState> nameFormKey = GlobalKey<FormState>();

    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF221E10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFF3BA12), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: nameFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.edit, color: Color(0xFFF3BA12), size: 24),
                    const SizedBox(width: 10),
                    Text(
                      "Edit Name",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Input Field
                TextFormField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Enter your name",
                    hintStyle: TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Colors.white24,
                      size: 20,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFF3BA12)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.redAccent),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.redAccent,
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Name cannot be empty";
                    }
                    if (value.trim().length < 2) {
                      return "Name is too short";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: const Color(0xFFF3BA12).withOpacity(0.5),
                            ),
                          ),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Color(0xFFF3BA12),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (nameFormKey.currentState?.validate() ?? false) {
                            Get.back(); // Close Input Dialog
                            userName.value = nameController.text.trim();
                            if (Get.isRegistered<HomeController>()) {
                              Get.find<HomeController>().userName.value =
                                  nameController.text.trim();
                            }
                            try {
                              await _apiClient.post('/customers', {
                                'phoneNumber': userPhone.value,
                                'firstName': nameController.text.trim(),
                                'isPhoneVerified': true,
                              });
                              Get.snackbar(
                                "Success",
                                "Profile updated successfully",
                                backgroundColor: Colors.green.withOpacity(0.1),
                                colorText: Colors.green,
                              );
                            } catch (e) {
                              Get.snackbar(
                                "Sync Error",
                                "Saved locally but sync failed.",
                                backgroundColor: Colors.orange.withOpacity(0.1),
                                colorText: Colors.orange,
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF3BA12),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickAndUploadImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      if (image != null) {
        // 1. Show local preview immediately (Optimistic UI)
        userAvatar.value = File(image.path);

        // Show Beautiful Loader
        Get.dialog(
          const Center(child: SunnyLoader(size: 80)),
          barrierDismissible: false,
        );

        // 2. Upload to Firebase Storage
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          debugPrint(
            "⚠️ WARNING: No Firebase User found directly (Anonymous upload might be blocked by rules)",
          );
        }

        final File file = File(image.path);
        debugPrint("📂 File path: ${file.path}");

        // Sanitize phone number (remove + and spaces to avoid URL issues)
        final sanitizedPhone = userPhone.value.replaceAll(
          RegExp(r'[^0-9]'),
          '',
        );
        final String fileName =
            "${sanitizedPhone}_${DateTime.now().millisecondsSinceEpoch}.jpg";
        final Reference storageRef = FirebaseStorage.instance.ref().child(
          "profile_pics/$fileName",
        );

        debugPrint("🚀 Starting upload to: profile_pics/$fileName");

        final UploadTask uploadTask = storageRef.putFile(file);

        uploadTask.snapshotEvents.listen(
          (TaskSnapshot snapshot) {
            double progress = (snapshot.bytesTransferred / snapshot.totalBytes);
            debugPrint(
              "⏳ Upload Progress: ${(progress * 100).toStringAsFixed(1)}%",
            );
          },
          onError: (e) {
            debugPrint("❌ Upload Stream Error: $e");
          },
        );

        final TaskSnapshot snapshot = await uploadTask;
        debugPrint("✅ Upload Completed. Fetching URL...");

        final String downloadUrl = await snapshot.ref.getDownloadURL();
        debugPrint("🔗 Image URL: $downloadUrl");

        // 3. Update Backend with new URL
        try {
          await _apiClient.post('/customers', {
            'phoneNumber': userPhone.value,
            'profileImage': downloadUrl,
            'isPhoneVerified': true, // Alignment with ConsentController
          });
        } catch (apiError) {
          debugPrint(
            "⚠️ Backend update failed (Image uploaded to Firebase though): $apiError",
          );
        }

        // 4. Update local state with network URL (so it persists across sessions)
        userAvatar.value = downloadUrl;

        // 5. Sync Home Controller
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().userProfileImage.value = downloadUrl;
        }

        // Close Loader
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }

        Get.snackbar(
          "Success",
          "Profile picture updated!",
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green,
        );
      }
    } catch (e) {
      // Close Loader on Error
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      debugPrint("❌ Upload Error details: $e");
      Get.snackbar(
        "Upload Failed",
        "Could not upload image. Please check your connection.",
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    }
  }

  void toggleMarketingEmails(bool value) {
    marketingEmailsEnabled.value = value;
    // TODO: Sync preference with Backend
  }

  Future<void> logout() async {
    try {
      // 1. Clear Secure Storage (Tokens)
      await _authRepository.logout();

      // 2. Clear Shared Preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // 3. Navigate to Splash
      Get.offAllNamed(Routes.SPLASH);
    } catch (e) {
      Get.snackbar("Error", "Logout failed");
    }
  }
}
