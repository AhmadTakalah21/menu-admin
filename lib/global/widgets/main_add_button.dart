import 'package:flutter/material.dart';
import 'package:user_admin/global/utils/app_colors.dart';

class MainAddButton extends StatelessWidget {
  const MainAddButton({
    super.key,
    required this.onTap,
    this.color = const Color(0xFFE3170A),
    this.heroTag,
    this.tooltip,
  });

  final VoidCallback onTap;
  final Color color;
  final Object? heroTag;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag,
      tooltip: tooltip ?? 'Add',
      backgroundColor: AppColors.white,
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: CircleAvatar(
          backgroundColor: color,
          child: const Icon(Icons.add, color: AppColors.white),
        ),
      ),
    );
  }
}
