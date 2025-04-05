import 'package:flutter/material.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:portfolio_core/services/url_launcher_service.dart';

class MarkdownPreviewView extends StatelessWidget {
  final TextEditingController controller;

  const MarkdownPreviewView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('preview_view'),
      padding:
          Theme.of(context).extension<PortfolioThemeExtension>()!.smallPadding,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(4.0),
      ),
      // Use a Scrollbar for potentially long previews
      child: Scrollbar(
        child: SingleChildScrollView(
          // Ensure preview area is scrollable
          child: MarkdownBody(
            data: controller.text.isEmpty
                ? "*Preview will appear here...*" // Placeholder if empty
                : controller.text,
            selectable: true,
            onTapLink: (text, href, title) =>
                UrlLauncherService.handleMarkdownLinkTap(
                    context, text, href, title),
          ),
        ),
      ),
    );
  }
}
