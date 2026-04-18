import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../app/routes/app_routes.dart';

class WelcomeSunnyView extends StatelessWidget {
  const WelcomeSunnyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retrieve phone number to pass forward
    final phoneNumber = Get.arguments?['phoneNumber'];

    return Scaffold(
      backgroundColor: Colors.black, // Background Dark
      body: Stack(
        children: [
          // Ambient Orb Layers
          Positioned(
            top: -50,
            left: -100,
            child: _buildOrb(300, AppColors.neonSun.withValues(alpha: 0.15)),
          ),
          Positioned(
            bottom: 100,
            right: -50,
            child: _buildOrb(250, Colors.orange.withValues(alpha: 0.1)),
          ),
          Positioned(
            top: 300,
            right: 40,
            child: _buildOrb(150, AppColors.neonSun.withValues(alpha: 0.08)),
          ),

          // Main Content
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 20), // Top spacer
                // Center Content: Mascot & Text
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Mascot Placeholder (Glowing Sun)
                      Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.neonSun.withValues(alpha: 0.4),
                              blurRadius: 50,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.sunny,
                          size: 150,
                          color: AppColors.neonSun,
                        ), // Replace with Image asset if available
                      ),
                      const SizedBox(height: 40),

                      // Text Stack
                      const Text(
                        "Hi! I'm Sunny ☀️",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          "Let's find your perfect tan.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Action Area
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 80),
                  child: SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: ElevatedButton(
                      onPressed: () {
                        // Pass phone number forward
                        Get.toNamed(
                          Routes.SKIN_ANALYSIS_WIZARD,
                          arguments: {'phoneNumber': phoneNumber},
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.neonSun,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                        elevation: 10,
                        shadowColor: AppColors.neonSun.withValues(alpha: 0.5),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.flare, size: 28),
                          SizedBox(width: 12),
                          Text(
                            "Start Skin Analysis",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
}
