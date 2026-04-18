import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class StorageService extends GetxService {
  final _storage = const FlutterSecureStorage();
  FlutterSecureStorage get storage => _storage;

  static const String KEY_STUDIO_ID = 'studio_id';
  static const String KEY_CAMPAIGN_ID = 'campaign_id';
  static const String KEY_AUTH_TOKEN = 'auth_token';
  static const String KEY_REFRESH_TOKEN = 'refresh_token';

  Future<void> saveStudioId(String studioId) async {
    await _storage.write(key: KEY_STUDIO_ID, value: studioId);
  }

  Future<String?> getStudioId() async {
    return await _storage.read(key: KEY_STUDIO_ID);
  }

  Future<void> saveCampaignId(String campaignId) async {
    await _storage.write(key: KEY_CAMPAIGN_ID, value: campaignId);
  }

  Future<String?> getCampaignId() async {
    return await _storage.read(key: KEY_CAMPAIGN_ID);
  }

  Future<void> clearAuth() async {
    await _storage.delete(key: KEY_AUTH_TOKEN);
    await _storage.delete(key: KEY_REFRESH_TOKEN);
  }
}
