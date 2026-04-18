import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _startAnimation();
  }

  Future<void> _startAnimation() async {
    // Simulate initialization or wait for animations
    await Future.delayed(
      const Duration(seconds: 4),
    ); // 4s to let the "Solaris" vibe sink in

    // Check Persistence
    final prefs = await SharedPreferences.getInstance();
    final isRegistered = prefs.getBool('is_registered') ?? false;
    final phoneNumber = prefs.getString('phoneNumber');

    if (isRegistered) {
      // Pass phoneNumber to Home for fetching data
      Get.offAllNamed(Routes.HOME, arguments: {'phoneNumber': phoneNumber});
    } else {
      Get.offAllNamed(Routes.ONBOARDING);
    }
  }
}
