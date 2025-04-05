# Utility Classes

This directory contains utility classes that provide common functionality across the application.

## Error Handling

`error_handler.dart` provides consistent error handling through:

- Error categorization by type (auth, network, data, etc.)
- User-friendly error messages
- Standardized SnackBar error display

```dart
// Example usage:
try {
  // Some operation that might fail
} catch (error) {
  // Get user-friendly message
  final message = ErrorHandler.getMessageFromError(error);
  
  // Or show in a SnackBar
  ErrorHandler.showErrorSnackBar(context, error);
}
```

## Loading State

`loading_state.dart` provides a consistent way to manage loading states:

- `LoadingState` enum with states: idle, loading, success, error
- `LoadingStateData<T>` generic class for managing data with loading state

```dart
// Example usage:
LoadingStateData<User> _userState = const LoadingStateData();

// Set as loading
setState(() => _userState = _userState.asLoading());

// Set as success with data
setState(() => _userState = _userState.asSuccess(user));

// Set as error
setState(() => _userState = _userState.asError("Error message"));

// Check states
if (_userState.isLoading) { /* Show spinner */ }
if (_userState.isSuccess) { /* Show data */ }
if (_userState.isError) { /* Show error message */ }
```

## Async Helper

`async_helper.dart` simplifies async operations:

- Standardized loading state management
- Automatic error handling
- Mounted check handling

```dart
// Example usage for operations with state:
AsyncHelper.execute<User>(
  operation: () => userService.getUser(userId),
  setStateCallback: (state) => setState(() => _userState = state),
  context: context,
  mounted: mounted,
  onSuccess: (user) {
    // Handle success
  },
);

// Example usage with loading indicator:
final result = await AsyncHelper.withLoadingIndicator<User>(
  context: context,
  operation: () => userService.getUser(userId),
  successMessage: 'User loaded successfully!',
);
```

## Import All Utilities

Use the index.dart file to import all utilities at once:

```dart
import 'package:portfolio_core/utils/index.dart';
``` 