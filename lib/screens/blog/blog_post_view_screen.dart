import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:portfolio_core/services/auth_service.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';
import 'package:portfolio_core/services/blog_service.dart';
import 'package:portfolio_core/models/blog_post.dart';
import 'package:portfolio_core/screens/blog/blog_post_edit_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart'; // For handling links in Markdown

class BlogPostViewScreen extends StatefulWidget {
  final String postId;

  const BlogPostViewScreen({required this.postId, super.key});

  @override
  State<BlogPostViewScreen> createState() => _BlogPostViewScreenState();
}

class _BlogPostViewScreenState extends State<BlogPostViewScreen> {
  late Future<BlogPost?> _postFuture; // Allow null BlogPost
  String _appBarTitle = 'Loading Post...'; // State for AppBar title

  @override
  void initState() {
    super.initState();
    _fetchPost();
  }

  void _fetchPost() {
    // Use mounted check for safety
    if (mounted) {
      try {
        final future = Provider.of<BlogService>(context, listen: false)
            .getPostById(widget.postId);

        // Update AppBar title when future completes
        future.then((post) {
          // post is now BlogPost?
          if (mounted) {
            setState(() {
              // Handle null post when setting title
              _appBarTitle = post?.title ?? 'Post Not Found';
            });
          }
        }).catchError((error) {
          if (mounted) {
            setState(() {
              _appBarTitle = 'Error Loading';
            });
          }
        });

        // Assign the Future<BlogPost?> to the state variable
        setState(() {
          _postFuture = future;
        });
      } catch (e) {
        setState(() {
          _appBarTitle = 'Error';
          _postFuture = Future.error("BlogService not available.");
        });
      }
    }
  }

  void _navigateToEditScreen(BuildContext context, String postId) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BlogPostEditScreen(postId: postId)),
    ).then((success) {
      // BlogPostEditScreen returns true if save was successful
      if (success == true && mounted) {
        _fetchPost(); // Re-fetch post data
      }
    });
  }

  // Handle link taps in Markdown content
  Future<void> _onTapLink(String text, String? href, String title) async {
    if (href != null) {
      final Uri url = Uri.parse(href);
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open link: $href')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService =
        Provider.of<AuthService>(context); // For edit button visibility

    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle), // Use state variable for title
        actions: [
          // Show edit button only if authenticated
          // TODO: Add author check if necessary: && post.authorId == authService.currentUser?.id
          if (authService.isAuthenticated)
            // Use FutureBuilder<BlogPost?>
            FutureBuilder<BlogPost?>(
                future: _postFuture, // Check against the loaded post data
                builder: (context, snapshot) {
                  // Show button only if post loaded successfully (data is not null) and user is authenticated
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData &&
                      snapshot.data != null && // Explicit null check for data
                      !snapshot.hasError) {
                    return IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () =>
                          _navigateToEditScreen(context, widget.postId),
                      tooltip: 'Edit Post',
                    );
                  }
                  return const SizedBox
                      .shrink(); // Return empty space otherwise
                }),
        ],
      ),
      // Use FutureBuilder<BlogPost?>
      body: FutureBuilder<BlogPost?>(
        future: _postFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: Theme.of(context)
                    .extension<PortfolioThemeExtension>()!
                    .contentPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Error loading post: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                      onPressed: _fetchPost,
                    )
                  ],
                ),
              ),
            );
            // Check for null data explicitly
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Post not found.'));
          } else {
            // Data is available and not null, safe to use !
            final post = snapshot.data!;

            // Format Timestamps correctly using .toDate()
            final publishedDate =
                post.createdAt.toDate().toString().substring(0, 10);
            final updatedDate =
                post.updatedAt.toDate().toString().substring(0, 10);

            return SingleChildScrollView(
              // Allow scrolling for long posts
              padding: Theme.of(context)
                  .extension<PortfolioThemeExtension>()!
                  .contentPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title is now in AppBar
                  // Text(
                  //   post.title,
                  //   style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  // ),
                  // const SizedBox(height: 8),
                  Text(
                    'Published: $publishedDate | Updated: $updatedDate', // Use formatted dates
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Divider(height: 24),
                  MarkdownBody(
                    data: post.markdownContent,
                    selectable: true, // Allow text selection
                    onTapLink: _onTapLink, // Handle link taps
                    // TODO: Customize MarkdownStyleSheet if needed based on app theme
                    // styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(...),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
