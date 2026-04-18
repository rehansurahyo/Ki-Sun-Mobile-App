import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'storage_service.dart';
import '../app/routes/app_routes.dart';

class DeepLinkService extends GetxService {
  late AppLinks _appLinks;
  final StorageService _storage = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    _appLinks = AppLinks();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    // Check initial link
    // final appLink = await _appLinks.getInitialLink();
    // if (appLink != null) {
    //   _handleLink(appLink);
    // }

    // Listen for changes
    _appLinks.uriLinkStream.listen(
      (Uri? uri) {
        if (uri != null) {
          _handleLink(uri);
        }
      },
      onError: (err) {
        print("Deep Link Error: $err");
      },
    );
  }

  void _handleLink(Uri uri) async {
    print("Received Deep Link: $uri");

    // Format: https://app.ki-sun.com/dl?studio_id=XYZ&campaign_id=ABC
    final studioId = uri.queryParameters['studio_id'];
    final campaignId = uri.queryParameters['campaign_id'];

    if (studioId != null) {
      await _storage.saveStudioId(studioId);
      print("Studio ID saved: $studioId");
    }

    if (campaignId != null) {
      await _storage.saveCampaignId(campaignId);
    }

    // Pass parameters to onboarding if we are there
    if (Get.currentRoute == Routes.ONBOARDING) {
      // We can reload or let the controller pick it up
      // For now, let's just toast or log
      Get.snackbar("Studio Detected", "Welcome to Studio $studioId");
    }
  }
}
