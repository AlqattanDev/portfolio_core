# Development Guidelines for portfolio_core

## Build & Run Commands
- `flutter run` - Run app in debug mode
- `flutter build web` - Build for web deployment
- `flutter pub get` - Install dependencies

## Lint & Format Commands
- `flutter analyze` - Run static analysis
- `dart format lib/` - Format code

## Test Commands
- `flutter test` - Run all tests
- `flutter test test/widget_test.dart` - Run a specific test file
- `flutter test --name="Test name"` - Run a specific test by name
- `flutter test --coverage` - Run tests with coverage

## Code Style Guidelines

### Imports
Order: 1) Dart SDK, 2) Flutter, 3) Third-party packages, 4) Project imports

### Formatting
- Use `dart format` for consistent formatting
- Maximum line length: 80 characters
- Use trailing commas for better formatting

### Types
- Use strong typing where possible
- Declare parameter and return types for public methods
- Use `const` constructors when appropriate

### Naming Conventions
- Classes/Types: `UpperCamelCase`
- Files/Directories: `snake_case`
- Variables/Methods: `lowerCamelCase`
- Private members: `_prefixWithUnderscore`

### Widget Structure
- Constructor and properties at top
- Private methods/variables in middle
- `build` method at bottom
- Use keys for stateful widgets when needed

### Error Handling
- Use specific exceptions over generic ones
- Handle errors at appropriate boundaries
- Leverage Flutter's error reporting system