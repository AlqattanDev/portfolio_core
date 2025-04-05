import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_controller.g.dart';

// Enum representing the available themes (copied from theme_notifier.dart)
enum PortfolioTheme { light, dark, retroGreen, retroAmber, ascii, system }

const String _themePrefKey = 'portfolioTheme'; // Key for SharedPreferences
const PortfolioTheme _defaultTheme = PortfolioTheme.dark; // Default theme

@riverpod
class ThemeController extends _$ThemeController {
  @override
  Future<PortfolioTheme> build() async {
    // Load the saved theme preference asynchronously
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString(_themePrefKey);
    if (themeName != null) {
      try {
        return PortfolioTheme.values.firstWhere(
          (e) => e.name == themeName,
          orElse: () => _defaultTheme,
        );
      } catch (e) {
        // Handle potential errors during enum parsing
        return _defaultTheme;
      }
    }
    return _defaultTheme; // Return default if no preference is saved
  }

  Future<void> setTheme(PortfolioTheme theme) async {
    // Don't update if the theme is the same
    if (state.valueOrNull == theme) return;

    // Update the state optimistically
    state = AsyncValue.data(theme);

    // Persist the new theme preference
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themePrefKey, theme.name);
    } catch (e) {
      // If saving fails, revert the state and report error
      state = AsyncError(e, StackTrace.current);
      // Optionally, reload the previous state from prefs if needed
      // state = AsyncValue.data(await build()); // Re-fetch to be safe
      print('Error saving theme preference: $e');
    }
  }

  // Helper getter for ThemeMode based on the current state
  ThemeMode get themeMode {
    final currentTheme = state.valueOrNull ?? _defaultTheme;
    switch (currentTheme) {
      case PortfolioTheme.light:
        return ThemeMode.light;
      case PortfolioTheme.dark:
      case PortfolioTheme.retroGreen:
      case PortfolioTheme.retroAmber:
      case PortfolioTheme.ascii:
        return ThemeMode.dark; // Treat custom/dark themes as dark mode base
      case PortfolioTheme.system:
      default:
        return ThemeMode.system;
    }
  }
}
