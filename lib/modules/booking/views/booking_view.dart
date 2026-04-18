import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import '../controllers/booking_controller.dart';
import '../../../widgets/sunny_loader.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../services/connectivity_service.dart';

class BookingView extends GetView<BookingController> {
  const BookingView({super.key});

  @override
  Widget build(BuildContext context) {
    // Theme Constants
    const primaryColor = AppColors.neonSun;
    const backgroundDark = Color(0xFF0D0D0D); // Deeper Black
    const surfaceDark = Color(0xFF1A1A1A); // Card/Surface BG
    const textColor = Colors.white;

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
              // --- Decorative Background Orbs (Blurred) ---
              Positioned(
                top: -50,
                left: -50,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor.withOpacity(0.08),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.4,
                right: -50,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor.withOpacity(0.05),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: MediaQuery.of(context).size.width * 0.2,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orange.withOpacity(0.15),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ),

              // --- Main Content ---
              Column(
                children: [
                  // Top App Bar
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          _buildGlassIconButton(
                            icon: Icons.arrow_back,
                            onTap: () => Get.back(),
                          ),
                          Expanded(
                            child: Text(
                              "Book Session",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Plus Jakarta Sans',
                              ),
                            ),
                          ),
                          // Spacer to balance back button
                          const SizedBox(width: 40),
                        ],
                      ),
                    ),
                  ),

                  // Progress Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildProgressDot(
                        isActive: true,
                        primaryColor: primaryColor,
                      ),
                      const SizedBox(width: 6),
                      _buildProgressDot(
                        isActive: false,
                        primaryColor: primaryColor,
                      ),
                      const SizedBox(width: 6),
                      _buildProgressDot(
                        isActive: false,
                        primaryColor: primaryColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Scrollable Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(
                        bottom: 200,
                      ), // Increased space for Sticky Bar
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Section: Choose Experience (Cabins)
                          _buildSectionHeader("Choose Experience"),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 320, // Height for Cabin Card
                            child: Obx(
                              () => controller.cabins.isEmpty
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: primaryColor,
                                      ),
                                    )
                                  : ListView.separated(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                      ),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: controller.cabins.length,
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(width: 16),
                                      itemBuilder: (context, index) {
                                        final cabin = controller.cabins[index];
                                        return Obx(() {
                                          final isSelected =
                                              controller
                                                  .selectedCabinIndex
                                                  .value ==
                                              index;
                                          return GestureDetector(
                                            onTap: () =>
                                                controller.selectCabin(index),
                                            child: _buildCabinCard(
                                              cabin: cabin,
                                              isSelected: isSelected,
                                              primaryColor: primaryColor,
                                              surfaceColor: surfaceDark,
                                            ),
                                          );
                                        });
                                      },
                                    ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Section: Select Duration (NEW)
                          _buildSectionHeader("Select Duration"),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 50,
                            child: Obx(
                              () => ListView.separated(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.availableDurations.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 12),
                                itemBuilder: (context, index) {
                                  final duration =
                                      controller.availableDurations[index];
                                  return Obx(() {
                                    final isSelected =
                                        controller.selectedDuration.value ==
                                        duration;
                                    return GestureDetector(
                                      onTap: () =>
                                          controller.selectDuration(duration),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? primaryColor
                                              : Colors.white.withOpacity(0.05),
                                          borderRadius: BorderRadius.circular(
                                            25,
                                          ),
                                          border: Border.all(
                                            color: isSelected
                                                ? primaryColor
                                                : Colors.white.withOpacity(0.1),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "$duration min",
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Colors.black
                                                  : Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Section: Select Date
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Select Date",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Plus Jakarta Sans',
                                  ),
                                ),
                                // Month Display
                                Text(
                                  controller.next7Days.isNotEmpty
                                      ? _formatMonthYear(
                                          controller.next7Days.first,
                                        )
                                      : "",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 90,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.next7Days.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (context, index) {
                                final date = controller.next7Days[index];
                                return Obx(() {
                                  final isSelected =
                                      controller.selectedDateIndex.value ==
                                      index;
                                  return GestureDetector(
                                    onTap: () => controller.selectDate(index),
                                    child: _buildDatePill(
                                      date: date,
                                      isSelected: isSelected,
                                      primaryColor: primaryColor,
                                    ),
                                  );
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Section: Pick a Time
                          _buildSectionHeader("Pick a Time"),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildTimeGroupHeader(
                                  "Morning",
                                  Icons.wb_sunny_outlined,
                                ),
                                const SizedBox(height: 12),
                                _buildTimeGrid(
                                  controller.morningSlots,
                                  primaryColor,
                                ),
                                const SizedBox(height: 24),
                                _buildTimeGroupHeader(
                                  "Afternoon",
                                  Icons.cloud_queue,
                                ),
                                const SizedBox(height: 12),
                                _buildTimeGrid(
                                  controller.afternoonSlots,
                                  primaryColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // --- Sticky Bottom Bar ---
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(24, 20, 24, 80),
                      decoration: BoxDecoration(
                        color: backgroundDark.withOpacity(0.85),
                        border: Border(
                          top: BorderSide(
                            color: Colors.white.withOpacity(0.05),
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Summary Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 18,
                                    color: Colors.white70,
                                  ),
                                  const SizedBox(width: 8),
                                  Obx(
                                    () => Text(
                                      controller.formattedSelectedDate,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                        fontFamily: 'Plus Jakarta Sans',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Obx(
                                () => Text(
                                  "\$${controller.currentPrice.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Plus Jakarta Sans',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Confirm Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: controller.processBooking,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.black,
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                shadowColor: primaryColor.withOpacity(0.4),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Confirm Booking",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward, size: 20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // --- Widgets Helpers ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Plus Jakarta Sans',
        ),
      ),
    );
  }

  Widget _buildGlassIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.05),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildProgressDot({
    required bool isActive,
    required Color primaryColor,
  }) {
    return Container(
      width: isActive ? 32 : 8,
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? primaryColor : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(3),
        boxShadow: isActive
            ? [BoxShadow(color: primaryColor.withOpacity(0.5), blurRadius: 10)]
            : [],
      ),
    );
  }

  Widget _buildCabinCard({
    required Map<String, dynamic> cabin,
    required bool isSelected,
    required Color primaryColor,
    required Color surfaceColor,
  }) {
    // Cast types safely with robust fallback for image keys
    final String name = cabin['name'] ?? 'Cabin';
    final String type = cabin['type'] ?? 'Premium Experience';
    final String imageUrl = cabin['image'] ?? cabin['imageUrl'] ?? "";
    final bool isAiPick = cabin['isAiPick'] ?? false;
    final List<String> tags = List<String>.from(cabin['tags'] ?? []);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? primaryColor : Colors.white.withOpacity(0.05),
          width: 1.5,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor.withOpacity(0.6),
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white.withOpacity(0.05), Colors.transparent],
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Area
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 180,
                        width: double.infinity,
                        color: Colors.white.withOpacity(0.05),
                        child: const Center(child: SunnyLoader(size: 40)),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        width: double.infinity,
                        color: Colors.white.withOpacity(0.05),
                        child: Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.white.withOpacity(0.2),
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
                if (isAiPick)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 14,
                            color: Colors.black,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            "AI Pick",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // Info Area
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        type,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle, color: primaryColor, size: 24)
                else
                  Icon(
                    Icons.radio_button_unchecked,
                    color: Colors.white24,
                    size: 24,
                  ),
              ],
            ),
            const Spacer(),
            // Tags
            Row(
              children: tags.map((tag) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePill({
    required DateTime date,
    required bool isSelected,
    required Color primaryColor,
  }) {
    final weekdays = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"];
    final dayName = weekdays[date.weekday - 1];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 64,
      decoration: const BoxDecoration(),
      child: Column(
        children: [
          Text(
            dayName,
            style: TextStyle(
              color: isSelected ? primaryColor : Colors.white.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? primaryColor : Colors.white.withOpacity(0.03),
              border: Border.all(
                color: isSelected
                    ? primaryColor
                    : Colors.white.withOpacity(0.08),
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                "${date.day}",
                style: TextStyle(
                  color: isSelected
                      ? Colors.black
                      : Colors.white.withOpacity(0.8),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeGroupHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.6), size: 18),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeGrid(List<String> slots, Color primaryColor) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final time = slots[index];
        return Obx(() {
          final isSelected = controller.selectedTime.value == time;
          return GestureDetector(
            onTap: () => controller.selectTime(time),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isSelected
                    ? primaryColor
                    : Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isSelected
                      ? primaryColor
                      : Colors.white.withOpacity(0.08),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.3),
                          blurRadius: 10,
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  time,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  String _formatMonthYear(DateTime date) {
    final months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return "${months[date.month - 1]} ${date.year}";
  }
}
