import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/constants/app_colors.dart';
import '../controllers/skin_analysis_controller.dart';

class SkinAnalysisWizardView extends GetView<SkinAnalysisController> {
  const SkinAnalysisWizardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181610), // Deep Dark Background
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100,
            left: -100,
            child: _buildGlow(300, AppColors.neonSun.withValues(alpha: 0.1)),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: _buildGlow(300, Colors.deepOrange.withValues(alpha: 0.1)),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top Navigation
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: controller.previousStep,
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white70,
                        ),
                      ),
                      Obx(
                        () => Text(
                          "STEP ${controller.currentStep.value + 1} OF ${controller.questions.length}",
                          style: TextStyle(
                            color: AppColors.neonSun,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48), // Spacer
                    ],
                  ),
                ),

                // Progress Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Obx(() {
                    double progress =
                        (controller.currentStep.value + 1) /
                        controller.questions.length;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Analysis in progress",
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.white10,
                            color: AppColors.neonSun,
                            minHeight: 6,
                          ),
                        ),
                      ],
                    );
                  }),
                ),

                const SizedBox(height: 32),

                // Quiz Content
                Expanded(
                  child: Obx(() {
                    final question =
                        controller.questions[controller.currentStep.value];
                    final options = question['options'] as List<dynamic>;

                    return ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      children: [
                        Text(
                          question['question'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Options List
                        ...List.generate(options.length, (index) {
                          final option = options[index];
                          final isSelected =
                              controller.selectedAnswers[controller
                                  .currentStep
                                  .value] ==
                              index;

                          return GestureDetector(
                            onTap: () {
                              controller.selectedAnswers[controller
                                      .currentStep
                                      .value] =
                                  index;
                              controller.selectedAnswers
                                  .refresh(); // Force update
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.neonSun.withValues(alpha: 0.1)
                                    : Colors.white.withValues(alpha: 0.04),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.neonSun
                                      : Colors.white10,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Radio Circle
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.neonSun
                                            : Colors.white38,
                                        width: 2,
                                      ),
                                    ),
                                    child: isSelected
                                        ? Center(
                                            child: Container(
                                              width: 12,
                                              height: 12,
                                              decoration: const BoxDecoration(
                                                color: AppColors.neonSun,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      option['text'] as String,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  }),
                ),

                // Bottom Action Button
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.nextStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.neonSun,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 8,
                        ),
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.black,
                              )
                            : const Text(
                                "Next Step",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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

  Widget _buildGlow(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
          radius: 0.6,
        ),
      ),
    );
  }
}
