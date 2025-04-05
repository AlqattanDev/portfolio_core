import 'package:flutter/material.dart';
import 'package:portfolio_core/data/portfolio_data.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';

class HomeTab extends StatelessWidget {
  final PortfolioData portfolioData;

  const HomeTab({super.key, required this.portfolioData});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Hello, I\'m',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 8),
          Text(
            portfolioData.name,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 8),
          Text(
            portfolioData.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: isDarkMode 
                      ? SimplifiedTheme.accentGreen 
                      : SimplifiedTheme.accentGreen,
                ),
          ),
          const SizedBox(height: 24),
          
          // Bio
          Text(
            portfolioData.bio,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),

          // Call to action
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                // Can be used to navigate to projects or contact
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: SimplifiedTheme.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text(
                'View My Projects',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}