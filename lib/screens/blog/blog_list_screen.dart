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
    // Get BlogService instance - listen: false as we only need it for actions
    final blogService = Provider.of<BlogService>(context, listen: false);

    return Scaffold(
      // AppBar removed as authentication is handled globally by AuthWrapper
      // appBar: AppBar(
      //   title: const Text('Blog Posts'),
      //   // Actions removed
      // ),
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
              padding: Theme.of(context)
                  .extension<PortfolioThemeExtension>()!
                  .contentPadding, // Added consistent padding
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                // Format Timestamp correctly
                final formattedDate =
                    post.createdAt.toDate().toString().substring(0, 10);

                Widget? trailingWidget;
                if (authService.isAuthenticated) {
                  trailingWidget = Row(
                    mainAxisSize:
                        MainAxisSize.min, // Prevent row from expanding
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        tooltip: 'Edit Post',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BlogPostEditScreen(postId: post.id),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete,
                            color: Theme.of(context).colorScheme.error),
                        tooltip: 'Delete Post',
                        onPressed: () async {
                          // Show confirmation dialog
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirm Deletion'),
                                content: Text(
                                    'Are you sure you want to delete "${post.title}"?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Delete',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error)),
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                  ),
                                ],
                              );
                            },
                          );

                          // If confirmed, delete the post
                          if (confirm == true) {
                            try {
                              await blogService.deletePost(post.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Post deleted successfully')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Error deleting post: ${e.toString()}')),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  );
                } else {
                  // Show chevron if not authenticated (for navigation hint)
                  trailingWidget = const Icon(Icons.chevron_right);
                }

                return ListTile(
                  contentPadding: EdgeInsets.zero, // Use ListView padding
                  title: Text(post.title),
                  subtitle:
                      Text('Published: $formattedDate'), // Use formatted date
                  trailing:
                      trailingWidget, // Use the conditional trailing widget
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
