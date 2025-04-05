import 'package:flutter/material.dart';
import 'package:portfolio_core/data/portfolio_data.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';

class AboutTab extends StatelessWidget {
  final PortfolioData portfolioData;

  const AboutTab({super.key, required this.portfolioData});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'About Me',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 24),
          
          // About content
          Text(
            portfolioData.bio,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          
          // Contact Info Section
          Text(
            'Contact Information',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          
          // Email
          _buildContactItem(
            context,
            Icons.email_outlined,
            'Email',
            portfolioData.email,
            isDarkMode,
          ),
          const SizedBox(height: 12),
          
          // GitHub
          _buildContactItem(
            context,
            Icons.code_outlined,
            'GitHub',
            portfolioData.github,
            isDarkMode,
          ),
          const SizedBox(height: 12),
          
          // LinkedIn
          _buildContactItem(
            context,
            Icons.business_outlined,
            'LinkedIn',
            portfolioData.linkedin,
            isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode 
            ? SimplifiedTheme.backgroundDark 
            : SimplifiedTheme.backgroundLight,
        borderRadius: BorderRadius.circular(SimplifiedTheme.borderRadius),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: SimplifiedTheme.primaryBlue,
            size: 24,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}