import 'package:flutter/material.dart';
import 'package:user_admin/global/utils/app_colors.dart';

class InfoTile extends StatelessWidget {
  const InfoTile(
    this.title,
    this.info, {
    super.key,
    this.titleColor,
    this.infoColor,
    this.titleFontWeight,
    this.titleSize,
  });

  final String title;
  final String info;
  final Color? titleColor;
  final FontWeight? titleFontWeight;
  final double? titleSize;
  final Color? infoColor;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: "$title : ",
        style: TextStyle(
          color: titleColor,
          fontSize: titleSize ?? (titleColor != null ? 16 : null),
          fontWeight:
              titleFontWeight ?? (titleColor != null ? FontWeight.w500 : null),
        ),
        children: [
          TextSpan(
            text: info,
            style: TextStyle(
              color: infoColor ?? AppColors.black,
              fontWeight: FontWeight.w400,
              fontSize: titleColor != null ? 17 : null,
            ),
          ),
        ],
      ),
    );
  }
}
