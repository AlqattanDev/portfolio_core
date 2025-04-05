import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Configuration class for theme properties
class ThemeConfiguration {
  final Color primaryColor;
  final Color secondaryLightColor;
  final Color secondaryDarkColor;
  final Color backgroundLightColor;
  final Color backgroundDarkColor;
  final Color cardLightColor;
  final Color cardDarkColor;
  final Color textDarkColor;
  final Color textLightColor;
  final double cardBorderRadius;
  final EdgeInsets screenPadding;
  final EdgeInsets contentPadding;
  final EdgeInsets smallPadding;
  final double itemSpacing;

  const ThemeConfiguration({
    this.primaryColor = SimplifiedTheme.primaryBlue,
    this.secondaryLightColor = SimplifiedTheme.accentGreen,
    this.secondaryDarkColor = SimplifiedTheme.accentPurple,
    this.backgroundLightColor = SimplifiedTheme.backgroundLight,
    this.backgroundDarkColor = SimplifiedTheme.backgroundDark,
    this.cardLightColor = SimplifiedTheme.cardLight,
    this.cardDarkColor = SimplifiedTheme.cardDark,
    this.textDarkColor = SimplifiedTheme.textDark,
    this.textLightColor = SimplifiedTheme.textLight,
    this.cardBorderRadius = 12.0,
    this.screenPadding = const EdgeInsets.all(24.0),
    this.contentPadding = const EdgeInsets.all(16.0),
    this.smallPadding = const EdgeInsets.all(8.0),
    this.itemSpacing = 16.0,
  });

  // Create a copy with some properties changed
  ThemeConfiguration copyWith({
    Color? primaryColor,
    Color? secondaryLightColor,
    Color? secondaryDarkColor,
    Color? backgroundLightColor,
    Color? backgroundDarkColor,
    Color? cardLightColor,
    Color? cardDarkColor,
    Color? textDarkColor,
    Color? textLightColor,
    double? cardBorderRadius,
    EdgeInsets? screenPadding,
    EdgeInsets? contentPadding,
    EdgeInsets? smallPadding,
    double? itemSpacing,
  }) {
    return ThemeConfiguration(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryLightColor: secondaryLightColor ?? this.secondaryLightColor,
      secondaryDarkColor: secondaryDarkColor ?? this.secondaryDarkColor,
      backgroundLightColor: backgroundLightColor ?? this.backgroundLightColor,
      backgroundDarkColor: backgroundDarkColor ?? this.backgroundDarkColor,
      cardLightColor: cardLightColor ?? this.cardLightColor,
      cardDarkColor: cardDarkColor ?? this.cardDarkColor,
      textDarkColor: textDarkColor ?? this.textDarkColor,
      textLightColor: textLightColor ?? this.textLightColor,
      cardBorderRadius: cardBorderRadius ?? this.cardBorderRadius,
      screenPadding: screenPadding ?? this.screenPadding,
      contentPadding: contentPadding ?? this.contentPadding,
      smallPadding: smallPadding ?? this.smallPadding,
      itemSpacing: itemSpacing ?? this.itemSpacing,
    );
  }
}

/// A simplified theme class for the portfolio
class SimplifiedTheme {
  // Primary colors
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

  // Theme configuration
  static ThemeConfiguration currentConfig = const ThemeConfiguration();

  // Method to update theme configuration
  static void updateThemeConfiguration(ThemeConfiguration newConfig) {
    currentConfig = newConfig;
  }

