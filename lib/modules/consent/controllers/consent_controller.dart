import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/api_client.dart';
import '../../../app/routes/app_routes.dart';
import '../../../widgets/sunny_loader.dart';
import '../../home/controllers/home_controller.dart';

class ConsentController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();

  var isLoading = true.obs;
  var termsText = "".obs;
  var privacyText = "".obs;
  var rulesText = "".obs;

  var versions = {}.obs;

  var acceptedTerms = false.obs;
  var acceptedPrivacy = false.obs;
  var acceptedRules = false.obs;
  var acceptedMarketing = false.obs; // Optional

  var phoneNumber = "".obs;

  @override
  void onInit() {
    super.onInit();

    // 1. Retrieve phone number from arguments safely
    try {
      if (Get.arguments != null && Get.arguments is Map) {
        phoneNumber.value = Get.arguments['phoneNumber']?.toString() ?? "";
      }
    } catch (e) {
      debugPrint("❌ Error parsing arguments in ConsentController: $e");
    }

    // 2. Fallback to HomeController if needed
    if (phoneNumber.value.isEmpty && Get.isRegistered<HomeController>()) {
      phoneNumber.value = Get.find<HomeController>().phoneNumber.value;
    }

    if (phoneNumber.value.isNotEmpty) {
      debugPrint("✅ ConsentController: Active Phone: ${phoneNumber.value}");
    }

    // 3. Force required consents to true
    acceptedPrivacy.value = true;
    acceptedTerms.value = true;
    acceptedRules.value = true;

    // 4. Load Data
    termsText.value = "Terms of Service Content...";
    privacyText.value = "Privacy Policy Content...";
    rulesText.value = "Studio Rules Content...";
    _initializeData();
  }

  Future<void> _initializeData() async {
    await fetchConsents();
    if (phoneNumber.value.isNotEmpty) {
      await fetchExistingUserConsents();
    }
  }

  Future<void> fetchExistingUserConsents() async {
    try {
      final res = await _apiClient.get(
        '/customers',
        queryParameters: {'phoneNumber': phoneNumber.value},
      );
      final List data = res.data;
      if (data.isNotEmpty) {
        final customer = data.first;
        final consents = customer['consents'];
        if (consents != null) {
          acceptedPrivacy.value = true; // Always true if required
          acceptedTerms.value = true; // Always true if required
          acceptedRules.value = true; // Always true if required
          acceptedMarketing.value = consents['marketing_opt_in'] ?? false;
        }
      } else {
        // Fallback for new users or missing data
        acceptedPrivacy.value = true;
        acceptedTerms.value = true;
        acceptedRules.value = true;
      }
    } catch (e) {
      debugPrint("⚠️ Error fetching existing consents: $e");
    }
  }

  Future<void> fetchConsents() async {
    try {
      isLoading.value = true;
      final res = await _apiClient.get('/consent/latest');
      final docs = res.data['documents'];
      versions.value = res.data['versions'];

      termsText.value = docs['terms_of_service'] ?? "";
      privacyText.value = docs['privacy_policy'] ?? "";
      rulesText.value = docs['studio_rules'] ?? "";
    } catch (e) {
      // Keep silent or log
    } finally {
      isLoading.value = false;
    }
  }

  bool get canProceed =>
      acceptedTerms.value && acceptedPrivacy.value && acceptedRules.value;

  bool get isManageMode => Get.currentRoute == Routes.MANAGE_CONSENT;

  Future<void> acceptAndContinue() async {
    // Force required fields to true just in case
    acceptedPrivacy.value = true;
    acceptedTerms.value = true;
    acceptedRules.value = true;

    if (!canProceed) return;

    try {
      // Show Beautiful Loader
      Get.dialog(
        const Center(child: SunnyLoader(size: 80)),
        barrierDismissible: false,
      );
      isLoading.value = true;

      final customerData = {
        'phoneNumber': phoneNumber.value,
        'isPhoneVerified': true,
        'consents': {
          'privacy_policy': acceptedPrivacy.value,
          'terms_of_service': acceptedTerms.value,
          'studio_rules': acceptedRules.value,
          'marketing_opt_in': acceptedMarketing.value,
        },
      };

      debugPrint("🚀 Syncing Consents: $customerData");

      // 1. Save Customer Data (Upsert)
      await _apiClient.post('/customers', customerData);

      // 2. Accept Consents (Legacy API)
      try {
        await _apiClient.post('/consent/accept', {
          'accepted_versions': {
            'terms_of_service': versions['terms_of_service'] ?? 'v1',
            'privacy_policy': versions['privacy_policy'] ?? 'v1',
            'studio_rules': versions['studio_rules'] ?? 'v1',
          },
          'marketing_consent': acceptedMarketing.value,
        });
      } catch (_) {}

      // 3. Set Persistence (Only on onboarding)
      if (!isManageMode) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_registered', true);
        await prefs.setString('phoneNumber', phoneNumber.value);
      }

      if (Get.isDialogOpen ?? false) Get.back(); // Close Loader

      if (isManageMode) {
        // Management Success Feedback
        Get.snackbar(
          "Success",
          "Consents updated successfully",
          backgroundColor: const Color(0xFFFFC105).withValues(alpha: 0.1),
          colorText: const Color(0xFFFFC105),
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.back(); // Return to Profile
      } else {
        // Navigate to next onboarding step
        Get.offAllNamed(
          Routes.WELCOME_SUNNY,
          arguments: {'phoneNumber': phoneNumber.value},
        );
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back(); // Close Loader
      Get.snackbar("Sorry", "Something went wrong. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }
}
