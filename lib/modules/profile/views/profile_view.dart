import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/profile_controller.dart';
import '../../../app/routes/app_routes.dart';
import '../../../widgets/sunny_loader.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  static const primaryColor = Color(0xFFF3BA12);
  static const backgroundDark = Color(0xFF221E10);
  // static const backgroundLight = Color(0xFFF8F8F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      body: Stack(
        children: [
          // --- Anti-gravity Background Orbs (Reused) ---
          Positioned(
            top: -200.h,
            left: -200.w,
            child: Container(
              width: 600.w,
              height: 600.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(alpha: 0.1),
              ),
            ),
          ),

          // Main Content
          Column(
            children: [
              // --- Top App Bar ---
              Container(
                padding: EdgeInsets.fromLTRB(16.w, 48.h, 16.w, 16.h),
                decoration: BoxDecoration(
                  color: backgroundDark.withValues(alpha: 0.8),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),
                    ),
                    Text(
                      "Profile & Settings",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 40.w),
                  ],
                ),
              ),

              // --- Scrollable Content ---
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: Column(
                    children: [
                      // --- Profile Header ---
                      Column(
                        children: [
                          GestureDetector(
                            onTap: controller.pickAndUploadImage,
                            child: Stack(
                              children: [
                                Obx(() {
                                  final avatar = controller.userAvatar.value;
                                  return Container(
                                    width: 112.w,
                                    height: 112.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: primaryColor.withValues(
                                          alpha: 0.3,
                                        ),
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: primaryColor.withValues(
                                            alpha: 0.2,
                                          ),
                                          blurRadius: 20,
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: ClipOval(
                                      child:
                                          avatar is String &&
                                              avatar.contains('http')
                                          ? Image.network(
                                              avatar,
                                              fit: BoxFit.cover,
                                              loadingBuilder:
                                                  (
                                                    context,
                                                    child,
                                                    loadingProgress,
                                                  ) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    }
                                                    return const Center(
                                                      child: SunnyLoader(
                                                        size: 40,
                                                      ),
                                                    );
                                                  },
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => const Icon(
                                                    Icons.person,
                                                    color: Colors.white,
                                                  ),
                                            )
                                          : avatar is File
                                          ? Image.file(
                                              avatar,
                                              fit: BoxFit.cover,
                                            )
                                          : const Icon(
                                              Icons.person,
                                              color: Colors.white,
                                            ),
                                    ),
                                  );
                                }),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(4.w),
                                    decoration: BoxDecoration(
                                      color: backgroundDark,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.1,
                                        ),
                                      ),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(4.w),
                                      decoration: const BoxDecoration(
                                        color: primaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.edit,
                                        color: backgroundDark,
                                        size: 14.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24.h),
                          GestureDetector(
                            onTap: controller.updateName,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(
                                  () => Text(
                                    controller.userName.value.isEmpty
                                        ? "No Name"
                                        : controller.userName.value,
                                    style: TextStyle(
                                      color: controller.userName.value.isEmpty
                                          ? Colors.white54
                                          : Colors.white,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Icon(
                                  Icons.edit,
                                  color: Colors.white24,
                                  size: 16.sp,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.vpn_key_outlined,
                                  color: Colors.white24,
                                  size: 14.sp,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  controller.userPhone.value,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.5),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 32.h),

                      // --- Settings Group 1 ---
                      _buildSectionContainer(
                        children: [
                          _buildListTile(
                            icon: Icons.qr_code_scanner,
                            title: "My Access Key",
                            onTap: () => Get.toNamed(
                              Routes.ACCESS_QR,
                              arguments: controller.userPhone.value,
                            ),
                          ),
                          _buildDivider(),
                          _buildListTile(
                            icon: Icons.info_outline,
                            title: "Studio Check-In Guide",
                            onTap: () => Get.toNamed(Routes.STUDIO_GUIDE),
                          ),
                          _buildDivider(),
                          _buildListTile(
                            icon: Icons.calendar_month_outlined,
                            title: "My Bookings",
                            onTap: () => Get.toNamed(Routes.BOOKING_HISTORY),
                          ),
                          _buildDivider(),
                          _buildListTile(
                            icon: Icons.person_outline,
                            title: "Edit Name",
                            onTap: controller.updateName,
                          ),
                          _buildDivider(),
                          _buildListTile(
                            icon: Icons.verified_user_outlined,
                            title: "Manage Consent",
                            onTap: () => Get.toNamed(
                              Routes.MANAGE_CONSENT,
                              arguments: {
                                'phoneNumber': controller.userPhone.value,
                              },
                            ),
                          ),
                          _buildDivider(),
                          _buildListTile(
                            icon: Icons.help_outline_rounded,
                            title: "Help & Support",
                            onTap: () => Get.defaultDialog(
                              title: "Support",
                              middleText: "Contact us at support@kisun.com",
                              textConfirm: "Close",
                              confirmTextColor: Colors.white,
                              onConfirm: () => Get.back(),
                              buttonColor: primaryColor,
                              backgroundColor: const Color(0xFF221E10),
                              titleStyle: const TextStyle(color: Colors.white),
                              middleTextStyle: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 32.h),

                      // --- Preferences ---
                      _buildSectionTitle("PREFERENCES"),
                      _buildSectionContainer(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40.w,
                                  height: 40.w,
                                  decoration: BoxDecoration(
                                    color: primaryColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Icon(
                                    Icons.mail_outline,
                                    color: primaryColor,
                                    size: 20.sp,
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Text(
                                    "Marketing Emails",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => Switch(
                                    value:
                                        controller.marketingEmailsEnabled.value,
                                    onChanged: controller.toggleMarketingEmails,
                                    activeThumbColor: primaryColor,
                                    activeTrackColor: primaryColor.withValues(
                                      alpha: 0.5,
                                    ),
                                    inactiveThumbColor: Colors.grey,
                                    inactiveTrackColor: Colors.white.withValues(
                                      alpha: 0.1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 32.h),

                      // --- Logout Button ---
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        width: double.infinity,
                        height: 50.h,
                        child: OutlinedButton(
                          onPressed: controller.logout,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Colors.red.withValues(alpha: 0.5),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout,
                                color: Colors.red,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                "Log Out",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 48.h),

                      Text(
                        "Version 1.0.2 • Build 8492",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.2),
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.4),
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildSectionContainer({required List<Widget> children}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(
          0xFFFFFF,
        ).withValues(alpha: 0.03), // Glass effect base
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: primaryColor, size: 20.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.white.withValues(alpha: 0.3),
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 1.h, color: Colors.white.withValues(alpha: 0.05));
  }
}
