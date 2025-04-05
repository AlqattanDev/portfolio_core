import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_core/data/portfolio_data.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';
import 'package:portfolio_core/widgets/tabs/about_tab.dart';
import 'package:portfolio_core/widgets/tabs/contact_tab.dart';
import 'package:portfolio_core/widgets/tabs/home_tab.dart';
import 'package:portfolio_core/widgets/tabs/projects_tab.dart';
import 'package:portfolio_core/widgets/tabs/skills_tab.dart';
import 'package:portfolio_core/screens/blog/blog_list_screen.dart'; // Import BlogListScreen

class TabbedPortfolioScreen extends StatefulWidget {
  const TabbedPortfolioScreen({super.key});

  @override
  State<TabbedPortfolioScreen> createState() => _TabbedPortfolioScreenState();
}

class _TabbedPortfolioScreenState extends State<TabbedPortfolioScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final portfolioData = PortfolioData();

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 6, vsync: this); // Increased length to 6
    // Add listener to update the state when tab changes
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    // Force rebuild when tab index changes to update IndexedStack
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  // Helper method to build the header
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Name/Logo
        Text(
          portfolioData.name, // Access state's portfolioData
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: SimplifiedTheme.primaryBlue,
          ),
        ),
      ],
    );
  }

  // Helper method to build the TabBar container
  Widget _buildTabBar(BuildContext context, bool isDarkMode, Size size) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Container(
        decoration: BoxDecoration(
          color:
              isDarkMode ? SimplifiedTheme.cardDark : SimplifiedTheme.cardLight,
          borderRadius: BorderRadius.circular(Theme.of(context)
              .extension<PortfolioThemeExtension>()!
              .cardBorderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDarkMode ? 40 : 20),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TabBar(
          controller: _tabController, // Access state's _tabController
          labelColor: SimplifiedTheme.primaryBlue,
          unselectedLabelColor:
              isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700,
          indicatorColor: SimplifiedTheme.primaryBlue,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          isScrollable: size.width < 600, // Scrollable on small screens
          labelStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 14,
          ),
          tabs: const [
            Tab(icon: Icon(Icons.home_outlined), text: 'Home'),
            Tab(icon: Icon(Icons.person_outline), text: 'About'),
            Tab(icon: Icon(Icons.code_outlined), text: 'Skills'),
            Tab(icon: Icon(Icons.work_outline), text: 'Projects'),
            Tab(icon: Icon(Icons.mail_outline), text: 'Contact'),
            Tab(
                icon: Icon(Icons.article_outlined),
                text: 'Blog'), // Added Blog Tab
          ],
        ),
      ),
    );
  }

  // Helper method to build the Tab Content container
  Widget _buildTabContent(BuildContext context, bool isDarkMode) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color:
              isDarkMode ? SimplifiedTheme.cardDark : SimplifiedTheme.cardLight,
          borderRadius: BorderRadius.circular(Theme.of(context)
              .extension<PortfolioThemeExtension>()!
              .cardBorderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDarkMode ? 40 : 20),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Theme.of(context)
              .extension<PortfolioThemeExtension>()!
              .cardBorderRadius),
          child: IndexedStack(
            index: _tabController.index, // Access state's _tabController
            children: [
              // Home tab
              HomeTab(
                portfolioData: portfolioData,
                onProjectsButtonPressed: () {
                  _tabController
                      .animateTo(3); // Navigate to Projects tab (index 3)
                },
              ),

              // About tab
              AboutTab(portfolioData: portfolioData),

              // Skills tab
              SkillsTab(portfolioData: portfolioData),

              // Projects tab
              ProjectsTab(portfolioData: portfolioData),

              // Contact tab
              ContactTab(portfolioData: portfolioData),

              // Blog tab
              const BlogListScreen(), // Use const for consistency
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: isDarkMode
              ? SimplifiedTheme.backgroundDark
              : SimplifiedTheme.backgroundLight,
        ),
        child: SafeArea(
          child: Padding(
            padding: Theme.of(context)
                .extension<PortfolioThemeExtension>()!
                .contentPadding,
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  // Header
                  _buildHeader(context),

                  SizedBox(height: constraints.maxHeight * 0.03),

                  // Tab bar
                  _buildTabBar(context, isDarkMode, size),

                  SizedBox(height: constraints.maxHeight * 0.03),

                  // Tab content
                  _buildTabContent(context, isDarkMode),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
