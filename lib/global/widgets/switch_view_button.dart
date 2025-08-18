import 'package:flutter/material.dart';
import 'package:user_admin/global/utils/app_colors.dart';

class SwitchViewButton extends StatelessWidget {
  const SwitchViewButton({
    super.key,
    required this.onTap,
    this.color = const Color(0xFFE3170A),
    required this.isCardView,
  });

  final VoidCallback onTap;
  final Color color;
  final bool isCardView;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag:"SwitchViewButton",
      backgroundColor: color,
      onPressed: onTap,
      child:  Icon(
        isCardView? Icons.rectangle_outlined : Icons.table_view_outlined,
        color: AppColors.white,
        size: 35,
      ),
    );
  }
}
