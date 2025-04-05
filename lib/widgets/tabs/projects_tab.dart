import 'package:flutter/material.dart';
import 'package:portfolio_core/data/portfolio_data.dart';
import 'package:portfolio_core/widgets/project_card.dart';

class ProjectsTab extends StatelessWidget {
  final PortfolioData portfolioData;

  const ProjectsTab({super.key, required this.portfolioData});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Projects',
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 24),
          
          // Projects grid
          LayoutBuilder(
            builder: (context, constraints) {
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
            }
          ),
        ],
      ),
    );
  }
}