  // Define standard padding/spacing values
  static const EdgeInsets _screenPadding = EdgeInsets.all(24.0);
  static const EdgeInsets _contentPadding = EdgeInsets.all(16.0);
  static const EdgeInsets _smallPadding = EdgeInsets.all(8.0);
  static const double _itemSpacing = 16.0;

  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: currentConfig.primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: currentConfig.primaryColor,
        brightness: Brightness.light,
        secondary: currentConfig.secondaryLightColor,
      ),
      scaffoldBackgroundColor: currentConfig.backgroundLightColor,
      cardColor: currentConfig.cardLightColor,
      textTheme: getTextTheme(false),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(currentConfig.cardBorderRadius),
        ),
        color: currentConfig.cardLightColor,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: currentConfig.cardLightColor,
        iconTheme: IconThemeData(color: currentConfig.primaryColor),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: currentConfig.primaryColor,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          minimumSize: const Size(100, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(currentConfig.cardBorderRadius),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: currentConfig.primaryColor.withAlpha(((0.15) * 255).round()),
        labelStyle: GoogleFonts.inter(
          color: currentConfig.primaryColor,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: currentConfig.primaryColor,
        unselectedLabelColor: currentConfig.textDarkColor.withAlpha(((0.7) * 255).round()),
        indicatorColor: currentConfig.primaryColor,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[
        PortfolioThemeExtension(
          cardBorderRadius: currentConfig.cardBorderRadius,
          screenPadding: currentConfig.screenPadding,
          contentPadding: currentConfig.contentPadding,
          smallPadding: currentConfig.smallPadding,
          itemSpacing: currentConfig.itemSpacing,
        ),
      ],
    );
  }

  // Get Dark Theme
  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: currentConfig.primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: currentConfig.primaryColor,
        brightness: Brightness.dark,
        secondary: currentConfig.secondaryDarkColor,
      ),
      scaffoldBackgroundColor: currentConfig.backgroundDarkColor,
      cardColor: currentConfig.cardDarkColor,
      textTheme: getTextTheme(true),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(currentConfig.cardBorderRadius),
        ),
        color: currentConfig.cardDarkColor,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: currentConfig.cardDarkColor,
        iconTheme: IconThemeData(color: currentConfig.primaryColor),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: currentConfig.primaryColor,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          minimumSize: const Size(100, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(currentConfig.cardBorderRadius),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: currentConfig.primaryColor.withAlpha(((0.15) * 255).round()),
        labelStyle: GoogleFonts.inter(
          color: currentConfig.primaryColor,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: currentConfig.primaryColor,
        unselectedLabelColor: currentConfig.textLightColor.withAlpha(((0.7) * 255).round()),
        indicatorColor: currentConfig.primaryColor,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[
        PortfolioThemeExtension(
          cardBorderRadius: currentConfig.cardBorderRadius,
          screenPadding: currentConfig.screenPadding,
          contentPadding: currentConfig.contentPadding,
          smallPadding: currentConfig.smallPadding,
          itemSpacing: currentConfig.itemSpacing,
        ),
      ],
    );
  }

  // Text Styles
  static TextTheme getTextTheme(bool isDark) {
    final Color textColor = isDark ? currentConfig.textLightColor : currentConfig.textDarkColor;
    final Color accentColor = currentConfig.primaryColor;
    final Color secondaryColor = isDark ? currentConfig.secondaryDarkColor : currentConfig.secondaryLightColor;

    return TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 42,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        color: accentColor,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 34,
        fontWeight: FontWeight.bold,
        color: accentColor,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: accentColor,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: secondaryColor,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: isDark ? secondaryColor : accentColor,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 18,
        height: 1.6,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 16,
        height: 1.5,
        color: textColor,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 14,
        height: 1.5,
        color: textColor.withAlpha(((0.8) * 255).round()),
      ),
    );
  }
}

// --- Theme Extension ---

/// Defines custom theme properties for the portfolio app.
class PortfolioThemeExtension extends ThemeExtension<PortfolioThemeExtension> {
  const PortfolioThemeExtension({
    required this.cardBorderRadius,
    required this.screenPadding,
    required this.contentPadding,
    required this.smallPadding,
    required this.itemSpacing,
  });

  final double cardBorderRadius;
  final EdgeInsets screenPadding;
  final EdgeInsets contentPadding;
  final EdgeInsets smallPadding;
  final double itemSpacing;

  @override
  PortfolioThemeExtension copyWith({
    double? cardBorderRadius,
    EdgeInsets? screenPadding,
    EdgeInsets? contentPadding,
    EdgeInsets? smallPadding,
    double? itemSpacing,
  }) {
    return PortfolioThemeExtension(
      cardBorderRadius: cardBorderRadius ?? this.cardBorderRadius,
      screenPadding: screenPadding ?? this.screenPadding,
      contentPadding: contentPadding ?? this.contentPadding,
      smallPadding: smallPadding ?? this.smallPadding,
      itemSpacing: itemSpacing ?? this.itemSpacing,
    );
  }

  @override
  PortfolioThemeExtension lerp(
      ThemeExtension<PortfolioThemeExtension>? other, double t) {
    if (other is! PortfolioThemeExtension) {
      return this;
    }
    return PortfolioThemeExtension(
      cardBorderRadius:
          lerpDouble(cardBorderRadius, other.cardBorderRadius, t) ??
              cardBorderRadius,
      screenPadding: EdgeInsets.lerp(screenPadding, other.screenPadding, t) ??
          screenPadding,
      contentPadding:
          EdgeInsets.lerp(contentPadding, other.contentPadding, t) ??
              contentPadding,
      smallPadding:
          EdgeInsets.lerp(smallPadding, other.smallPadding, t) ?? smallPadding,
      itemSpacing: lerpDouble(itemSpacing, other.itemSpacing, t) ?? itemSpacing,
    );
  }

  // Optional: Add toString for debugging
  @override
  String toString() =>
      'PortfolioThemeExtension(cardBorderRadius: $cardBorderRadius, screenPadding: $screenPadding, contentPadding: $contentPadding, smallPadding: $smallPadding, itemSpacing: $itemSpacing)';
}
