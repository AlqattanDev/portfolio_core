import 'package:flutter/material.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';
import 'package:portfolio_core/data/portfolio_data.dart';
import 'package:portfolio_core/widgets/common/portfolio_tab_view.dart';
import 'package:portfolio_core/widgets/common/skill_progress_bar.dart';

class SkillsTab extends StatelessWidget {
  final PortfolioData portfolioData;

  const SkillsTab({super.key, required this.portfolioData});

  @override
  Widget build(BuildContext context) {
    final spacing =
        Theme.of(context).extension<PortfolioThemeExtension>()!.itemSpacing;

    return PortfolioTabView(
      title: 'Skills',
      children: [
        // Directly render skill widgets instead of using ListView.builder
        for (int i = 0; i < portfolioData.skills.length; i++)
          Padding(
            padding: EdgeInsets.only(
                bottom: i < portfolioData.skills.length - 1 ? spacing : 0),
            child: SkillProgressBar(skill: portfolioData.skills[i]),
          ),
      ],
    );
  }
}
