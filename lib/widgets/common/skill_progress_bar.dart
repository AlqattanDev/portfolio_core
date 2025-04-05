import 'package:flutter/material.dart';
import 'package:portfolio_core/theme/colors.dart'; // Import AppColors
import 'package:portfolio_core/theme/simplified_theme.dart';
import 'package:portfolio_core/models/skill.dart';

class SkillProgressBar extends StatelessWidget {
  final Skill skill;

  const SkillProgressBar({
    super.key,
    required this.skill,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              skill.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              '${skill.level}%', // Use integer level directly
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .primary, // Use theme color
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Builder(// Use Builder to get context within the Column
            builder: (context) {
          final themeExtension =
              Theme.of(context).extension<PortfolioThemeExtension>()!;
          final isRetro = themeExtension.cardBorderRadius == 0;
          final borderRadius =
              isRetro ? BorderRadius.zero : BorderRadius.circular(10);

          return Container(
            height: isRetro ? 12 : 8, // Make retro bar slightly thicker
            width: double.infinity,
            decoration: BoxDecoration(
              // Use a theme-adaptive track color
              color: Theme.of(context).dividerColor.withOpacity(0.3),
              borderRadius: borderRadius,
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor:
                  skill.level / 100.0, // Convert int 0-100 to double 0.0-1.0
              child: Container(
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.primary, // Use theme color
                  borderRadius: borderRadius,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
