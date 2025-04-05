import 'package:flutter/material.dart';

/// Central location for all application colors
class AppColors {
  // Primary palette
  static const Color primaryBlue = Color(0xFF61AFEF);
  static const Color accentGreen = Color(0xFF98C379);
  static const Color accentPurple = Color(0xFFC678DD);

  // Background colors
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF1E2127);

  // Card colors
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF282C34);

  // Text colors
  static const Color textDark = Color(0xFF2C3E50);
  static const Color textLight = Color(0xFFABB2BF);

  // Semantic colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  // State colors
  static const Color disabledLight = Color(0xFFE0E0E0);
  static const Color disabledDark = Color(0xFF424242);

  // Create a shade of a color with specified opacity
  static Color withOpacity(Color color, double opacity) =>
      color.withAlpha((opacity.clamp(0.0, 1.0) * 255).round());

  // Create a lighter version of a color
  static Color lighter(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  // Create a darker version of a color
  static Color darker(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  // --- Retro Themes ---

  // Green Monochrome (Classic Terminal)
  static const Color retroGreenDark =
      Color(0xFF0D1A0F); // Very dark green background
  static const Color retroGreenMedium =
      Color(0xFF1A3A1F); // Slightly lighter green for cards/accents
  static const Color retroGreenLight =
      Color(0xFF33FF33); // Bright green text/foreground
  static const Color retroGreenDim =
      Color(0xFF228B22); // Dimmer green for secondary text

  // Amber Monochrome (VT220 style)
  static const Color retroAmberDark =
      Color(0xFF1A1000); // Very dark brown/amber background
  static const Color retroAmberMedium =
      Color(0xFF3A2A0A); // Slightly lighter amber for cards/accents
  static const Color retroAmberLight =
      Color(0xFFFFB000); // Bright amber text/foreground
  static const Color retroAmberDim =
      Color(0xFFD2691E); // Dimmer amber/brown for secondary text

  // ASCII Art Theme (Simple Black & White)
  static const Color asciiBlack = Color(0xFF000000);
  static const Color asciiWhite = Color(0xFFFFFFFF);
  static const Color asciiGrey = Color(0xFF888888); // Optional grey for accents
}
