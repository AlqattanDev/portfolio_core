import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portfolio_core/models/blog_post.dart';
import 'package:portfolio_core/providers/service_providers.dart'; // Need BlogService provider

part 'blog_providers.g.dart';

// Provider to fetch a single blog post by ID
// Using .family to pass the postId argument
@riverpod
Future<BlogPost?> blogPost(BlogPostRef ref, String postId) async {
  final blogService = ref.watch(blogServiceProvider);
  return blogService.getPostById(postId);
}

// Provider for the stream of all blog posts (can be used by BlogListScreen later)
@riverpod
Stream<List<BlogPost>> blogPostsStream(BlogPostsStreamRef ref) {
  final blogService = ref.watch(blogServiceProvider);
  return blogService.getPostsStream();
}
