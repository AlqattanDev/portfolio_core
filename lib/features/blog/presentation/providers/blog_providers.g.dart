// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blog_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$blogPostHash() => r'967c814b1f9bb99efb5b34875919db4576eb9552';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [blogPost].
@ProviderFor(blogPost)
const blogPostProvider = BlogPostFamily();

/// See also [blogPost].
class BlogPostFamily extends Family<AsyncValue<BlogPost?>> {
  /// See also [blogPost].
  const BlogPostFamily();

  /// See also [blogPost].
  BlogPostProvider call(
    String postId,
  ) {
    return BlogPostProvider(
      postId,
    );
  }

  @override
  BlogPostProvider getProviderOverride(
    covariant BlogPostProvider provider,
  ) {
    return call(
      provider.postId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'blogPostProvider';
}

/// See also [blogPost].
class BlogPostProvider extends AutoDisposeFutureProvider<BlogPost?> {
  /// See also [blogPost].
  BlogPostProvider(
    String postId,
  ) : this._internal(
          (ref) => blogPost(
            ref as BlogPostRef,
            postId,
          ),
          from: blogPostProvider,
          name: r'blogPostProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$blogPostHash,
          dependencies: BlogPostFamily._dependencies,
          allTransitiveDependencies: BlogPostFamily._allTransitiveDependencies,
          postId: postId,
        );

  BlogPostProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.postId,
  }) : super.internal();

  final String postId;

  @override
  Override overrideWith(
    FutureOr<BlogPost?> Function(BlogPostRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BlogPostProvider._internal(
        (ref) => create(ref as BlogPostRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        postId: postId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<BlogPost?> createElement() {
    return _BlogPostProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BlogPostProvider && other.postId == postId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, postId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BlogPostRef on AutoDisposeFutureProviderRef<BlogPost?> {
  /// The parameter `postId` of this provider.
  String get postId;
}

class _BlogPostProviderElement
    extends AutoDisposeFutureProviderElement<BlogPost?> with BlogPostRef {
  _BlogPostProviderElement(super.provider);

  @override
  String get postId => (origin as BlogPostProvider).postId;
}

String _$blogPostsStreamHash() => r'b684fda0d6be972f4eee48732f0d88ada5a77ab3';

/// See also [blogPostsStream].
@ProviderFor(blogPostsStream)
final blogPostsStreamProvider =
    AutoDisposeStreamProvider<List<BlogPost>>.internal(
  blogPostsStream,
  name: r'blogPostsStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$blogPostsStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BlogPostsStreamRef = AutoDisposeStreamProviderRef<List<BlogPost>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
