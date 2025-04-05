import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_core/data/portfolio_data.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';
import 'package:portfolio_core/widgets/tabs/about_tab.dart';
import 'package:portfolio_core/widgets/tabs/contact_tab.dart';
import 'package:portfolio_core/widgets/tabs/home_tab.dart';
import 'package:portfolio_core/widgets/tabs/projects_tab.dart';
import 'package:portfolio_core/widgets/tabs/skills_tab.dart';
import 'package:portfolio_core/screens/blog/blog_list_screen.dart'; // Import BlogListScreen
import 'package:portfolio_core/theme/theme_notifier.dart'; // Import ThemeNotifier

class TabbedPortfolioScreen extends StatefulWidget {
  const TabbedPortfolioScreen({super.key});

  @override
  State<TabbedPortfolioScreen> createState() => _TabbedPortfolioScreenState();
}

class _TabbedPortfolioScreenState extends State<TabbedPortfolioScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 6, vsync: this); // Increased length to 6
    // portfolioData.loadPortfolioData(); // Fetch data on init
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

  // Helper method to build the TabBar container
  Widget _buildTabBar(BuildContext context, bool isDarkMode, Size size) {
    return Theme(
      // Use theme's splash/highlight for consistency
      data: Theme.of(context).copyWith(
        splashColor: Theme.of(context).splashColor,
        highlightColor: Theme.of(context).highlightColor,
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
              // Use theme's shadow color
              color:
                  Theme.of(context).shadowColor.withAlpha(isDarkMode ? 40 : 20),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TabBar(
          controller: _tabController, // Access state's _tabController
          labelColor: SimplifiedTheme.primaryBlue,
          // Remove hardcoded unselectedLabelColor, use TabBarTheme from SimplifiedTheme
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
              // Use theme's shadow color
              color:
                  Theme.of(context).shadowColor.withAlpha(isDarkMode ? 40 : 20),
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
                // portfolioData removed, accessed via provider in widget
                onProjectsButtonPressed: () {
                  _tabController
                      .animateTo(3); // Navigate to Projects tab (index 3)
                },
              ),

              // About tab
              const AboutTab(), // Use const if possible

              // Skills tab
              const SkillsTab(), // Use const if possible

              // Projects tab
              const ProjectsTab(), // Use const if possible

              // Contact tab
              const ContactTab(), // Use const if possible

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
    final themeNotifier = context.watch<ThemeNotifier>(); // Get ThemeNotifier

    return Scaffold(
      // Add AppBar
      appBar: AppBar(
        title: Consumer<PortfolioData>(
          // Use Consumer to access data for the title
          builder: (context, data, child) => Text(
            data.name.isNotEmpty
                ? data.name
                : 'Portfolio', // Show name or default
            style: GoogleFonts.inter(
              // Use AppBar's titleTextStyle or define here
              fontSize: 20, // Adjusted size for AppBar
              fontWeight: FontWeight.bold,
              color: SimplifiedTheme.primaryBlue, // Use theme color
            ),
          ),
        ),
        backgroundColor: isDarkMode
            ? SimplifiedTheme.cardDark
            : SimplifiedTheme.cardLight, // Match card color
        elevation: 0, // Keep elevation consistent
        actions: [
          // Theme Cycle Button
          IconButton(
            icon: Icon(
              // Choose an icon based on current theme or a generic cycle icon
              _getThemeIcon(themeNotifier.currentTheme),
              color: SimplifiedTheme.primaryBlue, // Use theme color
            ),
            tooltip: 'Cycle Theme', // Updated tooltip
            onPressed: () {
              // Cycle through PortfolioTheme enum
              final current = themeNotifier.currentTheme;
              final currentIndex = PortfolioTheme.values.indexOf(current);
              // Exclude 'system' if you don't want it in the cycle, otherwise use % PortfolioTheme.values.length
              final nextIndex = (currentIndex + 1) %
                  (PortfolioTheme.values.length -
                      1); // Cycle through 0 to 4 (light to ascii)
              final nextTheme = PortfolioTheme.values[nextIndex];
              context.read<ThemeNotifier>().setTheme(nextTheme);
            },
          ),
          // Add other actions if needed, e.g., Logout
        ],
      ),
      body: Container(
        // Keep existing background decoration
        decoration: BoxDecoration(
          color: isDarkMode
              ? SimplifiedTheme.backgroundDark
              : SimplifiedTheme.backgroundLight,
        ),
        child: SafeArea(
          // Wrap with ChangeNotifierProvider to provide PortfolioData down the tree
          // child: ChangeNotifierProvider.value(
          //  value: portfolioData, // Provide the instance created in the state
          child: Padding(
            padding: Theme.of(context)
                .extension<PortfolioThemeExtension>()!
                .contentPadding,
            child: LayoutBuilder(builder: (context, constraints) {
              // Watch for changes in PortfolioData
              final data = context.watch<PortfolioData>();

              // Handle loading state
              if (data.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              // Handle error state
              if (data.error != null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Error: ${data.error}\nPlease try refreshing.',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                );
              }

              // Display content when loaded and no error
              return Column(
                children: [
                  // Header removed, now in AppBar

                  // Tab bar
                  _buildTabBar(context, isDarkMode, size),

                  SizedBox(height: constraints.maxHeight * 0.03),

                  // Tab content
                  _buildTabContent(context, isDarkMode),
                ],
              );
            }),
          ),
          //),
        ),
      ),
    );
  }

  // Helper to get an icon based on the current theme
  IconData _getThemeIcon(PortfolioTheme theme) {
    switch (theme) {
      case PortfolioTheme.light:
        return Icons.light_mode_outlined;
      case PortfolioTheme.dark:
        return Icons.dark_mode_outlined;
      case PortfolioTheme.retroGreen:
        return Icons.terminal; // Example icon
      case PortfolioTheme.retroAmber:
        return Icons.computer; // Example icon
      case PortfolioTheme.ascii:
        return Icons.code; // Example icon
      case PortfolioTheme.system:
        return Icons.brightness_auto; // Example icon
      default:
        return Icons.palette_outlined; // Default cycle icon
    }
  }
}
