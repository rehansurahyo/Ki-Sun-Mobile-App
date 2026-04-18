import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart'
    hide Response, FormData, MultipartFile; // Hide conflicting types
import 'storage_service.dart';
import 'connectivity_service.dart';

class ApiClient extends GetxService {
  late Dio _dio;
  final StorageService _storage = Get.find<StorageService>();

  // Replace with your local IP or backend URL
  // Android Emulator: 10.0.2.2
  // Physical Device: Use your PC's LAN IP (e.g., 192.168.1.5)
  // RUN `ipconfig` in terminal to find it!
  static const String BASE_URL = 'https://ki-sun-app-backend.vercel.app/api';

  @override
  void onInit() {
    super.onInit();
    _dio = Dio(
      BaseOptions(
        baseUrl: BASE_URL,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.storage.read(
            key: StorageService.KEY_AUTH_TOKEN,
          );
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          String errorMessage = _handleError(e);

          // Show user-friendly snackbar for non-GET requests or critical failures
          if (Get.context != null &&
              Get.find<ConnectivityService>().isOnline.value) {
            Get.snackbar(
              "Connection Issue",
              errorMessage,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red.withValues(alpha: 0.8),
              colorText: Colors.white,
              margin: const EdgeInsets.all(15),
              duration: const Duration(seconds: 4),
            );
          }

          print("API Error: [${e.response?.statusCode}] $errorMessage");
          return handler.next(e);
        },
      ),
    );
  }

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return "Connection timed out. Please check your internet.";
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) return "Session expired. Please login again.";
        if (statusCode == 403)
          return "You don't have permission for this action.";
        if (statusCode == 404) return "Requested resource not found.";
        if (statusCode == 500) return "Server error. Please try again later.";
        return "Unexpected error: ${error.response?.data?['message'] ?? 'Error $statusCode'}";
      case DioExceptionType.cancel:
        return "Request was cancelled.";
      case DioExceptionType.connectionError:
        return "No internet connection. Please turn on WiFi or Data.";
      default:
        return "Something went wrong. Please try again.";
    }
  }

  // Unified Post method
  Future<Response> post(String path, dynamic data) async {
    return await _dio.post(path, data: data);
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> put(String path, dynamic data) async {
    return await _dio.put(path, data: data);
  }

  Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }
}
