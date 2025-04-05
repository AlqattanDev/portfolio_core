import 'package:flutter/material.dart';
import 'package:portfolio_core/services/auth_service.dart';
import 'package:portfolio_core/services/blog_service.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';
import 'package:portfolio_core/models/blog_post.dart';
import 'package:portfolio_core/screens/blog/blog_post_view_screen.dart';
import 'package:portfolio_core/screens/blog/blog_post_edit_screen.dart';
import 'package:portfolio_core/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';

class BlogListScreen extends StatefulWidget {
  const BlogListScreen({super.key});

  @override
  State<BlogListScreen> createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  // No need for _postsFuture or initState fetching with StreamBuilder

  void _navigateToViewScreen(BuildContext context, String postId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BlogPostViewScreen(postId: postId)),
    );
  }

  void _navigateToCreateScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const BlogPostEditScreen()), // No postId for create
    );
    // No need to manually refresh, StreamBuilder handles updates
  }

  void _navigateToLoginScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
    // No refresh needed here, the screen rebuilds based on Provider state change
  }

  @override
  Widget build(BuildContext context) {
    // Access AuthService to check authentication status for the FAB
    // Use watch: true (default) or select to rebuild when auth state changes
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      // Using a simple AppBar for now, can be integrated into TabbedPortfolioScreen later
      appBar: AppBar(
        title: const Text('Blog Posts'),
        actions: [
          // Optional: Add Login/Logout button based on auth state
          // Refresh button removed as StreamBuilder handles updates
          if (authService.isAuthenticated)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                // Store context in local variable before async operation
                final scaffoldMessenger = ScaffoldMessenger.of(context);

                await authService.logout();

                // Use stored reference after async operation
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('Logged out successfully')),
                );
              },
              tooltip: 'Logout',
            )
          else
            IconButton(
              icon: const Icon(Icons.login),
              onPressed: () => _navigateToLoginScreen(context),
              tooltip: 'Login',
            ),
        ],
      ),
      // Use StreamBuilder to listen to the posts stream
      body: StreamBuilder<List<BlogPost>>(
        stream:
            Provider.of<BlogService>(context, listen: false).getPostsStream(),
        builder: (context, snapshot) {
          // Handle stream states
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Log the actual error for debugging but don't show in production
            return Center(
              child: Padding(
                padding: Theme.of(context)
                    .extension<PortfolioThemeExtension>()!
                    .contentPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Error loading posts. Please try again later.',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No blog posts found.'));
          } else {
            // Data is available
            final posts = snapshot.data!;
            // No need for RefreshIndicator with StreamBuilder
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                // Format Timestamp correctly
                final formattedDate =
                    post.createdAt.toDate().toString().substring(0, 10);
                return ListTile(
                  title: Text(post.title),
                  subtitle:
                      Text('Published: $formattedDate'), // Use formatted date
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _navigateToViewScreen(context, post.id),
                );
              },
            );
          }
        }, // End StreamBuilder builder
      ),
      floatingActionButton: authService.isAuthenticated
          ? FloatingActionButton(
              onPressed: () => _navigateToCreateScreen(context),
              tooltip: 'Create New Post',
              child: const Icon(Icons.add),
            )
          : null, // No FAB if not authenticated
    );
  }
}
