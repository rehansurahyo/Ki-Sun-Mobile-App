import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/consent_controller.dart';
import '../../../widgets/sunny_loader.dart';

class ManageConsentView extends GetView<ConsentController> {
  const ManageConsentView({Key? key}) : super(key: key);

  static const primaryColor = Color(0xFFFFC105);
  static const backgroundDark = Color(0xFF120F08);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      body: Stack(
        children: [
          // --- Ambient Background Layer (Anti-gravity Orbs) ---
          Positioned(
            top: -80.h,
            left: -80.w,
            child: Container(
              width: 300.w,
              height: 300.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -100.h,
            right: -50.w,
            child: Container(
              width: 400.w,
              height: 400.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange.withValues(alpha: 0.03),
              ),
            ),
          ),

          // --- Main Content ---
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: SunnyLoader(size: 80));
            }
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Header ---
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 8.h),
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.05),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white70,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // --- Title Section ---
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Legal & Safety",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "Review and update your studio policies and preferences at any time.",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white.withValues(alpha: 0.6),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- Scrollable Content ---
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        left: 24.w,
                        right: 24.w,
                        bottom: 128.h,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.03),
                          borderRadius: BorderRadius.circular(24.r),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24.r),
                          child: Column(
                            children: [
                              _buildConsentItem(
                                icon: Icons.shield_outlined,
                                title: "Privacy Policy",
                                label: "Required",
                                linkText: "View full policy",
                                isRequired: true,
                                value: controller.acceptedPrivacy,
                              ),
                              const Divider(height: 1, color: Colors.white10),
                              _buildConsentItem(
                                icon: Icons.gavel_outlined,
                                title: "Terms of Service",
                                label: "Required",
                                linkText: "Read terms",
                                isRequired: true,
                                value: controller.acceptedTerms,
                              ),
                              const Divider(height: 1, color: Colors.white10),
                              _buildConsentItem(
                                icon: Icons.warning_amber_rounded,
                                title: "Safety Rules",
                                label: "Required",
                                linkText: "View rules",
                                isRequired: true,
                                value: controller.acceptedRules,
                              ),
                              const Divider(height: 1, color: Colors.white10),
                              _buildConsentItem(
                                icon: Icons.stars_rounded,
                                title: "Marketing",
                                label: "Optional",
                                subtitle: "Get AI insights & promo offers",
                                isRequired: false,
                                value: controller.acceptedMarketing,
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

          // --- Bottom Action Button ---
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(24.w, 40.h, 24.w, 24.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black,
                    backgroundDark,
                    backgroundDark.withValues(alpha: 0),
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                    () => Container(
                      width: double.infinity,
                      height: 56.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28.r),
                        boxShadow: controller.canProceed
                            ? [
                                BoxShadow(
                                  color: primaryColor.withValues(alpha: 0.3),
                                  blurRadius: 25,
                                  spreadRadius: 0,
                                ),
                              ]
                            : [],
                      ),
                      child: ElevatedButton(
                        onPressed: controller.canProceed
                            ? controller.acceptAndContinue
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: backgroundDark,
                          disabledBackgroundColor: Colors.grey[800],
                          disabledForegroundColor: Colors.white38,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.r),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              controller.isManageMode
                                  ? "Save Changes"
                                  : "I Agree & Continue",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Icon(Icons.save_outlined, size: 20.sp),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsentItem({
    required IconData icon,
    required String title,
    required String label,
    String? linkText,
    String? subtitle,
    required bool isRequired,
    required RxBool value,
  }) {
    return Obx(() {
      final isChecked = value.value;
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (!isRequired) value.toggle();
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: Colors.white.withValues(alpha: 0.05),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: isRequired ? primaryColor : Colors.white24,
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isRequired
                                  ? primaryColor.withValues(alpha: 0.1)
                                  : Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              label,
                              style: TextStyle(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                                color: isRequired
                                    ? primaryColor
                                    : Colors.white38,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                      if (linkText != null) ...[
                        SizedBox(height: 4.h),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              linkText,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.white38,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Icon(
                              Icons.arrow_outward,
                              size: 10.sp,
                              color: Colors.white24,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                GestureDetector(
                  onTap: () {
                    if (!isRequired) value.toggle();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 44.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: isChecked
                          ? primaryColor
                          : Colors.black.withValues(alpha: 0.4),
                    ),
                    child: Stack(
                      children: [
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 200),
                          left: isChecked ? 22.w : 2.w,
                          top: 2.h,
                          child: Container(
                            width: 20.w,
                            height: 20.h,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
