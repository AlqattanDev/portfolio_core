import 'package:flutter/material.dart';
import 'package:portfolio_core/theme/simplified_theme.dart';

class ContactInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  final bool isClickable;
  final double iconSize;

  const ContactInfoItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
    this.isClickable = true,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: iconSize,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isClickable
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
              ),
            ],
          ),
        ),
        if (isClickable)
          Icon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).colorScheme.primary,
            size: 16,
          ),
      ],
    );

    final themeExtension =
        Theme.of(context).extension<PortfolioThemeExtension>()!;
    final isRetro = themeExtension.cardBorderRadius == 0;
    final borderRadius = isRetro
        ? BorderRadius.zero
        : BorderRadius.circular(12); // Use 12 for non-retro

    if (isClickable && onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: borderRadius, // Use conditional border radius
        child: Padding(
          padding: themeExtension.smallPadding,
          child: content,
        ),
      );
    } else {
      return Container(
        padding: Theme.of(context)
            .extension<PortfolioThemeExtension>()!
            .contentPadding,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(Theme.of(context)
              .extension<PortfolioThemeExtension>()!
              .cardBorderRadius),
        ),
        child: content,
      );
    }
  }
}
