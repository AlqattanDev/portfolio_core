import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_core/data/portfolio_data.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';
import 'package:portfolio_core/widgets/tabs/about_tab.dart';
import 'package:portfolio_core/widgets/tabs/contact_tab.dart';
import 'package:portfolio_core/widgets/tabs/home_tab.dart';
import 'package:portfolio_core/widgets/tabs/projects_tab.dart';
import 'package:portfolio_core/widgets/tabs/skills_tab.dart';

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
    _tabController = TabController(length: 5, vsync: this);
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
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                children: [
                  // Header with name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Name/Logo
                      Text(
                        portfolioData.name,
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: SimplifiedTheme.primaryBlue,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: constraints.maxHeight * 0.03),

                  // Tab bar
                  Theme(
                    data: Theme.of(context).copyWith(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? SimplifiedTheme.cardDark
                            : SimplifiedTheme.cardLight,
                        borderRadius:
                            BorderRadius.circular(SimplifiedTheme.borderRadius),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(isDarkMode ? 40 : 20),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: SimplifiedTheme.primaryBlue,
                        unselectedLabelColor: isDarkMode
                            ? Colors.grey.shade400
                            : Colors.grey.shade700,
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
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: constraints.maxHeight * 0.03),

                  // Tab content
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? SimplifiedTheme.cardDark
                            : SimplifiedTheme.cardLight,
                        borderRadius:
                            BorderRadius.circular(SimplifiedTheme.borderRadius),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(isDarkMode ? 40 : 20),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(SimplifiedTheme.borderRadius),
                        child: IndexedStack(
                          index: _tabController.index,
                          children: [
                            // Home tab
                            HomeTab(portfolioData: portfolioData),

                            // About tab
                            AboutTab(portfolioData: portfolioData),

                            // Skills tab
                            SkillsTab(portfolioData: portfolioData),

                            // Projects tab
                            ProjectsTab(portfolioData: portfolioData),

                            // Contact tab
                            ContactTab(portfolioData: portfolioData),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}