import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Add provider import
import 'package:portfolio_core/data/portfolio_data.dart'; // Keep for type reference
import 'package:portfolio_core/widgets/common/portfolio_tab_view.dart';
import 'package:portfolio_core/widgets/common/contact_info_item.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

class AboutTab extends StatelessWidget {
  // Remove portfolioData field

  const AboutTab({super.key}); // Remove portfolioData from constructor

  // Helper function to launch URLs safely
  Future<void> _launchUrl(BuildContext context, String urlString) async {
    if (urlString.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('URL is not available.')),
      );
      return;
    }
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      // Log error or show message to the user
      print('Could not launch $url');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open the link: $urlString')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get data from provider
    final portfolioData = context.watch<PortfolioData>();
    return PortfolioTabView(
      title: 'About Me',
      children: [
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
        ContactInfoItem(
          icon: Icons.email_outlined,
          label: 'Email',
          value: portfolioData.email,
          isClickable: false,
        ),
        const SizedBox(height: 12),

        // GitHub
        ContactInfoItem(
          icon: Icons.code_outlined,
          label: 'GitHub',
          value: portfolioData.github,
          isClickable: true,
          onTap: () => _launchUrl(context, portfolioData.github),
        ),
        const SizedBox(height: 12),

        // LinkedIn
        ContactInfoItem(
          icon: Icons.business_outlined,
          label: 'LinkedIn',
          value: portfolioData.linkedin,
          isClickable: true,
          onTap: () => _launchUrl(context, portfolioData.linkedin),
        ),
      ],
    );
  }
}
