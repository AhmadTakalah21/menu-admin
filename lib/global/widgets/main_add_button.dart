import 'package:flutter/material.dart';
import 'package:user_admin/global/utils/app_colors.dart';

class MainAddButton extends StatelessWidget {
  const MainAddButton({
    super.key,
    required this.onTap,
    this.color = const Color(0xFFE3170A),
    //required this.title,
  });
  final VoidCallback onTap;
  final Color color;
  //final String title;
  
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: "MainAddButton",
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
    // InkWell(
    //   onTap: onTap,
    //   borderRadius: BorderRadius.circular(22),
    //   child: Container(
    //     height: 36,
    //     padding: const EdgeInsetsDirectional.only(start: 12, end: 10),
    //     decoration: BoxDecoration(
    //       color: color,
    //       borderRadius: BorderRadius.circular(22),
    //       boxShadow: [
    //         BoxShadow(
    //           color: Colors.black.withOpacity(0.15),
    //           blurRadius: 8,
    //           offset: const Offset(0, 4),
    //         ),
    //       ],
    //     ),
    //     child: Row(
    //       children: [
    //         Text(
    //           title,
    //           style: const TextStyle(
    //             color: Colors.white,
    //             fontWeight: FontWeight.w800,
    //             fontSize: 14.5,
    //           ),
    //         ),
    //         const SizedBox(width: 8),
    //         CircleAvatar(
    //           radius: 11,
    //           backgroundColor: Colors.white,
    //           child: Icon(Icons.add, size: 16, color: color),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}
