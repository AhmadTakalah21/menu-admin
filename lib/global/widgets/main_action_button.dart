import 'package:flutter/material.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';

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
    this.textDecoration,
    this.margin,
    this.isLoading = false,
    this.isTextExpanded = false,
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
  final EdgeInsets? margin;
  final Widget? child;
  final Icon? icon;
  final TextDecoration? textDecoration;
  final bool isLoading; // ✅ NEW
  final bool isTextExpanded;

  @override
  State<MainActionButton> createState() => _MainActionButtonState();
}

class _MainActionButtonState extends State<MainActionButton> {
  static double calcSize(BuildContext context, double size) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      return (size / 390) * screenWidth / 1.2;
    }
    return (size / 390) * screenWidth;
  }

  @override
  Widget build(BuildContext context) {
    final icon = widget.icon;
    final textWidget = Text(
      widget.text,
      style: TextStyle(
        color: widget.textColor ?? AppColors.white,
        height: 1.19,
        fontSize: widget.fontSize ?? calcSize(context, 16),
        fontWeight: widget.fontWeight ?? FontWeight.w700,
        decoration: widget.textDecoration,
        decorationThickness: 4,
      ),
      textAlign: TextAlign.center,
      overflow: TextOverflow.fade,
    );
    final expandedText =
        widget.isTextExpanded ? Expanded(child: textWidget) : textWidget;
    return InkWell(
      onTap: widget.isLoading ? null : widget.onPressed,
      child: Container(
        height: widget.height,
        width: widget.width,
        margin: widget.margin,
        padding: widget.padding ?? AppConstants.paddingH36V12,
        decoration: BoxDecoration(
          border: widget.border,
          color: widget.buttonColor ?? const Color(0xFF2F4B26),
          borderRadius: widget.borderRadius ?? AppConstants.borderRadius10,
          boxShadow: widget.shadow,
        ),
        child: Center(
          child: widget.isLoading
              ? const LoadingIndicator(size: 25)
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widget.child ?? expandedText,
                    if (icon != null) const SizedBox(width: 10),
                    if (icon != null) icon
                  ],
                ),
        ),
      ),
    );
  }
}
