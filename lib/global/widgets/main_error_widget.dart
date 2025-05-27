import 'package:flutter/material.dart';
import 'package:user_admin/global/utils/app_colors.dart';

class MainErrorWidget extends StatelessWidget {
  const MainErrorWidget({
    super.key,
    required this.error,
    this.onTryAgainTap,
  });

  final String error;
  final VoidCallback? onTryAgainTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(error),
        const SizedBox(height: 10),
        if (onTryAgainTap != null)
          InkWell(
            onTap: onTryAgainTap,
            child: const Text(
              "Try Again",
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
      ],
    );
  }
}
