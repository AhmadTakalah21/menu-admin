import 'package:flutter/material.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';

class AuthActionButton extends StatefulWidget {
  const AuthActionButton({
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
  State<AuthActionButton> createState() => _AuthActionButtonState();
}

class _AuthActionButtonState extends State<AuthActionButton> {
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
        color: widget.textColor ?? const Color(0xFF1E1E1E),
        height: 1.19,
        fontSize: widget.fontSize ?? calcSize(context, 24),
        fontWeight: widget.fontWeight ?? FontWeight.w500,
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
        padding: widget.padding ?? AppConstants.padding14,
        decoration: BoxDecoration(
          border: widget.border ??
              Border.all(width: 1, color: const Color(0xFF2F4B26)),
          color: widget.buttonColor ?? const Color(0xFFBDD358),
          borderRadius: widget.borderRadius ?? AppConstants.borderRadius30,
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
