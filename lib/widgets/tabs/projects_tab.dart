import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Add provider import
import 'package:portfolio_core/data/portfolio_data.dart'; // Keep for type reference
import 'package:portfolio_core/widgets/project_card.dart';
import 'package:portfolio_core/widgets/common/portfolio_tab_view.dart';

class ProjectsTab extends StatelessWidget {
  // Remove portfolioData field

  const ProjectsTab({super.key}); // Remove portfolioData from constructor

  @override
  Widget build(BuildContext context) {
    // Get data from provider
    final portfolioData = context.watch<PortfolioData>();
    return PortfolioTabView(
      title: 'Projects',
      children: [
        // Projects grid
        LayoutBuilder(builder: (context, constraints) {
          // Responsive grid - 1 column on mobile, 2 on larger screens
          final crossAxisCount = constraints.maxWidth > 700 ? 2 : 1;

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
              mainAxisExtent: 450, // Fixed height for cards
            ),
            itemCount: portfolioData.projects.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final project = portfolioData.projects[index];
              return ProjectCard(project: project);
            },
          );
        }),
      ],
    );
  }
}
