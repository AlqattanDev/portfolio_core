import 'package:flutter/material.dart';
import 'package:portfolio_core/models/project.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';
import 'package:url_launcher/url_launcher.dart';

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
            padding: const EdgeInsets.all(16.0),
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
                      backgroundColor: SimplifiedTheme.primaryBlue.withOpacity(0.15),
                      labelStyle: TextStyle(
                        color: SimplifiedTheme.primaryBlue,
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
                        () => _launchUrl(project.githubUrl!),
                      ),
                    const SizedBox(width: 12),
                    if (project.liveUrl != null)
                      _buildLinkButton(
                        context,
                        'Live Demo',
                        Icons.open_in_new,
                        () => _launchUrl(project.liveUrl!),
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
        backgroundColor: SimplifiedTheme.primaryBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
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