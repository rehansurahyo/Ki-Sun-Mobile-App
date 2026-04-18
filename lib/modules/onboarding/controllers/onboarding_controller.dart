import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../services/storage_service.dart';

class OnboardingController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  var currentStudioId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _checkSavedStudio();
  }

  Future<void> _checkSavedStudio() async {
    final studioId = await _storage.getStudioId();
    if (studioId != null) {
      currentStudioId.value = studioId;
      print("Onboarding with Studio ID: $studioId");
    }
  }

  void getStarted() {
    // Navigate to Age Verification Intro (18+ Warning)
    Get.toNamed(Routes.KYC_INTRO);
  }
}
