import 'package:flutter/material.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';

class MarkdownEditView extends StatelessWidget {
  final TextEditingController controller;

  const MarkdownEditView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('edit_view'),
      padding:
          Theme.of(context).extension<PortfolioThemeExtension>()!.smallPadding,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: TextField(
        controller: controller,
        maxLines: null, // Allows unlimited lines
        expands: true, // Fills available space
        keyboardType: TextInputType.multiline,
        decoration: const InputDecoration(
          hintText: 'Enter your Markdown here...',
          border: InputBorder.none, // Remove TextField's own border
          isDense: true, // Reduce padding
        ),
        style: const TextStyle(fontFamily: 'monospace'), // Use monospace font
        textAlignVertical: TextAlignVertical.top,
      ),
    );
  }
}
