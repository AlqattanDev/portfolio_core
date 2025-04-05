import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  /// Launches a URL in the default browser
  static Future<bool> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return true;
    }
    return false;
  }

  /// Launches an email URL
  static Future<bool> openEmail(String email) async {
    return openUrl('mailto:$email');
  }

  /// Handles Markdown link taps
  static Future<void> handleMarkdownLinkTap(
    BuildContext context,
    String text,
    String? href,
    String title,
  ) async {
    if (href != null) {
      final success = await openUrl(href);
      if (!success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open link: $href')),
        );
      }
    }
  }
}
