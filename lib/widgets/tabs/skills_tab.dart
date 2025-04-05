import 'package:flutter/material.dart';
import 'package:portfolio_core/data/portfolio_data.dart';
import 'package:portfolio_core/models/skill.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';

class SkillsTab extends StatelessWidget {
  final PortfolioData portfolioData;

  const SkillsTab({super.key, required this.portfolioData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Skills',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 24),
          
          // Skills list
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: portfolioData.skills.length,
            itemBuilder: (context, index) {
              final skill = portfolioData.skills[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildSkillItem(context, skill),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSkillItem(BuildContext context, Skill skill) {
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
            color: isDarkMode
                ? Colors.grey.shade800
                : Colors.grey.shade200,
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