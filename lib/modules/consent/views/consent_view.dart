import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/consent_controller.dart';
import '../../../widgets/sunny_loader.dart';

class ConsentView extends GetView<ConsentController> {
  const ConsentView({Key? key}) : super(key: key);

  // Colors from design
  static const primaryColor = Color(0xFFFFC105);
  static const backgroundDark = Color(0xFF120F08); // Darker shade
  static const surfaceLight = Color(0xFFF8F8F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,
      body: Stack(
        children: [
          // --- Ambient Background Layer (Anti-gravity Orbs) ---
          Positioned(
            top: -80,
            left: -80,
            child:
                Container(
                  width: 384, // w-96
                  height: 384, // h-96
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor.withValues(
                      alpha: 0.05,
                    ), // Reduced opacity
                  ),
                ).animateGlow(
                  color: primaryColor.withValues(alpha: 0.1),
                  blur: 100,
                ),
          ),
          Positioned(
            bottom: -128,
            right: -40,
            child:
                Container(
                  width: 500,
                  height: 500,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orange.withValues(
                      alpha: 0.03,
                    ), // Reduced opacity
                  ),
                ).animateGlow(
                  color: Colors.orange.withValues(alpha: 0.05),
                  blur: 120,
                ),
          ),

          // --- Backdrop Blur ---
          // Flutter doesn't easily do "mix-blend-screen" native without shaders,
          // but we can approximate the visual by simple stack.

          // --- Main Content ---
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: SunnyLoader(size: 80));
            }
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.05),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white70,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Title Section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Legal & Safety",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 24, // text-2xl increased back slightly
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Please review and accept our studio policies to ensure a safe, AI-optimized tanning experience.",
                          style: TextStyle(
                            fontSize: 12, // text-xs reduced further
                            color: Colors.white.withValues(alpha: 0.6),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Scrollable Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 100,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(
                            24,
                          ), // rounded-3xl
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
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
                          borderRadius: BorderRadius.circular(24),
                          child: Column(
                            children: [
                              // 1. Privacy Policy
                              _buildConsentItem(
                                icon: Icons.shield_outlined, // shield_person
                                title: "Privacy Policy",
                                label: "Required",
                                linkText: "View full policy",
                                isRequired: true,
                                value: controller.acceptedPrivacy,
                              ),
                              const Divider(height: 1, color: Colors.white10),

                              // 2. Terms of Service
                              _buildConsentItem(
                                icon: Icons.gavel_outlined,
                                title: "Terms of Service",
                                label: "Required",
                                linkText: "Read terms",
                                isRequired: true,
                                value: controller.acceptedTerms,
                              ),
                              const Divider(height: 1, color: Colors.white10),

                              // 3. Safety Rules
                              _buildConsentItem(
                                icon: Icons
                                    .warning_amber_rounded, // emergency_home approximation
                                title: "Safety Rules",
                                label: "Required",
                                linkText: "View rules",
                                isRequired: true,
                                value: controller.acceptedRules,
                              ),
                              const Divider(height: 1, color: Colors.white10),

                              // 4. Marketing
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

          // Status Indicator & Sticky Footer
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
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
                  // Status
                  Obx(() {
                    if (controller.canProceed) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: primaryColor,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "All required policies accepted",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox(
                      height: 32,
                    ); // Spacer to keep height consistent-ish
                  }),

                  // Button
                  Obx(
                    () => Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
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
                            borderRadius: BorderRadius.circular(28),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text("I Agree & Continue"),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, size: 20),
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
          onTap: () => value.toggle(),
          hoverColor: Colors.white.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: isRequired ? primaryColor : Colors.white24,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),

                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isRequired
                                  ? primaryColor.withValues(alpha: 0.1)
                                  : Colors.white.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isRequired
                                    ? primaryColor.withValues(alpha: 0.2)
                                    : Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Text(
                              label,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isRequired
                                    ? primaryColor
                                    : Colors.white38,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      if (subtitle != null)
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                        ),
                      if (linkText != null)
                        GestureDetector(
                          onTap: () {
                            // TODO: Show modal or browser
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                linkText,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.4),
                                  decoration: TextDecoration.underline,
                                  decorationColor: primaryColor.withValues(
                                    alpha: 0.5,
                                  ), // Subtle hint
                                ),
                              ),
                              const SizedBox(width: 2),
                              Icon(
                                Icons.arrow_outward,
                                size: 12,
                                color: Colors.white.withValues(alpha: 0.4),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Toggle Switch Custom
                GestureDetector(
                  onTap: () => value.toggle(),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 48,
                    height: 28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: isChecked
                          ? primaryColor
                          : Colors.black.withValues(alpha: 0.4),
                      border: Border.all(
                        color: isChecked
                            ? primaryColor
                            : Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Stack(
                      children: [
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          left: isChecked ? 22 : 2,
                          top: 2,
                          child: Container(
                            width: 22, // 24-4
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 4,
                                ),
                              ],
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

// Extension for simple glow effect on generic widgets if needed,
// but used directly in build above for Container.
extension GlowExtension on Widget {
  Widget animateGlow({required Color color, required double blur}) {
    // Basic placeholder for standard BoxShadow integration
    // Since we applied it directly to Container box decoration above,
    // this extension is just a semantic marker in this snippet.
    return this;
  }
}
