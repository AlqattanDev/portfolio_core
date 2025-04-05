import 'package:flutter/material.dart';
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
              '${(skill.level * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: SimplifiedTheme.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: skill.level,
            child: Container(
              decoration: BoxDecoration(
                color: SimplifiedTheme.primaryBlue,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
