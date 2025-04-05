import 'dart:async'; // Import async for StreamSubscription
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:flutter/foundation.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Get FirebaseAuth instance
  User? _currentUser; // Store the current Firebase user
  StreamSubscription<User?>?
      _authStateSubscription; // Subscription to auth state changes

  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthService() {
    // Listen to authentication state changes
    _authStateSubscription = _auth.authStateChanges().listen((User? user) {
      _currentUser = user;
      _clearError(); // Clear any previous errors on auth state change
      _setLoading(false); // Ensure loading is false after state change
      notifyListeners(); // Notify listeners about the change
    });
  }

  // Override dispose to cancel the stream subscription
  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }

  // Login with email and password
  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Auth state listener will handle setting _currentUser and notifying
      return true; // Login successful (state change will confirm)
    } on FirebaseAuthException catch (e) {
      // Handle specific Firebase Auth errors
      String errorMessage;

      // User-friendly error messages
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        case 'too-many-requests':
          errorMessage =
              'Too many failed login attempts. Please try again later.';
          break;
        default:
          errorMessage = e.message ?? 'An unknown error occurred during login.';
      }

      _setError(errorMessage);
      _setLoading(false);
      return false;
    } catch (e) {
      // Handle other potential errors
      _setError('An unexpected error occurred during authentication.');
      _setLoading(false);
      return false;
    }
  }

  // Logout the current user
  Future<void> logout() async {
    _setLoading(true); // Indicate loading during logout
    _clearError();
    try {
      await _auth.signOut();
      // Auth state listener will handle setting _currentUser to null and notifying
    } catch (e) {
      // Handle potential errors during sign out
      _setError('An error occurred during logout.');
      _setLoading(false); // Ensure loading is reset on error
    }
    // Listener will set loading to false eventually
  }

  // Create a new account with email and password
  Future<bool> createAccount(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Auth state listener will handle setting _currentUser and notifying
      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      // User-friendly error messages
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'An account already exists with this email.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format.';
          break;
        case 'weak-password':
          errorMessage =
              'Password is too weak. Please use a stronger password.';
          break;
        case 'operation-not-allowed':
          errorMessage =
              'Account creation is not enabled. Please contact support.';
          break;
        default:
          errorMessage =
              e.message ?? 'An unknown error occurred during account creation.';
      }

      _setError(errorMessage);
      _setLoading(false);
      return false;
    } catch (e) {
      _setError('An unexpected error occurred during account creation.');
      _setLoading(false);
      return false;
    }
  }

  // Debug login method (for development/testing)
  Future<void> debugLogin() async {
    if (kDebugMode) {
      _setLoading(true);
      _clearError();
      // Simulate a logged-in user without actual Firebase auth
      // This requires a way to create a mock User object or bypass the check.
      // For simplicity, let's assume we can directly set _currentUser
      // In a real app, you might need a more robust mock or use a test account.
      // WARNING: This bypasses actual authentication. Use only in debug builds.
      _currentUser =
          _auth.currentUser; // Or create a mock User if needed and possible
      if (_currentUser == null) {
        // If no actual user is cached, we might need to simulate one.
        // This part is tricky without a mocking framework or test credentials.
        // For now, let's just log a warning if no user is available.
        print(
            'AuthService: debugLogin called, but no Firebase user is cached. Cannot simulate login.');
        _setError('Debug login failed: No cached user.');
        _setLoading(false);
        return; // Exit if we can't simulate
      }
      print(
          'AuthService: Simulating login for user: ${_currentUser?.email ?? _currentUser?.uid}');
      _setLoading(false);
      notifyListeners();
    } else {
      print(
          'AuthService: debugLogin called in release mode. Operation ignored.');
      // Optionally set an error or just do nothing in release mode
      _setError('Debug login is only available in debug mode.');
    }
  }

  // --- Helper methods for state management ---

  void _setLoading(bool loading) {
    // Avoid unnecessary notifications if state hasn't changed
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }
}
