import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import '../../../shared/constants/app_colors.dart';
import '../../../app/routes/app_routes.dart';
import '../controllers/booking_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../../services/connectivity_service.dart';
import '../../../widgets/sunny_loader.dart';

class BookingHistoryView extends GetView<BookingController> {
  const BookingHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Refresh history when built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchHistory();
    });

    const primaryColor = AppColors.neonSun;
    const backgroundDark = Color(0xFF121212);

    return Scaffold(
      backgroundColor: backgroundDark,
      body: Obx(() {
        final isOnline = Get.find<ConnectivityService>().isOnline.value;
        if (controller.isLoading.value || !isOnline) {
          return Container(
            color: backgroundDark,
            child: const Center(child: SunnyLoader(size: 80)),
          );
        }

        return SizedBox.expand(
          child: Stack(
            children: [
              // Background Orbs
              Positioned(
                top: -100,
                right: -100,
                child: _buildOrb(300, primaryColor.withValues(alpha: 0.1)),
              ),

              SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. App Bar (Menu, Title, Notification)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: const Center(
                        child: Text(
                          "My Sessions",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Plus Jakarta Sans',
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),

                    // 2. Tab Selector
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            _buildTabItem(
                              "Upcoming",
                              controller.selectedTab.value == "Upcoming",
                              primaryColor,
                            ),
                            _buildTabItem(
                              "History",
                              controller.selectedTab.value == "History",
                              primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 3. Tab Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (controller.selectedTab.value == "Upcoming")
                              _buildUpcomingTab(primaryColor)
                            else
                              _buildHistoryTab(primaryColor),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTabItem(String label, bool isSelected, Color primaryColor) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectTab(label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingTab(Color primaryColor) {
    if (!Get.isRegistered<HomeController>()) return const SizedBox();
    final homeController = Get.find<HomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Upcoming Sessions"),
        const SizedBox(height: 16),
        Obx(() {
          if (homeController.upcomingSessions.isEmpty) {
            return _buildEmptyState(primaryColor);
          }
          return ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: homeController.upcomingSessions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return _buildNextSessionCard(
                Map<String, dynamic>.from(
                  homeController.upcomingSessions[index],
                ),
                primaryColor,
              );
            },
          );
        }),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionHeader("Recent History", padding: 0),
            TextButton(
              onPressed: () => controller.selectTab("History"),
              child: const Text(
                "View All",
                style: TextStyle(
                  color: AppColors.neonSun,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildRecentHistoryList(primaryColor),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildHistoryTab(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Full History"),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.bookingHistory.isEmpty) {
            return _buildEmptyState(primaryColor);
          }
          return ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.bookingHistory.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return _buildHistoryItem(
                Map<String, dynamic>.from(controller.bookingHistory[index]),
                primaryColor,
              );
            },
          );
        }),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {double padding = 0}) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'Plus Jakarta Sans',
      ),
    );
  }

  Widget _buildNextSessionCard(
    Map<String, dynamic> booking,
    Color primaryColor,
  ) {
    // Use resolved image from HomeController if available, otherwise resolve now
    final cabinData =
        booking['cabinResolved'] ??
        ((booking['cabinId'] is Map)
            ? booking['cabinId']
            : (booking['cabin'] ?? {}));
    final cabinName = cabinData['name'] ?? 'Premium Cabin';
    final cabinImage =
        booking['resolvedImage'] ??
        cabinData['image'] ??
        cabinData['imageUrl'] ??
        "";

    DateTime bookingDate;
    try {
      bookingDate = DateTime.parse(booking['date']);
    } catch (_) {
      bookingDate = DateTime.now();
    }

    final isToday =
        DateFormat('yyyy-MM-dd').format(bookingDate) ==
        DateFormat('yyyy-MM-dd').format(DateTime.now());

    return InkWell(
      onTap: () => Get.toNamed(Routes.BOOKING_DETAILS, arguments: booking),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Large Image with Badges
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  child: Image.network(
                    cabinImage.isNotEmpty
                        ? cabinImage
                        : "https://images.unsplash.com/photo-1590439471364-192aa70c7c53?q=80&w=600&auto=format&fit=crop",
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: _buildBadge(
                    Icons.check_circle,
                    (booking['status']?.toString().toUpperCase() ??
                        "CONFIRMED"),
                    primaryColor,
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildBadge(
                        Icons.auto_awesome,
                        "AI SETTINGS SAVED",
                        AppColors.neonSun,
                      ),
                      Text(
                        "${booking['minutes'] ?? 20}m",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    cabinName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Advanced UV-B Protection • Premium Glow",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSessionStat(
                        Icons.calendar_today_outlined,
                        "DATE",
                        isToday
                            ? "Today"
                            : DateFormat('MMM d').format(bookingDate),
                      ),
                      _buildSessionStat(
                        Icons.access_time,
                        "TIME",
                        booking['startTime'] ?? "--:--",
                      ),
                      _buildSessionStat(
                        Icons.timer_outlined,
                        "DURATION",
                        "${booking['minutes'] ?? 20}m",
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () => Get.toNamed(
                        Routes.ACCESS_QR,
                        arguments: Get.find<HomeController>().phoneNumber.value,
                      ),
                      icon: const Icon(Icons.qr_code_2, color: Colors.black),
                      label: const Text(
                        "Get Access QR",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.neonSun,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionStat(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white70, size: 16),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentHistoryList(Color primaryColor) {
    final history = controller.bookingHistory.take(3).toList();
    if (history.isEmpty) return const SizedBox();

    return Column(
      children: history
          .map(
            (item) => _buildHistoryItem(
              Map<String, dynamic>.from(item),
              primaryColor,
            ),
          )
          .toList(),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> booking, Color primaryColor) {
    final cabinData =
        booking['cabinResolved'] ??
        ((booking['cabinId'] is Map)
            ? booking['cabinId']
            : (booking['cabin'] ?? {}));
    final cabinName = cabinData['name'] ?? 'Premium Cabin';
    final cabinImage = cabinData['image'] ?? cabinData['imageUrl'] ?? "";

    DateTime date;
    try {
      date = DateTime.parse(booking['date']);
    } catch (_) {
      date = DateTime.now();
    }

    final day = date.day.toString().padLeft(2, '0');
    final month = DateFormat('MMM').format(date).toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
      ),
      child: Row(
        children: [
          // Cabin Image Thumbnail (replacing circular date if image exists or keeping both)
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: cabinImage.toString().isNotEmpty
                  ? Image.network(
                      cabinImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.wb_sunny,
                        color: Colors.white24,
                        size: 20,
                      ),
                    )
                  : const Icon(Icons.wb_sunny, color: Colors.white24, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          // Circular Date
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.03),
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  month,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  day,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cabinName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${booking['minutes'] ?? 20} Mins • ${booking['status']?.toString().capitalizeFirst ?? 'Paid'}",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          // Rebook Button
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.refresh,
              color: AppColors.neonSun,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(Color primaryColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 48,
            color: Colors.white.withValues(alpha: 0.1),
          ),
          const SizedBox(height: 16),
          const Text(
            "No sessions found",
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _buildOrb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withAlpha(0)],
          stops: const [0.2, 1.0],
        ),
      ),
    );
  }
}
