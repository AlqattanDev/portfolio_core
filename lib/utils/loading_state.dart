/// Represents various loading states for UI components
enum LoadingState {
  /// Initial state, no loading activity
  idle,

  /// Loading data or performing an operation
  loading,

  /// Successfully completed operation
  success,

  /// Operation failed
  error
}

/// Helper class for state objects with loading state management
class LoadingStateData<T> {
  /// Current loading state
  final LoadingState state;

  /// Data associated with the state (if any)
  final T? data;

  /// Error message in case of error state
  final String? errorMessage;

  const LoadingStateData({
    this.state = LoadingState.idle,
    this.data,
    this.errorMessage,
  });

  /// Create a copy with modified properties
  LoadingStateData<T> copyWith({
    LoadingState? state,
    T? data,
    String? errorMessage,
  }) {
    return LoadingStateData<T>(
      state: state ?? this.state,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Create a loading state
  LoadingStateData<T> asLoading() {
    return copyWith(state: LoadingState.loading);
  }

  /// Create a success state with data
  LoadingStateData<T> asSuccess(T data) {
    return LoadingStateData<T>(
      state: LoadingState.success,
      data: data,
      errorMessage: null,
    );
  }

  /// Create an error state with message
  LoadingStateData<T> asError(String message) {
    return LoadingStateData<T>(
      state: LoadingState.error,
      errorMessage: message,
    );
  }

  /// Check if currently loading
  bool get isLoading => state == LoadingState.loading;

  /// Check if operation completed successfully
  bool get isSuccess => state == LoadingState.success;

  /// Check if operation resulted in error
  bool get isError => state == LoadingState.error;

  /// Check if in idle state
  bool get isIdle => state == LoadingState.idle;
}
