import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../services/connectivity_service.dart';
import '../../../widgets/sunny_loader.dart';

class BookingDetailsView extends StatelessWidget {
  const BookingDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> booking = Get.arguments ?? {};
    final cabinData =
        booking['cabinResolved'] ??
        ((booking['cabinId'] is Map)
            ? booking['cabinId']
            : (booking['cabin'] ?? {}));

    final cabinName = cabinData['name'] ?? 'Premium Cabin';
    final cabinImage =
        booking['resolvedImage'] ??
        cabinData['image'] ??
        cabinData['imageUrl'] ??
        "";
    final status = booking['status']?.toString().toUpperCase() ?? "CONFIRMED";

    DateTime bookingDate;
    try {
      bookingDate = DateTime.parse(booking['date']);
    } catch (_) {
      bookingDate = DateTime.now();
    }

    const primaryColor = AppColors.neonSun;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Obx(() {
        if (!Get.find<ConnectivityService>().isOnline.value) {
          return Container(
            color: const Color(0xFF121212),
            child: const Center(child: SunnyLoader(size: 80)),
          );
        }
        return CustomScrollView(
          slivers: [
            // Premium Header with Image
            SliverAppBar(
              expandedHeight: 350,
              pinned: true,
              backgroundColor: const Color(0xFF121212),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Get.back(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      cabinImage.isNotEmpty
                          ? cabinImage
                          : "https://images.unsplash.com/photo-1590439471364-192aa70c7c53?q=80&w=600&auto=format&fit=crop",
                      fit: BoxFit.cover,
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0xFF121212)],
                          stops: [0.6, 1.0],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 24,
                      left: 24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatusBadge(status, primaryColor),
                          const SizedBox(height: 12),
                          Text(
                            cabinName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Plus Jakarta Sans',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Details List
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle("Session Details"),
                    const SizedBox(height: 16),
                    _buildDetailCard([
                      _buildDetailRow(
                        Icons.calendar_today_outlined,
                        "Date",
                        DateFormat('EEEE, MMM d, yyyy').format(bookingDate),
                      ),
                      _buildDivider(),
                      _buildDetailRow(
                        Icons.access_time,
                        "Time",
                        booking['startTime'] ?? "--:--",
                      ),
                      _buildDivider(),
                      _buildDetailRow(
                        Icons.timer_outlined,
                        "Duration",
                        "${booking['minutes'] ?? 20} Minutes",
                      ),
                    ]),

                    const SizedBox(height: 32),
                    _buildSectionTitle("Studio Information"),
                    const SizedBox(height: 16),
                    _buildDetailCard([
                      _buildDetailRow(
                        Icons.location_on_outlined,
                        "Location",
                        "Ki Sun Premium Studio",
                      ),
                      _buildDivider(),
                      _buildDetailRow(
                        Icons.meeting_room_outlined,
                        "Cabin",
                        cabinName,
                      ),
                    ]),

                    const SizedBox(height: 48),

                    // Actions (Back Button Only)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Get.back(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Back to Dashboard",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildDetailCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.neonSun, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Divider(color: Colors.white.withValues(alpha: 0.05), height: 1),
    );
  }
}
