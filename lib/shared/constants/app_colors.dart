import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF050505);
  static const Color surface = Color(0xFF1A1A1A);
  static const Color white = Color(0xFFFFFFFF);

  // Neon Accents
  static const Color neonSun = Color(0xFFFFD700); // Gold
  static const Color neonUV = Color(0xFFD500F9); // Purple
  static const Color neonBlue = Color(0xFF00E5FF); // Cyan

  static const Color error = Color(0xFFFF5252);
  static const Color success = Color(0xFF69F0AE);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [neonSun, Color(0xFFFF8F00)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
