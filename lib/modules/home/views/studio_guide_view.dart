import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/constants/app_colors.dart';

class StudioGuideView extends StatelessWidget {
  const StudioGuideView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Studio Check-In Guide",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "HOW TO ACCESS THE STUDIO",
              style: TextStyle(
                color: AppColors.neonSun,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
            SizedBox(height: 12.h),
            const Text(
              "Follow these steps for a seamless manual or self-check-in experience.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
                height: 1.5,
              ),
            ),
            SizedBox(height: 40.h),

            _buildStep(
              number: "01",
              title: "Arrive at Studio",
              description:
                  "Locate the self-service kiosk near the entrance of our studio.",
              icon: Icons.location_on_outlined,
            ),
            _buildStep(
              number: "02",
              title: "Open Your Access Key",
              description:
                  "Tap the QR icon on your Home screen or Profile to show your Digital Key.",
              icon: Icons.qr_code_scanner,
            ),
            _buildStep(
              number: "03",
              title: "Scan & Unlock",
              description:
                  "Hold your QR code in front of the kiosk scanner. Your session will be validated instantly.",
              icon: Icons.vpn_key_outlined,
            ),
            _buildStep(
              number: "04",
              title: "Select & Pay",
              description:
                  "If you haven't booked yet, you can select your cabin and pay via the card reader at the studio.",
              icon: Icons.credit_card_outlined,
            ),

            SizedBox(height: 40.h),
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColors.neonSun.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.neonSun.withValues(alpha: 0.1),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.neonSun),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "The app is your identity. All your bookings and sessions are automatically synced when you scan.",
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.neonSun,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  "GOT IT",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep({
    required String number,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 32.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Center(child: Icon(icon, color: Colors.white, size: 20)),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      number,
                      style: const TextStyle(
                        color: AppColors.neonSun,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
