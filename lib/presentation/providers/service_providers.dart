import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portfolio_core/services/auth_service.dart';
import 'package:portfolio_core/services/blog_service.dart';

part 'service_providers.g.dart';

// Provider for AuthService instance
@Riverpod(keepAlive: true) // Keep alive as it manages auth state
AuthService authService(AuthServiceRef ref) {
  final authService = AuthService();
  // Ensure listeners are disposed when the provider is disposed
  ref.onDispose(() => authService.dispose());
  return authService;
}

// Provider for BlogService instance
// Depends on AuthService
@riverpod
BlogService blogService(BlogServiceRef ref) {
  // Watch the AuthService provider
  final authService = ref.watch(authServiceProvider);
  // Create BlogService with the AuthService instance
  return BlogService(authService);
}
