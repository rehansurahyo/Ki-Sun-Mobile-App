import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/kyc_controller.dart';
// import '../../../shared/constants/app_colors.dart'; // Unused

class KYCIntroView extends GetView<KYCController> {
  const KYCIntroView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Colors based on requested design
    const primaryColor = Color(0xFFFFC105); // Neon #ffc105
    const backgroundDark = Color(0xFF12100A); // Deep black/brown
    const surfaceDark = Color(0xFF231E0F);

    return Scaffold(
      backgroundColor: backgroundDark,
      body: Stack(
        children: [
          // --- 1. Background Elements (Fixed behind scroll) ---

          // Top Right Orb
          Positioned(
            top: -80,
            right: -80,
            width: 300,
            height: 300,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(alpha: 0.2),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          // Bottom Left Orb
          Positioned(
            bottom: -50,
            left: -120,
            width: 400,
            height: 400,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(alpha: 0.1),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          // Center Glow
          Align(
            alignment: Alignment.center,
            child: Container(
              width: Get.width,
              height: Get.height,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.7,
                  colors: [
                    primaryColor.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // --- 2. Scrollable Content ---
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: Get.height * 0.05), // Top spacing
                    // Icon / Brand Mark
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: surfaceDark.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: primaryColor.withValues(alpha: 0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.lock_person,
                        color: primaryColor,
                        size: 48,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Warning Headline "18+"
                    Text(
                      "18+",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 80,
                        fontWeight: FontWeight.w900,
                        color: primaryColor,
                        height: 1.0,
                        shadows: [
                          Shadow(
                            color: primaryColor.withValues(alpha: 0.5),
                            blurRadius: 30,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "STRICTLY PROHIBITED",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withValues(alpha: 0.95),
                        letterSpacing: 1.5,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Body Text
                    Text(
                      "To ensure safety and compliance, access to our AI tanning studios is restricted to adults only.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.7),
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Legal Compliance Badge
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: surfaceDark.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.verified_user,
                            color: primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "We use legally compliant ID verification to process your access request.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // --- Added Extra Space as Requested ---
                    SizedBox(height: Get.height * 0.1),

                    // --- CTA Button ---
                    GestureDetector(
                      onTap: controller.startProcess,
                      child: Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(30),
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
                          children: const [
                            Text(
                              "Verify Age Now",
                              style: TextStyle(
                                color: Color(0xFF12100A), // TextDark
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Color(0xFF12100A),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Footer Meta
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.security,
                              size: 14,
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "SECURE TRANSMISSION",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2,
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Powered by SecureVerify | Privacy Policy",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20), // Bottom padding
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
