import 'package:flutter/material.dart';

/// Error categories for better organization and handling
enum ErrorCategory {
  auth, // Authentication errors
  network, // Network/connectivity issues
  data, // Data processing/parsing errors
  validation, // Input validation errors
  permission, // Permission-related errors
  unknown // Fallback for uncategorized errors
}

/// Centralized error handling utility
class ErrorHandler {
  /// Convert any exception to a user-friendly message
  static String getMessageFromError(dynamic error, [ErrorCategory? category]) {
    // Determine category if not provided
    final errorCategory = category ?? _getCategoryFromError(error);

    // Handle based on category
    switch (errorCategory) {
      case ErrorCategory.auth:
        return _getAuthErrorMessage(error);
      case ErrorCategory.network:
        return _getNetworkErrorMessage(error);
      case ErrorCategory.data:
        return _getDataErrorMessage(error);
      case ErrorCategory.validation:
        return _getValidationErrorMessage(error);
      case ErrorCategory.permission:
        return _getPermissionErrorMessage(error);
      case ErrorCategory.unknown:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  /// Show error in a SnackBar with appropriate styling
  static void showErrorSnackBar(BuildContext context, dynamic error,
      [ErrorCategory? category]) {
    final message = getMessageFromError(error, category);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Determine error category based on the error type
  static ErrorCategory _getCategoryFromError(dynamic error) {
    if (error.toString().contains('auth') ||
        error.toString().contains('sign') ||
        error.toString().contains('login')) {
      return ErrorCategory.auth;
    } else if (error.toString().contains('network') ||
        error.toString().contains('connection') ||
        error.toString().contains('timeout')) {
      return ErrorCategory.network;
    } else if (error.toString().contains('permission') ||
        error.toString().contains('access')) {
      return ErrorCategory.permission;
    } else if (error.toString().contains('valid') ||
        error.toString().contains('required')) {
      return ErrorCategory.validation;
    } else if (error.toString().contains('data') ||
        error.toString().contains('parse')) {
      return ErrorCategory.data;
    }

    return ErrorCategory.unknown;
  }

  // Category-specific error message generators
  static String _getAuthErrorMessage(dynamic error) {
    final message = error.toString().toLowerCase();

    if (message.contains('invalid email') || message.contains('email format')) {
      return 'The email address is not valid.';
    } else if (message.contains('wrong password') ||
        message.contains('incorrect password')) {
      return 'Incorrect password. Please try again.';
    } else if (message.contains('user not found')) {
      return 'Account not found. Please check your email or sign up.';
    } else if (message.contains('email already in use')) {
      return 'This email is already registered. Please sign in instead.';
    } else {
      return 'Authentication failed. Please try again.';
    }
  }

  static String _getNetworkErrorMessage(dynamic error) {
    final message = error.toString().toLowerCase();

    if (message.contains('timeout')) {
      return 'Connection timed out. Please check your internet and try again.';
    } else if (message.contains('connection failed') ||
        message.contains('no internet')) {
      return 'No internet connection. Please check your network settings.';
    } else {
      return 'Network error. Please check your connection and try again.';
    }
  }

  static String _getDataErrorMessage(dynamic error) {
    return 'Error processing data. Please try again or contact support.';
  }

  static String _getValidationErrorMessage(dynamic error) {
    final message = error.toString().toLowerCase();

    if (message.contains('required')) {
      return 'Please fill in all required fields.';
    } else {
      return 'Invalid input. Please check your information and try again.';
    }
  }

  static String _getPermissionErrorMessage(dynamic error) {
    return 'You don\'t have permission to perform this action.';
  }
}
