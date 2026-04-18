import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/membership_controller.dart';
import '../../../shared/constants/app_colors.dart';

class MembershipPlansView extends GetView<MembershipController> {
  const MembershipPlansView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Membership Plans")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.neonSun),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: controller.plans.length,
          itemBuilder: (context, index) {
            final plan = controller.plans[index];
            return _buildPlanCard(plan);
          },
        );
      }),
    );
  }

  Widget _buildPlanCard(dynamic plan) {
    final benefits = (plan['benefits'] as List).cast<String>();

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: plan['id'] == 'unlimited'
              ? AppColors.neonSun
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                plan['name'],
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${plan['price']}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonSun,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Text(
            "Monthly",
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const Divider(height: 30, color: Colors.white24),

          ...benefits
              .map(
                (b) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: AppColors.neonSun,
                      ),
                      const SizedBox(width: 8),
                      Text(b, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              )
              .toList(),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: Obx(
              () => ElevatedButton(
                onPressed: controller.isPublishing.value
                    ? null
                    : () => controller.subscribe(plan['id'], plan['name']),
                style: ElevatedButton.styleFrom(
                  backgroundColor: plan['id'] == 'unlimited'
                      ? AppColors.neonSun
                      : Colors.white24,
                  foregroundColor: plan['id'] == 'unlimited'
                      ? Colors.black
                      : Colors.white,
                ),
                child: controller.isPublishing.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("SUBSCRIBE NOW"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
