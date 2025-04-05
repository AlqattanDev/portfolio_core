import 'package:flutter/material.dart';
import 'package:portfolio_core/models/project.dart';
import 'package:portfolio_core/services/url_launcher_service.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    // final isDarkMode = Theme.of(context).brightness == Brightness.dark; // No longer needed directly here
    final themeExtension =
        Theme.of(context).extension<PortfolioThemeExtension>()!;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(themeExtension.cardBorderRadius),
        // Add border for retro themes (which have borderRadius 0)
        border: themeExtension.cardBorderRadius == 0
            ? Border.all(
                color: Theme.of(context)
                    .dividerColor) // Use divider color for border
            : null,
        // Remove explicit shadow, rely on theme elevation if needed (though retro themes have 0)
      ),
      clipBehavior: Clip.antiAlias, // Keep clipping
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
                    // Use ChipThemeData defined in SimplifiedTheme
                    return Chip(
                      label: Text(tech),
                      // Remove explicit styling to use theme's ChipThemeData
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
      // Remove explicit style to use theme's ElevatedButtonThemeData
    );
  }
}
