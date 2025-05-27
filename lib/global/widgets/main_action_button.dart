import 'package:flutter/material.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';

class MainActionButton extends StatefulWidget {
  const MainActionButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.textColor,
    this.duration,
    this.buttonColor,
    this.width,
    this.border,
    this.height,
    this.fontSize,
    this.shadow,
    this.fontWeight,
    this.borderRadius,
    this.padding,
    this.child,
    this.icon,
  });

  final VoidCallback onPressed;
  final Duration? duration;
  final Color? buttonColor;
  final String text;
  final Color? textColor;
  final double? width;
  final double? height;
  final BoxBorder? border;
  final double? fontSize;
  final List<BoxShadow>? shadow;
  final FontWeight? fontWeight;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final Widget? child;
  final Icon? icon;

  @override
  State<MainActionButton> createState() => _MainActionButtonState();
}

class _MainActionButtonState extends State<MainActionButton> {
  @override
  Widget build(BuildContext context) {
    final icon = widget.icon;
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        height: widget.height,
        width: widget.width,
        padding: widget.padding ?? AppConstants.padding16,
        decoration: BoxDecoration(
          border: widget.border,
          color: widget.buttonColor ?? AppColors.mainColor,
          borderRadius: widget.borderRadius ?? AppConstants.borderRadius5,
          boxShadow: widget.shadow,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(icon != null) icon,
            if(icon != null) const SizedBox(width: 5),
            widget.child ??
                Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.textColor ?? AppColors.white,
                    height: 1.19,
                    fontSize: widget.fontSize ?? 16,
                    fontWeight: widget.fontWeight ?? FontWeight.w400,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
