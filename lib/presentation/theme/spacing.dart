import 'package:flutter/material.dart';

/// Consistent spacing values for use throughout the application
class AppSpacing {
  /// Extra small spacing (4.0)
  static const double xs = 4.0;

  /// Small spacing (8.0)
  static const double small = 8.0;

  /// Medium spacing (16.0)
  static const double medium = 16.0;

  /// Large spacing (24.0)
  static const double large = 24.0;

  /// Extra large spacing (32.0)
  static const double xl = 32.0;

  /// Double extra large spacing (48.0)
  static const double xxl = 48.0;

  /// Standard content padding for screen edges
  static const EdgeInsets screenPadding = EdgeInsets.all(medium);

  /// Padding for cards and containers
  static const EdgeInsets containerPadding = EdgeInsets.all(small);

  /// Standard form field spacing
  static const double formFieldSpacing = medium;

  /// Button spacing in a row
  static const double buttonSpacing = small;

  /// Standard vertical spacing between sections
  static const double sectionSpacing = large;

  /// Responsive breakpoint for tablet layouts (700.0)
  static const double tabletBreakpoint = 700.0;

  /// Spacing methods for convenience

  /// Vertical spacer with specified height
  static SizedBox vSpace(double height) => SizedBox(height: height);

  /// Horizontal spacer with specified width
  static SizedBox hSpace(double width) => SizedBox(width: width);

  /// Extra small vertical spacer
  static const SizedBox vSpaceXS = SizedBox(height: xs);

  /// Small vertical spacer
  static const SizedBox vSpaceSmall = SizedBox(height: small);

  /// Medium vertical spacer
  static const SizedBox vSpaceMedium = SizedBox(height: medium);

  /// Large vertical spacer
  static const SizedBox vSpaceLarge = SizedBox(height: large);

  /// Extra small horizontal spacer
  static const SizedBox hSpaceXS = SizedBox(width: xs);

  /// Small horizontal spacer
  static const SizedBox hSpaceSmall = SizedBox(width: small);

  /// Medium horizontal spacer
  static const SizedBox hSpaceMedium = SizedBox(width: medium);

  /// Large horizontal spacer
  static const SizedBox hSpaceLarge = SizedBox(width: large);
}
