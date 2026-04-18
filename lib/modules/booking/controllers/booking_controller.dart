import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../services/api_client.dart';
import '../../../app/routes/app_routes.dart';
import '../../home/controllers/home_controller.dart';

class BookingController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();

  var isLoading = false.obs;
  var bookingHistory = [].obs;
  var phoneNumber = "".obs;

  // Tab Management for My Sessions
  var selectedTab = "Upcoming".obs; // "Upcoming" or "History"

  void selectTab(String tab) {
    selectedTab.value = tab;
  }

  // --- State for Premium UI ---

  // 1. Cabin Selection
  var selectedCabinIndex = 0.obs;
  var cabins = <Map<String, dynamic>>[].obs;

  // 2. Duration Selection
  var selectedDuration = 0.obs;
  var availableDurations = <int>[].obs;

  // 3. Date Selection
  var selectedDateIndex = 1.obs;
  late List<DateTime> next7Days;

  // 4. Time Selection
  var selectedTime = "12:30".obs;
  final morningSlots = ["09:00", "09:30", "10:00", "10:30", "11:00", "11:30"];
  final afternoonSlots = ["12:00", "12:30", "13:00", "13:30", "14:00", "14:30"];

  // Computed Price
  double get currentPrice {
    if (cabins.isEmpty) return 0.0;
    final cabin = cabins[selectedCabinIndex.value];
    final minutePricing =
        cabin['minutePricing'] as Map<dynamic, dynamic>? ?? {};
    double basePrice = (cabin['baseMinutePrice'] ?? 2.0).toDouble();

    double total = 0.0;
    int duration = selectedDuration.value;

    // Sum up price for each minute from 1 to selectedDuration
    for (int i = 1; i <= duration; i++) {
      double priceForThisMinute = basePrice; // Default

      // Check if specific price exists for this minute 'i'
      if (minutePricing.containsKey(i.toString())) {
        priceForThisMinute = (minutePricing[i.toString()] as num).toDouble();
      } else if (minutePricing.containsKey(i)) {
        priceForThisMinute = (minutePricing[i] as num).toDouble();
      }

      total += priceForThisMinute;
    }

    return total;
  }

  // Formatted Date String for Footer
  String get formattedSelectedDate {
    if (next7Days.isEmpty) return "";
    final date = next7Days[selectedDateIndex.value];
    final weekdays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    final months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    final w = weekdays[date.weekday - 1];
    final m = months[date.month - 1];

    return "$w, $m ${date.day} • $selectedTime";
  }

  @override
  void onInit() {
    super.onInit();
    _generateDates();
    fetchCabins();

    // Try to get phone from args or Auth
    if (Get.arguments != null && Get.arguments['phoneNumber'] != null) {
      phoneNumber.value = Get.arguments['phoneNumber'];
    } else {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.phoneNumber != null) {
        phoneNumber.value = user.phoneNumber!;
      }
    }
  }

  void _generateDates() {
    final now = DateTime.now();
    next7Days = List.generate(7, (index) => now.add(Duration(days: index)));
  }

  void selectCabin(int index) {
    selectedCabinIndex.value = index;
    _updateAvailableDurations();
  }

  void selectDate(int index) => selectedDateIndex.value = index;
  void selectTime(String time) => selectedTime.value = time;
  void selectDuration(int minutes) => selectedDuration.value = minutes;

  void _updateAvailableDurations() {
    if (cabins.isEmpty) return;
    final cabin = cabins[selectedCabinIndex.value];
    final minutePricing =
        cabin['minutePricing'] as Map<dynamic, dynamic>? ?? {};

    if (minutePricing.isNotEmpty) {
      // Extract keys (minutes) and sort them
      final minutes = minutePricing.keys
          .map((k) => int.tryParse(k.toString()) ?? 0)
          .toList();
      minutes.sort();
      // Filter out 0 or invalid
      final validMinutes = minutes.where((m) => m > 0).toList();

      availableDurations.value = validMinutes;

      // Default select the first one if current selection is invalid
      if (!validMinutes.contains(selectedDuration.value)) {
        if (validMinutes.isNotEmpty) {
          selectedDuration.value = validMinutes.first;
        } else {
          selectedDuration.value = 20; // Fallback
        }
      }
    } else {
      // Fallback defaults if no minute pricing
      availableDurations.value = [10, 20, 30];
      selectedDuration.value = 20;
    }
  }

  Future<void> fetchCabins() async {
    try {
      isLoading.value = true;

      // Load cached cabins first
      await _loadCachedCabins();

      final response = await _apiClient.get('/cabins');

      if (response.data is List) {
        final List dataList = response.data;
        cabins.assignAll(
          dataList.map((data) {
            final imgPath = data['imageUrl'] ?? data['image'] ?? "";
            return {
              "id": data['_id'] ?? "",
              "name": data['name'] ?? "Cabin",
              "type": data['notes'] ?? "Premium Experience",
              "tags": ["High Intensity", "AC"],
              "image": imgPath.toString().isNotEmpty
                  ? imgPath
                  : "https://images.unsplash.com/photo-1590439471364-192aa70c7c53?q=80&w=600&auto=format&fit=crop",
              "isAiPick": true,
              "baseMinutePrice": data['baseMinutePrice'] ?? 2.0,
              "minutePricing": data['minutePricing'] ?? {},
            };
          }).toList(),
        );

        _saveCabinsToCache(cabins.toList());
        _updateAvailableDurations();
      }
    } catch (e) {
      debugPrint("Error fetching cabins: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadCachedCabins() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString('cached_cabins');
      if (cached != null) {
        final List decoded = jsonDecode(cached);
        cabins.value = decoded.cast<Map<String, dynamic>>();
        _updateAvailableDurations();
      }
    } catch (e) {
      print("Error loading cached cabins: $e");
    }
  }

  Future<void> _saveCabinsToCache(List data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cached_cabins', jsonEncode(data));
    } catch (e) {
      print("Error saving cached cabins: $e");
    }
  }

  Future<void> fetchHistory() async {
    try {
      isLoading.value = true;
      String phoneToUse = phoneNumber.value;
      if (phoneToUse.isEmpty) {
        if (Get.arguments != null &&
            Get.arguments is Map &&
            Get.arguments['phoneNumber'] != null) {
          phoneToUse = Get.arguments['phoneNumber'];
          phoneNumber.value = phoneToUse;
        } else {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null && user.phoneNumber != null) {
            phoneToUse = user.phoneNumber!;
            phoneNumber.value = phoneToUse;
          }
        }
      }

      // Load cached history first
      if (phoneToUse.isNotEmpty) {
        await _loadCachedHistory(phoneToUse);
      }

      if (phoneToUse.isNotEmpty) {
        final res = await _apiClient.get(
          '/bookings/my',
          queryParameters: {'phoneNumber': phoneToUse},
        );

        if (res.data is List) {
          List data = res.data;
          final processedData = data
              .map((b) {
                try {
                  final Map<String, dynamic> booking =
                      Map<String, dynamic>.from(b);
                  final cabinData = (booking['cabinId'] is Map)
                      ? booking['cabinId']
                      : (booking['cabin'] ?? {});
                  final cabinImg =
                      cabinData['imageUrl'] ?? cabinData['image'] ?? "";
                  cabinData['image'] = cabinImg.toString().isEmpty
                      ? "https://images.unsplash.com/photo-1590439471364-192aa70c7c53?q=80&w=600&auto=format&fit=crop"
                      : cabinImg;
                  booking['cabinResolved'] = cabinData;
                  return booking;
                } catch (e) {
                  return null;
                }
              })
              .whereType<Map<String, dynamic>>()
              .where((b) {
                final status =
                    b['status']?.toString().toLowerCase() ?? "confirmed";
                final dateStr = b['date']?.toString() ?? "";
                DateTime bookingDate;
                try {
                  bookingDate = DateTime.parse(dateStr);
                } catch (e) {
                  bookingDate = DateFormat("yyyy-MM-dd").parse(dateStr);
                }
                final isPast =
                    bookingDate.isBefore(DateTime.now()) ||
                    DateFormat('yyyy-MM-dd').format(bookingDate) ==
                        DateFormat('yyyy-MM-dd').format(DateTime.now());
                return status == "completed" ||
                    (isPast &&
                        ["confirmed", "paid", "success"].contains(status));
              })
              .toList();

          processedData.sort((a, b) => b['date'].compareTo(a['date']));
          bookingHistory.assignAll(processedData);
          _saveHistoryToCache(phoneToUse, processedData);
        }
      }
    } catch (e) {
      debugPrint("Error fetching history: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadCachedHistory(String phone) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString('history_$phone');
      if (cached != null) {
        final List decoded = jsonDecode(cached);
        bookingHistory.assignAll(decoded.cast<Map<String, dynamic>>());
      }
    } catch (e) {
      print("Error loading history cache: $e");
    }
  }

  Future<void> _saveHistoryToCache(String phone, List data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('history_$phone', jsonEncode(data));
    } catch (e) {
      print("Error saving history cache: $e");
    }
  }

  Future<void> processBooking() async {
    if (cabins.isEmpty) return;
    try {
      isLoading.value = true;

      final total = currentPrice;
      final avgRate = total / selectedDuration.value;
      final date = next7Days[selectedDateIndex.value];
      final formattedDate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      final bookingData = {
        "customerPhone": phoneNumber.value,
        "minutes": selectedDuration.value,
        "cabinId": cabins[selectedCabinIndex.value]['id'],
        "date": formattedDate, // YYYY-MM-DD
        "startTime": selectedTime.value,
        "ratePerMinute":
            avgRate, // Calculated average to satisfy backend validation
        "totalAmount": total,
      };

      await _apiClient.post('/bookings', bookingData);

      // Refresh Home Controller Data
      if (Get.isRegistered<HomeController>()) {
        final homeController = Get.find<HomeController>();
        // Ensure home controller has the right phone number if it was missing
        if (homeController.phoneNumber.value.isEmpty &&
            phoneNumber.value.isNotEmpty) {
          homeController.phoneNumber.value = phoneNumber.value;
        }
        homeController.fetchCustomerData();
      }

      // Refresh History locally if needed (though we navigate away)
      fetchHistory();

      Get.offNamed(
        Routes.BOOKING_CONFIRMATION,
        arguments: {
          "cabinName": cabins[selectedCabinIndex.value]['name'],
          "cabinImage": cabins[selectedCabinIndex.value]['image'],
          "date": formattedDate,
          "time": selectedTime.value,
          "minutes": selectedDuration.value,
          "totalAmount": total,
          "studioName": "Ki Sun Studio",
          "studioAddress":
              "Premium Tanning Experience", // Removing the specific fake address
        },
      );
    } catch (e) {
      Get.snackbar(
        "Sorry",
        "We couldn't complete your booking. Please try again.",
      );
    } finally {
      isLoading.value = false;
    }
  }
}
