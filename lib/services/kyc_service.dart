import 'package:get/get.dart';
import 'api_client.dart';

class KYCService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<dynamic> startVerification() async {
    try {
      final response = await _apiClient.post('/kyc/start', {});
      return response.data;
    } catch (e) {
      print("KYC Start Error: $e");
      rethrow;
    }
  }

  // Dev only
  Future<dynamic> mockSubmit(String kycId, String dob, String outcome) async {
    try {
      final response = await _apiClient.post('/kyc/mock-submit', {
        'kyc_id': kycId,
        'dob': dob,
        'outcome': outcome,
      });
      return response.data;
    } catch (e) {
      print("KYC Mock Submit Error: $e");
      rethrow;
    }
  }
}
