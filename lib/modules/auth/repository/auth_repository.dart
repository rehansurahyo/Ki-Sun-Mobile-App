import 'package:get/get.dart';
import '../../../services/api_client.dart';
import '../../../services/storage_service.dart';

class AuthRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final StorageService _storage = Get.find<StorageService>();

  Future<void> sendOtp(String phone) async {
    await _apiClient.post('/auth/send-otp', {'phone': phone});
  }

  Future<dynamic> verifyOtp(String phone, String code) async {
    final studioId = await _storage.getStudioId(); // Optional: bind to studio
    final response = await _apiClient.post('/auth/verify-otp', {
      'phone': phone,
      'code': code,
      'studio_id': studioId,
      // 'device_uuid': ... (handled by backend or we send explicit uuid if needed)
    });
    return response.data;
  }

  Future<Map<String, dynamic>> getProfile() async {
    final response = await _apiClient.get('/auth/profile');
    return response.data;
  }

  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? avatarUrl,
  }) async {
    final response = await _apiClient.put('/auth/profile', {
      if (name != null) 'name': name,
      if (avatarUrl != null) 'avatar': avatarUrl,
    });
    return response.data;
  }

  Future<void> logout() async {
    // Optional: Call backend logout if needed
    // await _apiClient.post('/auth/logout', {});
    await _storage.clearAuth();
  }
}
