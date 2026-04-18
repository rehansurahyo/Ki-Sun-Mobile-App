import 'package:get/get.dart';
import '../controllers/kyc_controller.dart';
import '../../../services/kyc_service.dart';

class KYCBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KYCService>(() => KYCService());
    Get.lazyPut<KYCController>(() => KYCController());
  }
}
