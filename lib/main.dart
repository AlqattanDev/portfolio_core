import 'package:flutter/material.dart';
import 'package:portfolio_core/screens/tabbed_portfolio_screen.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';

void main() {
  runApp(const PortfolioApp());
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
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(1.0),
          ),
          child: child!,
        );
      },
      home: const TabbedPortfolioScreen(),
    );
  }
}