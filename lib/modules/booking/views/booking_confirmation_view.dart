import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import '../controllers/booking_controller.dart';
import '../../../app/routes/app_routes.dart';
import '../../../widgets/sunny_loader.dart';

class BookingConfirmationView extends GetView<BookingController> {
  const BookingConfirmationView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> booking = Get.arguments ?? {};

    // Theme Constants
    const primaryColor = Color(0xFFF9BD0B);
    const backgroundDark = Color(0xFF181611);
    const cardBg = Color(0xFF2E291D);
    const textColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundDark,
      body: Stack(
        children: [
          // Decorative Orbs
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withOpacity(0.1),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                children: [
                  // Sun Icon with Checkmark
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                        child: const Icon(
                          Icons.wb_sunny,
                          color: primaryColor,
                          size: 64,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Success Message
                  const Text(
                    "You're all set to glow!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Your booking has been confirmed\nsuccessfully.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor.withOpacity(0.6),
                      fontSize: 16,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Booking Card
                  Container(
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cabin Image
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),
                              child: Image.network(
                                booking['cabinImage'] ??
                                    "https://lh3.googleusercontent.com/aida-public/AB6AXuDrKmdBtGUZSFx4IuIKo0QmSy5ExypvfFxe3b_T6NzPXoyRz6qd8gLXtCxlhMHUmdJGvCdlTCfsdCdeAHlzoHYBtWmMbEAXVln3T6_DfrnUmneyUTzDW5iMFweHU105X8eMTB657LGDJz0Qwi0csSrKiaXih2t6LlZJ2i4_OcliLIuepCqu_EUptho_gnaQXVcQltgovMHyrONP-TRPk4sES6c__MIqC1Gus7mcILFGslhBsai6lsEWZgmnlypHohRGABL14suQgUQ",
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        height: 200,
                                        width: double.infinity,
                                        color: Colors.white.withOpacity(0.05),
                                        child: const Center(
                                          child: SunnyLoader(size: 40),
                                        ),
                                      );
                                    },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 200,
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
                            Positioned(
                              bottom: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      "Confirmed",
                                      style: TextStyle(
                                        color: Colors.white,
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

                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "UPCOMING SESSION",
                                style: TextStyle(
                                  color: primaryColor.withOpacity(0.7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "${booking['studioName'] ?? 'Ki Sun Studio'} • ${booking['cabinName'] ?? 'Cabin'}",
                                style: const TextStyle(
                                  color: textColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                booking['studioAddress'] ??
                                    "Premium Tanning Experience",
                                style: TextStyle(
                                  color: textColor.withOpacity(0.5),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Divider(color: Colors.white10),
                              const SizedBox(height: 20),

                              // Info Grid
                              Row(
                                children: [
                                  _buildInfoItem(
                                    icon: Icons.calendar_today,
                                    label: "DATE",
                                    value: booking['date'] ?? "",
                                  ),
                                  _buildInfoItem(
                                    icon: Icons.access_time_filled,
                                    label: "TIME",
                                    value: booking['time'] ?? "",
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  _buildInfoItem(
                                    icon: Icons.timer,
                                    label: "DURATION",
                                    value: "${booking['minutes'] ?? 0} Mins",
                                  ),
                                  _buildInfoItem(
                                    icon: Icons.payments,
                                    label: "PAYMENT",
                                    value:
                                        "\$${(booking['totalAmount'] ?? 0).toStringAsFixed(2)} Paid",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Buttons
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => Get.offAllNamed(Routes.HOME),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: const Text(
                        "Done",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Redirecting to home...",
                    style: TextStyle(
                      color: textColor.withOpacity(0.3),
                      fontSize: 12,
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

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(icon, color: const Color(0xFFF9BD0B), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
