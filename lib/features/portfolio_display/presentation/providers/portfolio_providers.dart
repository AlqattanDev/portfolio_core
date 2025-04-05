import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:portfolio_core/models/project.dart';
import 'package:portfolio_core/models/skill.dart';
import 'package:portfolio_core/models/user_info.dart';
import 'package:portfolio_core/services/portfolio_service.dart';

// Necessary for code generation
part 'portfolio_providers.g.dart';

// Provider for the PortfolioService instance
@riverpod
PortfolioService portfolioService(PortfolioServiceRef ref) {
  return PortfolioService();
}

// Removed projects provider (data now loaded from JSON via portfolio_data_provider.dart)

// Removed skills provider (data now loaded from JSON via portfolio_data_provider.dart)

// Provider to fetch user information
@riverpod
Future<UserInfo?> userInfo(UserInfoRef ref) async {
  // No need to call ensureDefaultValues again.
  return ref.watch(portfolioServiceProvider).getUserInfo();
}
