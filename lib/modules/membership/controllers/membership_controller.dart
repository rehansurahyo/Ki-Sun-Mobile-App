import 'package:get/get.dart';

class MembershipController extends GetxController {
  var isLoading = false.obs;
  var isPublishing = false.obs;

  final plans = [
    {
      'id': 'basic',
      'name': 'Bronze Glow',
      'price': 29.99,
      'benefits': [
        '4 sessions/month',
        'Basic beds only',
        '10% lotion discount',
      ],
    },
    {
      'id': 'unlimited',
      'name': 'Gold Radiance',
      'price': 49.99,
      'benefits': [
        'Unlimited sessions',
        'All beds access',
        '20% lotion discount',
        'Priority booking',
      ],
    },
  ];

  void subscribe(String planId, String planName) {
    isPublishing.value = true;
    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      isPublishing.value = false;
      Get.snackbar("Success", "Subscribed to $planName");
    });
  }
}
