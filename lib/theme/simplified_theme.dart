import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_core/theme/colors.dart'; // Import AppColors
import 'package:portfolio_core/theme/spacing.dart';

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
  // Default Theme Colors (kept for reference, but config drives the main themes)
  static const Color primaryBlue = AppColors.primaryBlue;
  static const Color accentGreen = AppColors.accentGreen;
  static const Color accentPurple = AppColors.accentPurple;
  static const Color backgroundLight = AppColors.backgroundLight;
  static const Color backgroundDark = AppColors.backgroundDark;
  static const Color cardLight = AppColors.cardLight;
  static const Color cardDark = AppColors.cardDark;
  static const Color textDark = AppColors.textDark;
  static const Color textLight = AppColors.textLight;

  // Theme configuration (Used for Light/Dark themes)
  static ThemeConfiguration currentConfig = const ThemeConfiguration();

  // Method to update theme configuration
  static void updateThemeConfiguration(ThemeConfiguration newConfig) {
    currentConfig = newConfig;
  }

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
      textTheme: _getTextTheme(false, GoogleFonts.inter), // Use default font
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
        backgroundColor:
            currentConfig.primaryColor.withAlpha(((0.15) * 255).round()),
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
        unselectedLabelColor:
            currentConfig.textDarkColor.withAlpha(((0.7) * 255).round()),
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
      textTheme: _getTextTheme(true, GoogleFonts.inter), // Use default font
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
        backgroundColor:
            currentConfig.primaryColor.withAlpha(((0.15) * 255).round()),
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
        unselectedLabelColor:
            currentConfig.textLightColor.withAlpha(((0.7) * 255).round()),
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

  // --- Retro Themes ---

  static ThemeData getRetroGreenTheme() {
    const primary = AppColors.retroGreenLight;
    const background = AppColors.retroGreenDark;
    const card = AppColors.retroGreenMedium;
    const text = AppColors.retroGreenLight;
    const textDim = AppColors.retroGreenDim;
    final textTheme = _getRetroTextTheme(text, textDim, primary);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark, // Retro themes are typically dark
      primaryColor: primary,
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: primary, // Use primary for secondary in monochrome
        background: background,
        surface: card, // Use card color for surface
        onPrimary: background, // Text on primary buttons
        onSecondary: background,
        onBackground: text,
        onSurface: text, // Text on cards/surfaces
        error: AppColors.error, // Keep semantic colors distinct
        onError: AppColors.asciiWhite,
      ),
      scaffoldBackgroundColor: background,
      cardColor: card,
      textTheme: textTheme,
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero), // Sharp corners
        color: card,
        margin: EdgeInsets.zero,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false, // Retro often left-aligned
        elevation: 0,
        backgroundColor: background, // Match background
        foregroundColor: text, // Icon/Title color
        titleTextStyle: textTheme.titleLarge,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primary,
          foregroundColor: background, // Text on button
          minimumSize: const Size(80, 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          textStyle: textTheme.labelLarge?.copyWith(color: background),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          textStyle: textTheme.labelLarge,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: card,
        labelStyle: textTheme.labelSmall?.copyWith(color: textDim),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4)), // Slightly rounded chip
        side: BorderSide(color: textDim),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: primary,
        unselectedLabelColor: textDim,
        indicatorColor: primary,
        indicatorSize: TabBarIndicatorSize.label, // Underline label only
        labelStyle: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        unselectedLabelStyle: textTheme.bodyMedium,
      ),
      dividerTheme: DividerThemeData(color: textDim, thickness: 1),
      extensions: <ThemeExtension<dynamic>>[
        // Use default spacing extension for now
        PortfolioThemeExtension(
          cardBorderRadius: 0, // Sharp corners
          screenPadding: currentConfig.screenPadding,
          contentPadding: currentConfig.contentPadding,
          smallPadding: currentConfig.smallPadding,
          itemSpacing: currentConfig.itemSpacing,
        ),
      ],
    );
  }

  static ThemeData getRetroAmberTheme() {
    const primary = AppColors.retroAmberLight;
    const background = AppColors.retroAmberDark;
    const card = AppColors.retroAmberMedium;
    const text = AppColors.retroAmberLight;
    const textDim = AppColors.retroAmberDim;
    final textTheme = _getRetroTextTheme(text, textDim, primary);

    // Mostly reuse green theme structure, just swap colors
    return getRetroGreenTheme().copyWith(
      primaryColor: primary,
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: primary,
        background: background,
        surface: card,
        onPrimary: background,
        onSecondary: background,
        onBackground: text,
        onSurface: text,
        error: AppColors.error,
        onError:
            AppColors.asciiBlack, // Black text on error might be better here
      ),
      scaffoldBackgroundColor: background,
      cardColor: card,
      textTheme: textTheme,
      cardTheme: getRetroGreenTheme().cardTheme.copyWith(color: card),
      appBarTheme: getRetroGreenTheme().appBarTheme.copyWith(
            backgroundColor: background,
            foregroundColor: text,
            titleTextStyle: textTheme.titleLarge,
          ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primary,
          foregroundColor: background,
          minimumSize: const Size(80, 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          textStyle: textTheme.labelLarge?.copyWith(color: background),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          textStyle: textTheme.labelLarge,
        ),
      ),
      chipTheme: getRetroGreenTheme().chipTheme.copyWith(
            backgroundColor: card,
            labelStyle: textTheme.labelSmall?.copyWith(color: textDim),
            side: BorderSide(color: textDim),
          ),
      tabBarTheme: getRetroGreenTheme().tabBarTheme.copyWith(
            labelColor: primary,
            unselectedLabelColor: textDim,
            indicatorColor: primary,
            labelStyle:
                textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            unselectedLabelStyle: textTheme.bodyMedium,
          ),
      dividerTheme: DividerThemeData(color: textDim, thickness: 1),
    );
  }

  static ThemeData getAsciiTheme() {
    const primary = AppColors.asciiWhite; // White is primary action/text
    const background = AppColors.asciiBlack;
    const card = AppColors.asciiBlack; // Cards same as background
    const text = AppColors.asciiWhite;
    const textDim = AppColors.asciiGrey;
    final textTheme =
        _getRetroTextTheme(text, textDim, primary); // Use retro font

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primary,
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: primary, // Simple B&W
        background: background,
        surface: card,
        onPrimary: background, // Black text on white buttons
        onSecondary: background,
        onBackground: text,
        onSurface: text,
        error: AppColors.error, // Keep semantic colors distinct if needed
        onError: AppColors.asciiWhite,
      ),
      scaffoldBackgroundColor: background,
      cardColor: card,
      textTheme: textTheme,
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(
              color: textDim, width: 1), // Add border to distinguish cards
        ),
        color: card,
        margin: const EdgeInsets.symmetric(vertical: 4), // Add some margin
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        backgroundColor: background,
        foregroundColor: text,
        titleTextStyle: textTheme.titleLarge,
        shape: Border(
            bottom: BorderSide(color: textDim, width: 1)), // Separator line
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primary,
          foregroundColor: background,
          minimumSize: const Size(80, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: textDim, width: 1), // Bordered buttons
          ),
          textStyle: textTheme.labelLarge?.copyWith(color: background),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          textStyle: textTheme.labelLarge,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: background,
        labelStyle: textTheme.labelSmall?.copyWith(color: textDim),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: textDim, width: 1), // Bordered chip
        ),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: primary,
        unselectedLabelColor: textDim,
        indicatorColor: primary,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        unselectedLabelStyle: textTheme.bodyMedium,
      ),
      dividerTheme: DividerThemeData(color: textDim, thickness: 1),
      extensions: <ThemeExtension<dynamic>>[
        PortfolioThemeExtension(
          cardBorderRadius: 0,
          screenPadding: currentConfig.screenPadding,
          contentPadding: currentConfig.contentPadding,
          smallPadding: currentConfig.smallPadding,
          itemSpacing: currentConfig.itemSpacing,
        ),
      ],
    );
  }

  // Text Styles Helper for Light/Dark themes
  static TextTheme _getTextTheme(
      bool isDark,
      TextStyle Function({
        TextStyle? textStyle,
        Color? color,
        Color? backgroundColor,
        double? fontSize,
        FontWeight? fontWeight,
        FontStyle? fontStyle,
        double? letterSpacing,
        double? wordSpacing,
        TextBaseline? textBaseline,
        double? height,
        Locale? locale,
        Paint? foreground,
        Paint? background,
        List<Shadow>? shadows,
        List<FontFeature>? fontFeatures,
        TextDecoration? decoration,
        Color? decorationColor,
        TextDecorationStyle? decorationStyle,
        double? decorationThickness,
      }) fontFactory) {
    final Color textColor =
        isDark ? currentConfig.textLightColor : currentConfig.textDarkColor;
    final Color accentColor = currentConfig.primaryColor;
    final Color secondaryColor = isDark
        ? currentConfig.secondaryDarkColor
        : currentConfig.secondaryLightColor;

    return TextTheme(
      displayLarge: fontFactory(
        fontSize: 42,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        color: accentColor,
      ),
      displayMedium: fontFactory(
        fontSize: 34,
        fontWeight: FontWeight.bold,
        color: accentColor,
      ),
      displaySmall: fontFactory(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: accentColor,
      ),
      headlineLarge: fontFactory(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: secondaryColor,
      ),
      headlineMedium: fontFactory(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleLarge: fontFactory(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: isDark ? secondaryColor : accentColor,
      ),
      bodyLarge: fontFactory(
        fontSize: 18,
        height: 1.6,
        color: textColor,
      ),
      bodyMedium: fontFactory(
        fontSize: 16,
        height: 1.5,
        color: textColor,
      ),
      bodySmall: fontFactory(
        fontSize: 14,
        height: 1.5,
        color: textColor.withAlpha(((0.8) * 255).round()),
      ),
      // Add label styles if needed, e.g., for buttons
      labelLarge: fontFactory(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: textColor, // Default label color
      ),
      labelMedium: fontFactory(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      labelSmall: fontFactory(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: textColor.withAlpha(((0.8) * 255).round()),
      ),
    );
  }

  // Text Styles Helper for Retro themes (using VT323)
  static TextTheme _getRetroTextTheme(
      Color mainColor, Color dimColor, Color accentColor) {
    final fontFactory = GoogleFonts.vt323; // Use VT323 font

    // Adjust sizes for retro feel (often larger base size)
    const double baseSize = 18;

    return TextTheme(
      displayLarge: fontFactory(
        fontSize: baseSize + 16, // Larger display
        fontWeight: FontWeight.normal, // Retro fonts often not bolded heavily
        color: accentColor,
      ),
      displayMedium: fontFactory(
        fontSize: baseSize + 12,
        fontWeight: FontWeight.normal,
        color: accentColor,
      ),
      displaySmall: fontFactory(
        fontSize: baseSize + 8,
        fontWeight: FontWeight.normal,
        color: accentColor,
      ),
      headlineLarge: fontFactory(
        fontSize: baseSize + 6,
        fontWeight: FontWeight.normal,
        color: mainColor, // Headlines in main color
      ),
      headlineMedium: fontFactory(
        fontSize: baseSize + 4,
        fontWeight: FontWeight.normal,
        color: mainColor,
      ),
      titleLarge: fontFactory(
        // Often used for AppBar titles
        fontSize: baseSize + 2,
        fontWeight: FontWeight.normal,
        color: mainColor,
      ),
      bodyLarge: fontFactory(
        fontSize: baseSize + 2,
        height: 1.4, // Adjust line height for blocky fonts
        color: mainColor,
      ),
      bodyMedium: fontFactory(
        // Default text
        fontSize: baseSize,
        height: 1.4,
        color: mainColor,
      ),
      bodySmall: fontFactory(
        // Secondary text
        fontSize: baseSize - 2,
        height: 1.4,
        color: dimColor,
      ),
      labelLarge: fontFactory(
        // Button text
        fontSize: baseSize,
        fontWeight: FontWeight.normal,
        color: mainColor, // Will be overridden by button theme foreground color
      ),
      labelMedium: fontFactory(
        fontSize: baseSize - 2,
        fontWeight: FontWeight.normal,
        color: dimColor,
      ),
      labelSmall: fontFactory(
        // Chip text
        fontSize: baseSize - 4,
        fontWeight: FontWeight.normal,
        color: dimColor,
      ),
    );
  }
}

// --- Theme Extension ---
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

  /// Get standard vertical spacing as a SizedBox
  SizedBox get verticalSpacing => SizedBox(height: itemSpacing);

  /// Get standard horizontal spacing as a SizedBox
  SizedBox get horizontalSpacing => SizedBox(width: itemSpacing);

  /// Get small vertical spacing as a SizedBox
  SizedBox get smallVerticalSpacing => SizedBox(height: AppSpacing.small);

  /// Get small horizontal spacing as a SizedBox
  SizedBox get smallHorizontalSpacing => SizedBox(width: AppSpacing.small);

  /// Get large vertical spacing as a SizedBox
  SizedBox get largeVerticalSpacing => SizedBox(height: AppSpacing.large);

  /// Get large horizontal spacing as a SizedBox
  SizedBox get largeHorizontalSpacing => SizedBox(width: AppSpacing.large);

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
