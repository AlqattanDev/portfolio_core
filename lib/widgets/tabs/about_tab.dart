import 'package:flutter/material.dart';
import 'package:portfolio_core/data/portfolio_data.dart';
import 'package:portfolio_core/widgets/common/portfolio_tab_view.dart';
import 'package:portfolio_core/widgets/common/contact_info_item.dart';

class AboutTab extends StatelessWidget {
  final PortfolioData portfolioData;

  const AboutTab({super.key, required this.portfolioData});

  @override
  Widget build(BuildContext context) {
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
          isClickable: false,
        ),
        const SizedBox(height: 12),

        // LinkedIn
        ContactInfoItem(
          icon: Icons.business_outlined,
          label: 'LinkedIn',
          value: portfolioData.linkedin,
          isClickable: false,
        ),
      ],
    );
  }
}
