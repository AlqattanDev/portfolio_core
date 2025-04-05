import 'package:flutter/material.dart';
import 'package:portfolio_core/services/auth_service.dart';
import 'package:portfolio_core/theme/colors.dart'; // Import AppColors
import 'package:portfolio_core/theme/simplified_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart'; // Add this import for kDebugMode

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return; // Don't proceed if form is invalid
    }

    // Access AuthService - listen: false as we only call a method
    // Ensure context is valid before accessing Provider
    if (!mounted) return;
    final authService = Provider.of<AuthService>(context, listen: false);

    final success = await authService.login(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success && mounted) {
      // Navigate back or to home screen on successful login
      Navigator.pop(context); // Assuming it was pushed onto the stack
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Login Successful!'),
            backgroundColor: AppColors.success), // Use semantic color
      );
    }
    // Error messages are handled by listening to authService.errorMessage below
    // If login fails, the error message will appear automatically due to the listener
  }

  // Auto-login function for development
  Future<void> _autoLogin() async {
    if (!kDebugMode) return; // Only run in debug mode

    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Access AuthService
    if (!mounted) return;
    final authService = Provider.of<AuthService>(context, listen: false);

    await authService.debugLogin(); // Call the debug login method

    // Check if mounted again after async gap
    if (mounted && authService.isAuthenticated) {
      // Navigate back or to home screen on successful login
      Navigator.pop(context); // Assuming it was pushed onto the stack
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Debug Login Successful!'),
            backgroundColor: AppColors.warning), // Use semantic color
      );
    }
    // Error messages from debugLogin are handled by the listener
  }

  // Development helper function - REMOVE FOR PRODUCTION
  Future<void> _createTestAccount() async {
    try {
      // Access AuthService
      if (!mounted) return;
      final authService = Provider.of<AuthService>(context, listen: false);

      // Fixed test account credentials
      const testEmail = "test@example.com";
      const testPassword = "Test123!";

      final success = await authService.createAccount(testEmail, testPassword);

      if (success && mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Test account created successfully!\nEmail: test@example.com\nPassword: Test123!'),
            backgroundColor: AppColors.success, // Use semantic color
            duration: Duration(seconds: 10),
          ),
        );

        // Pre-fill the login form with the test account details
        _usernameController.text = testEmail;
        _passwordController.text = testPassword;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating test account: ${e.toString()}'),
            backgroundColor: AppColors.error, // Use semantic color
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to AuthService for loading state and error messages
    final authService = Provider.of<AuthService>(context);
    final themeExtension =
        Theme.of(context).extension<PortfolioThemeExtension>()!;
    final isRetro = themeExtension.cardBorderRadius == 0;
    final inputBorder =
        isRetro ? const UnderlineInputBorder() : const OutlineInputBorder();
    final devButtonColor =
        isRetro ? Theme.of(context).colorScheme.secondary : AppColors.warning;
    // For retro themes, onSecondary is usually the background color (e.g., black/dark green)
    // For the warning button, we need explicit white text for contrast.
    final devButtonForegroundColor = isRetro ? null : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          // Prevent overflow on small screens
          padding: Theme.of(context)
              .extension<PortfolioThemeExtension>()!
              .screenPadding,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Admin Login', // Or more generic title
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Display "Login with your email" instructions
                Text(
                  'Please enter your email address and password to login.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Display error message if any
                // Use Consumer or Selector for more targeted rebuilds if needed
                if (authService.errorMessage != null)
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: Theme.of(context)
                            .extension<PortfolioThemeExtension>()!
                            .itemSpacing),
                    child: Text(
                      authService.errorMessage!,
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                  ),

                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    // Use variable border
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: inputBorder,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    // Basic email validation
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  enabled: !authService.isLoading,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    // Use variable border
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: inputBorder,
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  enabled: !authService.isLoading,
                  onFieldSubmitted: (_) => authService.isLoading
                      ? null
                      : _login(), // Allow login via keyboard action
                ),
                const SizedBox(height: 24),
                authService.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton.icon(
                        icon: const Icon(Icons.login),
                        label: const Text('Login'),
                        onPressed: _login,
                        // Remove explicit style to use theme's ElevatedButtonThemeData
                      ),
                // Add Auto Login button only in debug mode
                if (kDebugMode) ...[
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.auto_fix_high),
                    label: const Text('Auto Login (Dev)'),
                    onPressed: authService.isLoading ? null : _autoLogin,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: devButtonColor, // Use conditional color
                      foregroundColor:
                          devButtonForegroundColor, // Use conditional foreground
                      textStyle: Theme.of(context).textTheme.titleMedium,
                    ).merge(Theme.of(context)
                        .elevatedButtonTheme
                        .style), // Merge with base theme style if needed
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      // Add a floating action button for development to create a test account
      floatingActionButton: kDebugMode // Show only in debug mode
          ? FloatingActionButton.extended(
              onPressed: _createTestAccount,
              icon: const Icon(Icons.admin_panel_settings),
              label: const Text('Create Test Account'),
              backgroundColor: devButtonColor, // Use conditional color
              foregroundColor:
                  devButtonForegroundColor, // Use conditional foreground
            )
          : null,
    );
  }
}
