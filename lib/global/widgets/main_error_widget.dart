import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MainErrorWidget extends StatelessWidget {
  const MainErrorWidget({
    super.key,
    required this.error,
    this.onTryAgainTap,
    this.height,
    this.tryAgainTitle,
    this.fontSize,
    this.isRefresh = false,
    this.buttonColor,
    this.textColor,
  });

  final String error;
  final VoidCallback? onTryAgainTap;
  final double? height;
  final String? tryAgainTitle;
  final double? fontSize;

  final bool isRefresh;

  final Color? buttonColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = buttonColor ?? theme.colorScheme.primary;
    final onPrimary = textColor ?? theme.colorScheme.onPrimary;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (height != null) SizedBox(height: height),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.sizeOf(context).width - 60,
            ),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: fontSize,
                color: theme.colorScheme.onSurface.withOpacity(.8),
              ),
            ),
          ),
          if (onTryAgainTap != null) const SizedBox(height: 12),
          if (onTryAgainTap != null)
            isRefresh
                ? ElevatedButton.icon(
              onPressed: onTryAgainTap,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(tryAgainTitle ?? 'refresh'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: onPrimary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                shape: const StadiumBorder(),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.5,
                ),
              ),
            )
                : TextButton(
              onPressed: onTryAgainTap,
              style: TextButton.styleFrom(
                foregroundColor: primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.5,
                ),
              ),
              child: Text(tryAgainTitle ?? 'try_again'.tr()),
            ),
        ],
      ),
    );
  }
}
