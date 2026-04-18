import 'package:get/get.dart';
import '../../services/storage_service.dart';
import '../../services/deeplink_service.dart';
import '../../services/api_client.dart';
import '../../services/connectivity_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StorageService());
    Get.put(ConnectivityService());
    Get.put(ApiClient());
    Get.put(DeepLinkService());
  }
}
