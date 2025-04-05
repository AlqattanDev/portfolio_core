import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Enum representing the available themes in the application.
enum PortfolioTheme {
  light,
  dark,
  retroGreen,
  retroAmber,
  ascii,
  system // Keep system option if desired, though retro themes might override it
}

class ThemeNotifier extends ChangeNotifier {
  static const String _themePrefKey = 'portfolioTheme'; // Updated key
  PortfolioTheme _currentTheme = PortfolioTheme.dark; // Default theme

  ThemeNotifier() {
    _loadCurrentTheme();
  }

  PortfolioTheme get currentTheme => _currentTheme;

  /// Provides the corresponding ThemeMode for system brightness detection.
  ThemeMode get themeMode {
    switch (_currentTheme) {
      case PortfolioTheme.light:
        return ThemeMode.light;
      case PortfolioTheme.dark:
      case PortfolioTheme.retroGreen:
      case PortfolioTheme.retroAmber:
      case PortfolioTheme.ascii:
        return ThemeMode.dark; // Treat all custom/dark themes as dark mode base
      case PortfolioTheme.system:
      default:
        return ThemeMode.system;
    }
  }

  Future<void> _loadCurrentTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString(_themePrefKey);
    if (themeName != null) {
      try {
        _currentTheme = PortfolioTheme.values.firstWhere(
          (e) => e.name == themeName,
          orElse: () => PortfolioTheme.dark, // Default if name is invalid
        );
      } catch (e) {
        _currentTheme = PortfolioTheme.dark; // Default on error
      }
    } else {
      _currentTheme = PortfolioTheme.dark; // Default if key not found
    }
    // No need to notify on initial load
  }

  Future<void> setTheme(PortfolioTheme theme) async {
    if (_currentTheme == theme) return; // No change

    _currentTheme = theme;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themePrefKey, theme.name); // Save theme name
  }

  // Optional: Keep a cycle function or provide specific setters if needed
  // void cycleTheme() {
  //   final currentIndex = PortfolioTheme.values.indexOf(_currentTheme);
  //   final nextIndex = (currentIndex + 1) % PortfolioTheme.values.length;
  //   setTheme(PortfolioTheme.values[nextIndex]);
  // }
}
