import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../auth/repository/auth_repository.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepository());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
