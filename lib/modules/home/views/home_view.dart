import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../shared/constants/app_colors.dart';
import '../controllers/home_controller.dart';
import '../../../app/routes/app_routes.dart';
import '../../../services/connectivity_service.dart';
import '../../../widgets/sunny_loader.dart';
import '../../../app/config/app_config.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Premium Dark
      body: Obx(() {
        final isOnline = Get.find<ConnectivityService>().isOnline.value;
        if (controller.isLoading.value || !isOnline) {
          return Container(
            color: const Color(0xFF121212),
            child: const Center(child: SunnyLoader(size: 80)),
          );
        }

        return SizedBox.expand(
          child: Stack(
            children: [
              // Animated Background Orbs
              Positioned(
                top: -50,
                left: -80,
                child: _buildOrb(
                  300,
                  AppColors.neonSun.withValues(alpha: 0.15),
                ),
              ),
              Positioned(
                bottom: 150,
                right: -80,
                child: _buildOrb(
                  350,
                  Colors.deepOrange.withValues(alpha: 0.08),
                ),
              ),

              SafeArea(
                child: Column(
                  children: [
                    // 1. Header (Profile & Status)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      child: Row(
                        children: [
                          // Profile Pic
                          GestureDetector(
                            onTap: () => Get.toNamed(
                              Routes.PROFILE,
                              arguments: {
                                'phoneNumber': controller.phoneNumber.value,
                              },
                            ),
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.neonSun.withValues(
                                    alpha: 0.3,
                                  ),
                                  width: 2,
                                ),
                              ),
                              child: Obx(() {
                                final image = controller.userProfileImage.value;
                                if (image != null &&
                                    image.toString().isNotEmpty) {
                                  return ClipOval(
                                    child: Image.network(
                                      image.toString(),
                                      fit: BoxFit.cover,
                                      width: 50,
                                      height: 50,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.person,
                                              color: Colors.white70,
                                            );
                                          },
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return const Center(
                                              child: SunnyLoader(size: 20),
                                            );
                                          },
                                    ),
                                  );
                                }
                                return const Icon(
                                  Icons.person,
                                  color: Colors.white70,
                                );
                              }),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Texts
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() {
                                  final isOnline =
                                      Get.find<ConnectivityService>()
                                          .isOnline
                                          .value;
                                  if (isOnline) {
                                    return const Text(
                                      "WELCOME",
                                      style: TextStyle(
                                        color: AppColors.neonSun,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 2,
                                      ),
                                    );
                                  }
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: Colors.redAccent.withValues(
                                          alpha: 0.3,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.wifi_off,
                                          size: 10,
                                          color: Colors.redAccent,
                                        ),
                                        const SizedBox(width: 4),
                                        const Text(
                                          "OFFLINE MODE",
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                                Obx(
                                  () => Text(
                                    controller.userName.value,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Status Chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.neonSun.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.neonSun.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  "SUN ALLOWED",
                                  style: TextStyle(
                                    color: AppColors.neonSun,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.check_circle,
                                  size: 14,
                                  color: AppColors.neonSun,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Access QR Button
                          GestureDetector(
                            onTap: () => Get.toNamed(
                              Routes.ACCESS_QR,
                              arguments: controller.phoneNumber.value,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                              ),
                              child: const Icon(
                                Icons.qr_code_scanner,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Scrollable Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            // 2. Sunny's Daily Tip (Card)
                            _buildAnimatedItem(
                              delay: 100,
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF1E1E1E,
                                  ).withValues(alpha: 0.8),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: Colors.white10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 15,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                AppColors.neonSun,
                                                Colors.orange,
                                              ],
                                            ),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.neonSun
                                                    .withValues(alpha: 0.3),
                                                blurRadius: 8,
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.smart_toy,
                                            size: 12,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          "AI DAILY INSIGHT",
                                          style: TextStyle(
                                            color: AppColors.neonSun,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Obx(
                                      () => Text(
                                        controller.dailyTipTitle.value,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Obx(
                                      () => Text(
                                        controller.dailyTipContent.value,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    // Fancy abstract wave
                                    Container(
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        image: const DecorationImage(
                                          image: NetworkImage(
                                            "https://lh3.googleusercontent.com/aida-public/AB6AXuDdSXeiV0MtYcoDzOEf8M2pXIt9c3znoCcldB0YHxIxNTzO0KEGr2nQaNktYo5q5ovnlDKcOP6GL-gSOjnJM_gzqEhgQj1sm7wWxvyuuY-osCRnXxMlB-2mtoSPHJOtDUN1-iCzGjn1rqjga4AsOcunkOtMrrq6kFs1XqguyPhxEf0Rj3MomDucyVB8a4MGJlRF9EBnjOLqk34XnMuwNmxTefOKYceMiJcAgV1ljwyUF2tW6yKy7h6MA8t9JBsT0qZire6qb_WOwTc",
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // 3. Next Session Booking Panel
                            _buildAnimatedItem(
                              delay: 200,
                              child: Obx(() {
                                final session = controller.nextSession.value;
                                if (session != null) {
                                  return Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF1E1E1E,
                                      ).withValues(alpha: 0.6),
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                        color: AppColors.neonSun.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: AppColors.neonSun
                                                    .withValues(alpha: 0.1),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color: AppColors.neonSun
                                                      .withValues(alpha: 0.2),
                                                ),
                                              ),
                                              child: const Row(
                                                children: [
                                                  Icon(
                                                    Icons.auto_awesome,
                                                    size: 12,
                                                    color: AppColors.neonSun,
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    "AI SETTINGS SAVED",
                                                    style: TextStyle(
                                                      color: AppColors.neonSun,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              "${session['minutes'] ?? 20}m",
                                              style: TextStyle(
                                                color: Colors.white.withValues(
                                                  alpha: 0.4,
                                                ),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          "${(session['cabinId'] is Map ? session['cabinId']['name'] : null) ?? session['cabin']?['name'] ?? 'Premium Cabin'}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Advanced UV-B Protection • Premium Glow",
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.4,
                                            ),
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            _buildSessionStatSmall(
                                              Icons.calendar_today_outlined,
                                              DateFormat('MMM d').format(
                                                DateTime.parse(session['date']),
                                              ),
                                            ),
                                            _buildSessionStatSmall(
                                              Icons.access_time,
                                              session['startTime'] ?? "--:--",
                                            ),
                                            _buildSessionStatSmall(
                                              Icons.timer_outlined,
                                              "${session['minutes'] ?? 20} min",
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 24),
                                        SizedBox(
                                          width: double.infinity,
                                          height: 54,
                                          child: ElevatedButton.icon(
                                            onPressed: () => Get.toNamed(
                                              Routes.ACCESS_QR,
                                              arguments:
                                                  controller.phoneNumber.value,
                                            ),
                                            icon: const Icon(
                                              Icons.qr_code_2,
                                              color: Colors.black,
                                            ),
                                            label: const Text(
                                              "Get Access QR",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.neonSun,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(27),
                                              ),
                                              elevation: 0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                // Default Empty State
                                return Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF1E1E1E,
                                    ).withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(color: Colors.white10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () =>
                                            Get.toNamed(Routes.STUDIO_GUIDE),
                                        child: Row(
                                          children: [
                                            const Text(
                                              "Studio Check-In",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Icon(
                                              Icons.help_outline,
                                              color: Colors.white54,
                                              size: 16,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        "Register at the kiosk or book a slot to start your tanning session.",
                                        style: TextStyle(
                                          color: Colors.white60,
                                          fontSize: 13,
                                        ),
                                      ),
                                      if (AppConfig.allowInAppBooking) ...[
                                        const SizedBox(height: 16),
                                        SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () => Get.toNamed(
                                              Routes.BOOKING,
                                              arguments: {
                                                'phoneNumber': controller
                                                    .phoneNumber
                                                    .value,
                                              },
                                            ), // Navigate with ID
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.neonSun,
                                              foregroundColor: Colors.black,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 12,
                                                  ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              elevation: 0,
                                            ),
                                            child: const Text(
                                              "Book Now",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                );
                              }),
                            ),

                            const SizedBox(height: 24),

                            const SizedBox(
                              height: 100,
                            ), // Spacing for Bottom Nav
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 5. Bottom Navigation Bar (Full Width but Lifted)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    24.w,
                    12.h,
                    24.w,
                    12.h + MediaQuery.of(context).viewPadding.bottom,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF121212).withValues(alpha: 0.95),
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(Icons.home_filled, "Home", true, () {}),
                      if (AppConfig.allowInAppBooking)
                        _buildNavItem(
                          Icons.calendar_month_outlined,
                          "Book",
                          false,
                          () => Get.toNamed(
                            Routes.BOOKING,
                            arguments: {
                              'phoneNumber': controller.phoneNumber.value,
                            },
                          ),
                        ),
                      _buildNavItem(
                        Icons.history,
                        "My Bookings",
                        false,
                        () => Get.toNamed(
                          Routes.BOOKING_HISTORY,
                          arguments: {
                            'phoneNumber': controller.phoneNumber.value,
                          },
                        ),
                      ),
                      _buildNavItem(
                        Icons.person_outline,
                        "Profile",
                        false,
                        () => Get.toNamed(
                          Routes.PROFILE,
                          arguments: {
                            'phoneNumber': controller.phoneNumber.value,
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSessionStatSmall(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.neonSun.withValues(alpha: 0.7), size: 14),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque, // Ensure touch target
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppColors.neonSun : Colors.white24,
            size: 24.sp,
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              color: isActive ? AppColors.neonSun : Colors.white24,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0)],
            stops: const [0.2, 1.0],
          ),
        ),
      ),
    );
  }

  // Simple Helper for Staggered Animation using TweenAnimationBuilder
  Widget _buildAnimatedItem({required Widget child, required int delay}) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)), // Slide Up
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
