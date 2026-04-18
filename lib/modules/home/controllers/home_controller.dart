import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../services/api_client.dart';

class HomeController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();

  var isLoading = true.obs;
  // Customer Info
  var phoneNumber = "".obs;
  var userName = "Welcome".obs;
  var skinType = "Unknown".obs;
  var walletBalance = 0.obs;
  var sessionsLeft = 0.obs;
  final Rx<dynamic> userProfileImage = Rx<dynamic>(
    "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png",
  );
  var nextSession = Rxn<Map>();
  var upcomingSessions = <Map>[].obs;

  // Bottom Nav
  var currentNavIndex = 0.obs;

  static const int TAB_HOME = 0;
  static const int TAB_BOOK = 1;
  static const int TAB_HISTORY = 2;
  static const int TAB_PROFILE = 3;

  void changeNavIndex(int index) {
    currentNavIndex.value = index;
  }

  Future<void> fetchCustomerData() async {
    try {
      isLoading.value = true;

      String? phoneArg = Get.arguments?['phoneNumber'];

      if (phoneArg == null || phoneArg.isEmpty) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null && user.phoneNumber != null) {
          phoneArg = user.phoneNumber;
        } else {
          phoneArg = "+1234567890";
        }
      }

      phoneNumber.value = phoneArg ?? "";

      // 1. Load from Cache immediately for speed
      await _loadCachedData();

      // 2. Fetch Customer Record
      final res = await _apiClient.get(
        '/customers',
        queryParameters: {'phoneNumber': phoneNumber.value},
      );

      final List data = res.data;
      if (data.isNotEmpty) {
        final customer = data.first;
        _processCustomerData(customer);
        _saveToCache('customer_data', customer);
      }

      // 3. Independent Step: Fetch Bookings
      await _fetchBookings();
    } catch (e) {
      debugPrint("❌ Error fetching home data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchBookings() async {
    try {
      if (phoneNumber.value.isEmpty) return;

      final bookingRes = await _apiClient.get(
        '/bookings/my',
        queryParameters: {'phoneNumber': phoneNumber.value},
      );

      if (bookingRes.data is! List) return;

      List bookings = bookingRes.data;
      final now = DateTime.now();

      final futureBookings = bookings
          .map((b) {
            try {
              final booking = Map<String, dynamic>.from(b);
              final cabin = (booking['cabinId'] is Map)
                  ? booking['cabinId']
                  : (booking['cabin'] ?? {});
              final img = cabin['imageUrl'] ?? cabin['image'] ?? "";
              booking['resolvedImage'] = img.toString().isNotEmpty
                  ? img
                  : "https://images.unsplash.com/photo-1590439471364-192aa70c7c53?q=80&w=600&auto=format&fit=crop";
              return booking;
            } catch (e) {
              return null;
            }
          })
          .whereType<Map<String, dynamic>>()
          .where((b) {
            try {
              String dateStr = b['date']?.toString() ?? "";
              if (dateStr.isEmpty) return false;
              DateTime bookingDate;
              try {
                bookingDate = DateTime.parse(dateStr);
              } catch (e) {
                bookingDate = DateFormat("yyyy-MM-dd").parse(dateStr);
              }
              final isNotPast = bookingDate.isAfter(
                now.subtract(const Duration(days: 1)),
              );
              final status =
                  b['status']?.toString().toLowerCase() ?? "confirmed";
              final isNotCancelled = ![
                "cancelled",
                "failed",
                "rejected",
                "expired",
                "completed",
              ].contains(status);
              return isNotPast && isNotCancelled;
            } catch (e) {
              return false;
            }
          })
          .toList();

      if (futureBookings.isNotEmpty) {
        futureBookings.sort((a, b) => a['date'].compareTo(b['date']));
        upcomingSessions.value = futureBookings;
        nextSession.value = futureBookings.first;
        _saveToCache('upcoming_sessions', futureBookings);
      } else {
        upcomingSessions.clear();
        nextSession.value = null;
        _saveToCache('upcoming_sessions', []);
      }
    } catch (e) {
      debugPrint("⚠️ HomeController: Error in booking fetch: $e");
    }
  }

  void _processCustomerData(Map<String, dynamic> customer) {
    String first = customer['firstName'] ?? "";
    userName.value = first.isNotEmpty ? first : "Sun Lover";
    skinType.value = customer['skinType'] ?? "Unknown";
    if (customer['profileImage'] != null &&
        customer['profileImage'].toString().isNotEmpty) {
      userProfileImage.value = customer['profileImage'];
    }
    walletBalance.value = (customer['walletBalance'] ?? 0);
    sessionsLeft.value = (customer['visits'] ?? 0);
  }

  Future<void> _loadCachedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final cachedCustomer = prefs.getString(
        'customer_data_${phoneNumber.value}',
      );
      if (cachedCustomer != null) {
        _processCustomerData(jsonDecode(cachedCustomer));
      }

      final cachedUpcoming = prefs.getString(
        'upcoming_sessions_${phoneNumber.value}',
      );
      if (cachedUpcoming != null) {
        final List sessions = jsonDecode(cachedUpcoming);
        upcomingSessions.value = sessions.cast<Map>();
        if (upcomingSessions.isNotEmpty)
          nextSession.value = upcomingSessions.first;
      }
    } catch (e) {
      debugPrint("⚠️ HomeController: Error loading cache: $e");
    }
  }

  Future<void> _saveToCache(String key, dynamic data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('${key}_${phoneNumber.value}', jsonEncode(data));
    } catch (e) {
      debugPrint("⚠️ HomeController: Error saving cache: $e");
    }
  }

  // Daily Content
  var dailyTipTitle = "Sunny's Insight".obs;
  var dailyTipContent = "Loading daily wisdom...".obs;

  final List<Map<String, String>> _dailyTips = [
    {
      "title": "Hydration Hero",
      "content":
          "Drinking 500ml of water before tanning can improve your skin's glow by 20%!",
    },
    {
      "title": "UV Balance",
      "content":
          "Today's UV index is moderate. A 10-minute session is optimal for your skin type.",
    },
    {
      "title": "Moisture Magic",
      "content":
          "Dry skin reflects UV light. Moisturize immediately after your shower for best results.",
    },
    {
      "title": "Vitamin D Boost",
      "content":
          "Did you know? Regular controlled UV exposure helps maintain healthy Vitamin D levels.",
    },
    {
      "title": "Exfoliation Station",
      "content":
          "Exfoliate 24 hours before your session to ensure an even, long-lasting tan.",
    },
    {
      "title": "Eye Protection",
      "content":
          "Always wear your protective goggles. Eyelids are too thin to block UV rays!",
    },
    {
      "title": "Post-Tan Care",
      "content":
          "Avoid showering for 2-3 hours after tanning to allow the process to finalize.",
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _loadDailyContent();
    fetchCustomerData();
  }

  void _loadDailyContent() {
    final dayOfYear = int.parse(DateFormat("D").format(DateTime.now()));
    final index = dayOfYear % _dailyTips.length;
    dailyTipTitle.value = _dailyTips[index]['title']!;
    dailyTipContent.value = _dailyTips[index]['content']!;
  }
}
