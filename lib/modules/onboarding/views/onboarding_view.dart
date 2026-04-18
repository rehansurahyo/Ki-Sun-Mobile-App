import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/onboarding_controller.dart';
// import '../../../shared/constants/app_colors.dart'; // Unused

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Colors based on new Golden Black design
    const primaryColor = Color(0xFFFFC105); // Neon #ffc105
    const backgroundDark = Color(0xFF000000); // Pure black
    const surfaceDark = Color(0xFF1A1A1A); // Darker surface

    return Scaffold(
      backgroundColor: backgroundDark,
      body: Stack(
        children: [
          // --- 1. Background Elements (Orbs) ---

          // Top Left Orb
          Positioned(
            top: -100.h,
            left: -50.w,
            width: 350.w,
            height: 350.h,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(alpha: 0.08),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          // Bottom Right Orb
          Positioned(
            bottom: -50.h,
            right: -80.w,
            width: 400.w,
            height: 400.h,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(alpha: 0.05),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          // --- 2. Main Content ---
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // Logo / Icon Container (Glassmorphism)
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(scale: value, child: child);
                  },
                  child: Container(
                    width: 200.w,
                    height: 200.w, // Square based on width
                    decoration: BoxDecoration(
                      color: surfaceDark.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: primaryColor.withValues(alpha: 0.1),
                        width: 1.w,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.05),
                          blurRadius: 40,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Pulsing Rings (Simple)
                          Container(
                            width: 120.w,
                            height: 120.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColor.withValues(alpha: 0.1),
                            ),
                          ),
                          Icon(
                            Icons.wb_sunny_rounded,
                            size: 80.sp,
                            color: primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 50.h),

                // Animated Text
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        "Welcome to Ki-Sun",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.5,
                          shadows: [
                            Shadow(
                              color: primaryColor.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "AI-Powered Smart Tanning",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white.withValues(alpha: 0.6),
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Animated Button
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 1000),
                  curve: const Interval(0.5, 1.0, curve: Curves.easeOutBack),
                  builder: (context, value, child) {
                    return Transform.scale(scale: value, child: child);
                  },
                  child: GestureDetector(
                    onTap: controller.getStarted,
                    child: Container(
                      width: double.infinity,
                      height: 56.h,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(30.r),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "START GLOWING",
                            style: TextStyle(
                              color: const Color(0xFF12100A), // TextDark
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Color(0xFF12100A),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 80.h,
                ), // Increased from 40 to 80 to move button up
              ],
            ),
          ),
        ],
      ),
    );
  }
}
