import 'package:flutter/material.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';
import 'package:portfolio_core/data/portfolio_data.dart';
import 'package:portfolio_core/widgets/common/portfolio_tab_view.dart';
import 'package:portfolio_core/widgets/common/contact_info_item.dart';
import 'package:portfolio_core/services/url_launcher_service.dart';

class ContactTab extends StatelessWidget {
  final PortfolioData portfolioData;

  const ContactTab({super.key, required this.portfolioData});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return PortfolioTabView(
      title: 'Contact Me',
      children: [
        // Contact intro
        Text(
          'Feel free to reach out to me for collaboration, job opportunities, or just to say hello!',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 32),

        // Contact card
        Container(
          padding: Theme.of(context)
              .extension<PortfolioThemeExtension>()!
              .screenPadding,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(Theme.of(context)
                .extension<PortfolioThemeExtension>()!
                .cardBorderRadius),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withAlpha(isDarkMode ? 40 : 20),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              // Email
              ContactInfoItem(
                icon: Icons.email_outlined,
                label: 'Email',
                value: portfolioData.email,
                iconSize: 32,
                onTap: () => UrlLauncherService.openEmail(portfolioData.email),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // GitHub
              ContactInfoItem(
                icon: Icons.code_outlined,
                label: 'GitHub',
                value: portfolioData.github,
                iconSize: 32,
                onTap: () => UrlLauncherService.openUrl(portfolioData.github),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // LinkedIn
              ContactInfoItem(
                icon: Icons.business_outlined,
                label: 'LinkedIn',
                value: portfolioData.linkedin,
                iconSize: 32,
                onTap: () => UrlLauncherService.openUrl(portfolioData.linkedin),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
