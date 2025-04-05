import 'package:flutter/material.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';

class PortfolioTabView extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final CrossAxisAlignment crossAxisAlignment;

  const PortfolioTabView({
    super.key,
    required this.title,
    required this.children,
    this.padding,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: padding ??
          Theme.of(context).extension<PortfolioThemeExtension>()!.screenPadding,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          // Header
          Text(
            title,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: 24),

          // Content
          ...children,
        ],
      ),
    );
  }
}
