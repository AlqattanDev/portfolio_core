import 'package:flutter/material.dart';
import 'package:portfolio_core/theme/colors.dart'; // Import AppColors
import 'package:portfolio_core/utils/error_handler.dart';
import 'package:portfolio_core/utils/loading_state.dart';

/// Helper utility for handling async operations consistently
class AsyncHelper {
  /// Executes an async operation with proper loading state management
  ///
  /// [operation] - The async operation to execute
  /// [setStateCallback] - Callback to update state with new loading state
  /// [onSuccess] - Optional callback to handle success case
  /// [onError] - Optional callback to handle error case
  /// [context] - Optional BuildContext for showing error messages
  /// [mounted] - Whether the widget is still mounted
  static Future<T?> execute<T>({
    required Future<T> Function() operation,
    required Function(LoadingStateData<T> state) setStateCallback,
    Function(T result)? onSuccess,
    Function(dynamic error)? onError,
    BuildContext? context,
    bool mounted = true,
  }) async {
    // Set loading state
    setStateCallback(LoadingStateData<T>().asLoading());

    try {
      // Execute operation
      final result = await operation();

      // Check if widget is still mounted before updating state
      if (!mounted) return null;

      // Set success state
      setStateCallback(LoadingStateData<T>().asSuccess(result));

      // Call success callback if provided
      if (onSuccess != null) {
        onSuccess(result);
      }

      return result;
    } catch (error) {
      // Check if widget is still mounted before updating state
      if (!mounted) return null;

      // Get error message
      final errorMessage = ErrorHandler.getMessageFromError(error);

      // Set error state
      setStateCallback(LoadingStateData<T>().asError(errorMessage));

      // Show error in SnackBar if context is provided
      if (context != null) {
        ErrorHandler.showErrorSnackBar(context, error);
      }

      // Call error callback if provided
      if (onError != null) {
        onError(error);
      }

      return null;
    }
  }

  /// Shows a loading indicator while performing an async operation
  ///
  /// [context] - BuildContext for showing loading indicator
  /// [operation] - The async operation to execute
  /// [successMessage] - Optional message to show on success
  ///
  /// Returns the result of the operation, or null if it failed
  static Future<T?> withLoadingIndicator<T>({
    required BuildContext context,
    required Future<T> Function() operation,
    String? successMessage,
  }) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Execute operation
      final result = await operation();

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();

        // Show success message if provided
        if (successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(successMessage),
              backgroundColor: AppColors.success, // Use semantic color
            ),
          );
        }
      }

      return result;
    } catch (error) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
        ErrorHandler.showErrorSnackBar(context, error);
      }

      return null;
    }
  }

  /// Shows a loading indicator for operations that don't return a value
  ///
  /// Same as withLoadingIndicator but specifically for void operations
  static Future<bool> withLoadingIndicatorVoid({
    required BuildContext context,
    required Future<void> Function() operation,
    String? successMessage,
  }) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Execute operation
      await operation();

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();

        // Show success message if provided
        if (successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(successMessage),
              backgroundColor: AppColors.success, // Use semantic color
            ),
          );
        }
      }

      return true;
    } catch (error) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
        ErrorHandler.showErrorSnackBar(context, error);
      }

      return false;
    }
  }
}
