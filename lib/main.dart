import 'package:flutter/material.dart';
import 'package:portfolio_core/services/auth_service.dart';
import 'package:portfolio_core/services/blog_service.dart';
import 'package:portfolio_core/screens/tabbed_portfolio_screen.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:portfolio_core/firebase_options.dart'; // Import generated options

Future<void> main() async {
  // Make main async
  WidgetsFlutterBinding.ensureInitialized(); // Ensure bindings are initialized
  await Firebase.initializeApp(
    // Initialize Firebase
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      ],
      child: const PortfolioApp(),
    ),
  );
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio Core',
      debugShowCheckedModeBanner: false,
      theme: SimplifiedTheme.getLightTheme(),
      darkTheme: SimplifiedTheme.getDarkTheme(),
      themeMode: ThemeMode.system,
      scrollBehavior: const ScrollBehavior().copyWith(
        scrollbars: false,
        overscroll: false,
      ),
      home: const TabbedPortfolioScreen(),
    );
  }
}
