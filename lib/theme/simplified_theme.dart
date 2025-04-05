import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  // Border radius (Moved to PortfolioThemeExtension)

  // Get Light Theme
  // Define standard padding/spacing values
  static const EdgeInsets _screenPadding = EdgeInsets.all(24.0);
  static const EdgeInsets _contentPadding = EdgeInsets.all(16.0);
  static const EdgeInsets _smallPadding = EdgeInsets.all(8.0);
  static const double _itemSpacing = 16.0;

  static ThemeData getLightTheme() {
    const double borderRadius = 12.0; // Define locally for theme creation
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryBlue,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.light,
        secondary: accentGreen,
      ),
      scaffoldBackgroundColor: backgroundLight,
      cardColor: cardLight,
      textTheme: getTextTheme(false),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        color: cardLight,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: cardLight,
        iconTheme: const IconThemeData(color: primaryBlue),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: primaryBlue,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          minimumSize: const Size(100, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: primaryBlue.withAlpha(((0.15) * 255).round()),
        labelStyle: GoogleFonts.inter(
          color: primaryBlue,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: primaryBlue,
        unselectedLabelColor: textDark.withAlpha(((0.7) * 255).round()),
        indicatorColor: primaryBlue,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
        ),
      ),
      extensions: const <ThemeExtension<dynamic>>[
        PortfolioThemeExtension(
          cardBorderRadius: borderRadius,
          screenPadding: _screenPadding,
          contentPadding: _contentPadding,
          smallPadding: _smallPadding,
          itemSpacing: _itemSpacing,
        ),
      ],
    );
  }

  // Get Dark Theme
  static ThemeData getDarkTheme() {
    const double borderRadius = 12.0; // Define locally for theme creation
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryBlue,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        brightness: Brightness.dark,
        secondary: accentPurple,
      ),
      scaffoldBackgroundColor: backgroundDark,
      cardColor: cardDark,
      textTheme: getTextTheme(true),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        color: cardDark,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: cardDark,
        iconTheme: const IconThemeData(color: primaryBlue),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: primaryBlue,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          minimumSize: const Size(100, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: primaryBlue.withAlpha(((0.15) * 255).round()),
        labelStyle: GoogleFonts.inter(
          color: primaryBlue,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: primaryBlue,
        unselectedLabelColor: textLight.withAlpha(((0.7) * 255).round()),
        indicatorColor: primaryBlue,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
        ),
      ),
      extensions: const <ThemeExtension<dynamic>>[
        PortfolioThemeExtension(
          cardBorderRadius: borderRadius,
          screenPadding: _screenPadding,
          contentPadding: _contentPadding,
          smallPadding: _smallPadding,
          itemSpacing: _itemSpacing,
        ),
      ],
    );
  }

  // Text Styles
  static TextTheme getTextTheme(bool isDark) {
    final Color textColor = isDark ? textLight : textDark;

    return TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 42,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        color: isDark ? primaryBlue : primaryBlue,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 34,
        fontWeight: FontWeight.bold,
        color: isDark ? primaryBlue : primaryBlue,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: isDark ? primaryBlue : primaryBlue,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: isDark ? accentPurple : accentGreen,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: isDark ? accentGreen : primaryBlue,
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
