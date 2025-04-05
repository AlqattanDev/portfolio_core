import 'package:flutter/material.dart';
import 'package:portfolio_core/models/project.dart';
import 'package:portfolio_core/services/url_launcher_service.dart';

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project image
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.asset(
              project.imageUrl,
              fit: BoxFit.cover,
            ),
          ),

          // Project content
          Padding(
            padding: Theme.of(context)
                .extension<PortfolioThemeExtension>()!
                .contentPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  project.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  project.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),

                // Technologies
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: project.technologies.map((tech) {
                    return Chip(
                      label: Text(tech),
                      backgroundColor: Theme.of(context).colorScheme.primary
                          .withAlpha((0.15 * 255).round()),
                      labelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Links
                Row(
                  children: [
                    if (project.githubUrl != null)
                      _buildLinkButton(
                        context,
                        'GitHub',
                        Icons.code,
                        () => UrlLauncherService.openUrl(project.githubUrl!),
                      ),
                    const SizedBox(width: 12),
                    if (project.liveUrl != null)
                      _buildLinkButton(
                        context,
                        'Live Demo',
                        Icons.open_in_new,
                        () => UrlLauncherService.openUrl(project.liveUrl!),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        padding: Theme.of(context).extension<PortfolioThemeExtension>()!.smallPadding.copyWith(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
