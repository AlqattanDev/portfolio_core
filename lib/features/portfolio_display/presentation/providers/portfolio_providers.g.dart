// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$portfolioServiceHash() => r'25f4fbbf0177bebc8262f695a632435acbb1cfb6';

/// See also [portfolioService].
@ProviderFor(portfolioService)
final portfolioServiceProvider = AutoDisposeProvider<PortfolioService>.internal(
  portfolioService,
  name: r'portfolioServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$portfolioServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PortfolioServiceRef = AutoDisposeProviderRef<PortfolioService>;
String _$userInfoHash() => r'c7aff26052a4d8e387420392476c79a05be4479c';

/// See also [userInfo].
@ProviderFor(userInfo)
final userInfoProvider = AutoDisposeFutureProvider<UserInfo?>.internal(
  userInfo,
  name: r'userInfoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userInfoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserInfoRef = AutoDisposeFutureProviderRef<UserInfo?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
