import 'package:flutter/material.dart';
import 'package:portfolio_core/data/portfolio_data.dart'; // Import PortfolioData
import 'package:portfolio_core/services/auth_service.dart';
import 'package:portfolio_core/services/blog_service.dart';
// import 'package:portfolio_core/screens/tabbed_portfolio_screen.dart'; // No longer directly used here
import 'package:portfolio_core/widgets/auth_wrapper.dart'; // Import AuthWrapper
import 'package:portfolio_core/theme/simplified_theme.dart';
import 'package:portfolio_core/theme/theme_notifier.dart'; // Import ThemeNotifier
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:portfolio_core/firebase_options.dart'; // Import generated options
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

Future<void> main() async {
  // Make main async
  WidgetsFlutterBinding.ensureInitialized(); // Ensure bindings are initialized
  await Firebase.initializeApp(
    // Initialize Firebase
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize ThemeNotifier and load initial theme
  // Ensure SharedPreferences is initialized before creating ThemeNotifier
  await SharedPreferences.getInstance();
  final themeNotifier = ThemeNotifier();
  // Wait for the initial theme mode to be loaded
  themeNotifier.themeMode;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        // BlogService depends on AuthService
        ProxyProvider<AuthService, BlogService>(
          update: (_, authService, previousBlogService) =>
              BlogService(authService),
          // We only need to create it once and provide the AuthService instance
        ),
        // Provide PortfolioData and load data
        ChangeNotifierProvider(
          create: (_) => PortfolioData()..loadPortfolioData(),
        ),
        // Provide the ThemeNotifier instance
        ChangeNotifierProvider.value(value: themeNotifier),
      ],
      child: const PortfolioApp(),
    ),
  );
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Consume the ThemeNotifier to get the current theme
    final themeNotifier = context.watch<ThemeNotifier>();

    // Determine the active dark/retro theme based on the notifier
    final ThemeData activeDarkTheme;
    switch (themeNotifier.currentTheme) {
      case PortfolioTheme.dark:
        activeDarkTheme = SimplifiedTheme.getDarkTheme();
        break;
      case PortfolioTheme.retroGreen:
        activeDarkTheme = SimplifiedTheme.getRetroGreenTheme();
        break;
      case PortfolioTheme.retroAmber:
        activeDarkTheme = SimplifiedTheme.getRetroAmberTheme();
        break;
      case PortfolioTheme.ascii:
        activeDarkTheme = SimplifiedTheme.getAsciiTheme();
        break;
      case PortfolioTheme.light:
      case PortfolioTheme.system:
      default:
        // Default to the standard dark theme if light/system is selected
        // but ThemeMode will handle the actual switch.
        activeDarkTheme = SimplifiedTheme.getDarkTheme();
        break;
    }

    return MaterialApp(
      title: 'Portfolio Core',
      debugShowCheckedModeBanner: false,
      theme: SimplifiedTheme.getLightTheme(), // Always provide the light theme
      darkTheme:
          activeDarkTheme, // Provide the currently selected dark/retro theme
      themeMode: themeNotifier
          .themeMode, // Notifier determines which theme (light/dark/system) is active
      scrollBehavior: const ScrollBehavior().copyWith(
        scrollbars:
            false, // Consider keeping scrollbars for web/desktop - TODO: Revisit this
        overscroll: false, // Prevent default overscroll glow
      ),
      home: const AuthWrapper(), // Use AuthWrapper as the home screen
    );
  }
}
