// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$portfolioDataHash() => r'8c88c06d9f31e692c5759e3fbbbedd2c71be14e7';

/// See also [portfolioData].
@ProviderFor(portfolioData)
final portfolioDataProvider = FutureProvider<PortfolioData>.internal(
  portfolioData,
  name: r'portfolioDataProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$portfolioDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PortfolioDataRef = FutureProviderRef<PortfolioData>;
String _$projectsFromJsonHash() => r'd4941b0a88956646a0c9419c882ddbbafa522320';

/// See also [projectsFromJson].
@ProviderFor(projectsFromJson)
final projectsFromJsonProvider =
    AutoDisposeFutureProvider<List<Project>>.internal(
  projectsFromJson,
  name: r'projectsFromJsonProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$projectsFromJsonHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ProjectsFromJsonRef = AutoDisposeFutureProviderRef<List<Project>>;
String _$skillsFromJsonHash() => r'6080a9ca6ba850e9147e13decb64f9a77e27c4e8';

/// See also [skillsFromJson].
@ProviderFor(skillsFromJson)
final skillsFromJsonProvider = AutoDisposeFutureProvider<List<Skill>>.internal(
  skillsFromJson,
  name: r'skillsFromJsonProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$skillsFromJsonHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SkillsFromJsonRef = AutoDisposeFutureProviderRef<List<Skill>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
