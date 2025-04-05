import 'package:flutter/material.dart';
import 'package:portfolio_core/screens/auth/login_screen.dart';
import 'package:portfolio_core/screens/tabbed_portfolio_screen.dart';
import 'package:portfolio_core/services/auth_service.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    // Listen to authentication state changes
    if (authService.isAuthenticated) {
      // If authenticated, show the main app screen
      return const TabbedPortfolioScreen();
    } else {
      // If not authenticated, show the login screen
      return const LoginScreen();
    }
  }
}
