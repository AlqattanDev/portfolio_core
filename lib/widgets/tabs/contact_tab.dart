import 'package:flutter/material.dart';
import 'package:portfolio_core/data/portfolio_data.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactTab extends StatelessWidget {
  final PortfolioData portfolioData;

  const ContactTab({super.key, required this.portfolioData});

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
            'Contact Me',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 24),
          
          // Contact intro
          Text(
            'Feel free to reach out to me for collaboration, job opportunities, or just to say hello!',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          
          // Contact card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? SimplifiedTheme.backgroundDark
                  : SimplifiedTheme.backgroundLight,
              borderRadius: BorderRadius.circular(SimplifiedTheme.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(isDarkMode ? 40 : 20),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                // Email
                _buildContactItem(
                  context,
                  Icons.email_outlined,
                  'Email',
                  portfolioData.email,
                  () => _launchUrl('mailto:${portfolioData.email}'),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                
                // GitHub
                _buildContactItem(
                  context,
                  Icons.code_outlined,
                  'GitHub',
                  portfolioData.github,
                  () => _launchUrl(portfolioData.github),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                
                // LinkedIn
                _buildContactItem(
                  context,
                  Icons.business_outlined,
                  'LinkedIn',
                  portfolioData.linkedin,
                  () => _launchUrl(portfolioData.linkedin),
                ),
              ],
            ),
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
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: SimplifiedTheme.primaryBlue,
              size: 32,
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: SimplifiedTheme.primaryBlue,
                        ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: SimplifiedTheme.primaryBlue,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}