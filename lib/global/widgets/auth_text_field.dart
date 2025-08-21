import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user_admin/global/utils/constants.dart';

import '../utils/app_colors.dart';

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.labelText,
    this.textInputType,
    this.hintText,
    this.inputFormatters,
    this.initialText,
    this.errorText,
    this.padding,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
    this.obscureText = false,
    this.controller,
    this.floatingLabelColor,
    this.hintStyle,
    this.borderRadius,
    this.borderColor,
    this.outlineInputBorder,
    this.fillColor,
    this.filled,
    this.onClearTap,
    this.showCloseIcon = true,
    this.hintColor,
    this.title,
    this.maxLines = 1,
    this.minLines,
    this.titlePadding,
    this.prefixIcon,
  });

  final String? hintText;
  final String? initialText;
  final String? title;
  final ValueSetter<String>? onChanged;
  final ValueSetter<String>? onSubmitted;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;
  final EdgeInsets? padding;
  final EdgeInsets? titlePadding;
  final String? labelText;
  final bool readOnly;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final Color? floatingLabelColor;
  final Color? borderColor;
  final Color? fillColor;
  final TextStyle? hintStyle;
  final BorderRadius? borderRadius;
  final InputBorder? outlineInputBorder;
  final bool? filled;
  final VoidCallback? onClearTap;
  final bool showCloseIcon;
  final Color? hintColor;
  final int? maxLines;
  final int? minLines;
  final IconData? prefixIcon;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late TextEditingController _controller;
  late bool _obscureText;
  late bool _showClearIcon;
  late Color floatingLabelColor;

  @override
  void initState() {
    super.initState();

    floatingLabelColor = widget.floatingLabelColor ?? AppColors.blue;
    _obscureText = widget.obscureText;

    _controller =
        widget.controller ?? TextEditingController(text: widget.initialText);
    _showClearIcon = _controller.text.isNotEmpty;

    _controller.addListener(_textListener);
  }

  void _textListener() {
    final hasText = _controller.text.isNotEmpty;
    if (_showClearIcon != hasText) {
      setState(() {
        _showClearIcon = hasText;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_textListener);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _toggleObscure() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  InputBorder _buildBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(28),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final borderColor = widget.borderColor ??
        (widget.errorText == null ? const Color(0xFF2F4B26) : AppColors.red);
    final fillColor = widget.filled == false
        ? Colors.transparent
        : widget.fillColor ??
            (widget.errorText == null
                ? const Color(0xFFF9FBB2).withValues(alpha: 0.6)
                : AppColors.red.withOpacity(0.1));
    final labelColor =
        widget.errorText == null ? floatingLabelColor : AppColors.red;
    final hintColor = widget.hintColor ?? Colors.grey.shade400;
    final textColor = widget.readOnly ? Colors.grey.shade700 : AppColors.black;

    final suffixWidgets = <Widget>[];

    if (widget.obscureText) {
      suffixWidgets.add(
        IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: AppColors.black,
            size: 22,
          ),
          onPressed: _toggleObscure,
          splashRadius: 20,
          tooltip: _obscureText ? "Show Password" : "Hide Password",
        ),
      );
    }

    if (widget.suffixIcon != null) {
      suffixWidgets.add(widget.suffixIcon!);
    }

    if (_showClearIcon && widget.showCloseIcon && !widget.readOnly) {
      suffixWidgets.add(
        IconButton(
          icon: const Icon(Icons.close, color: AppColors.black, size: 20),
          onPressed: () {
            _controller.clear();
            widget.onChanged?.call('');
            widget.onClearTap?.call();
          },
          splashRadius: 20,
          tooltip: "Clear",
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          Padding(
            padding: widget.titlePadding ?? AppConstants.paddingH20,
            child: Text(
              widget.title!,
              style: TextStyle(
                color: widget.borderColor ?? const Color(0xFF2F4B26),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
        TextFormField(
          initialValue: widget.controller == null ? widget.initialText : null,
          controller: widget.controller ?? _controller,
          obscureText: _obscureText,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          focusNode: widget.focusNode,
          keyboardType: widget.textInputType ?? TextInputType.text,
          inputFormatters: widget.inputFormatters,
          cursorColor: floatingLabelColor,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          style: TextStyle(
            fontSize: screenWidth / 25,
            color: textColor,
            height: 1.3,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: widget.padding ??
                const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
            labelText: widget.labelText,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            floatingLabelStyle: TextStyle(
              fontSize: screenWidth / 26,
              color: labelColor,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
            labelStyle: TextStyle(
              color: widget.errorText == null
                  ? Colors.grey.shade400
                  : AppColors.red,
              fontSize: screenWidth / 30,
            ),
            hintText: widget.hintText,
            hintStyle: widget.hintStyle ??
                TextStyle(
                  fontSize: screenWidth / 30,
                  fontWeight: FontWeight.w400,
                  height: 1.2,
                  color: hintColor,
                ),
            errorStyle: TextStyle(
              fontSize: screenWidth / 35,
              color: AppColors.red,
              fontWeight: FontWeight.w600,
            ),
            errorText: widget.errorText,
            border: widget.outlineInputBorder ??
                _buildBorder(borderColor.withOpacity(0.5)),
            focusedBorder: widget.outlineInputBorder ??
                _buildBorder(floatingLabelColor, width: 2),
            enabledBorder: widget.outlineInputBorder ??
                _buildBorder(borderColor.withOpacity(0.5)),
            errorBorder: widget.outlineInputBorder ??
                _buildBorder(AppColors.red, width: 2),
            focusedErrorBorder: widget.outlineInputBorder ??
                _buildBorder(AppColors.red, width: 2),
            filled: widget.filled ?? true,
            fillColor: fillColor,
            prefixIcon: widget.prefixIcon != null
                ? Icon(
                    widget.prefixIcon,
                    color: widget.borderColor,
                    size: 25,
                  )
                : null,
            suffixIcon: suffixWidgets.isNotEmpty
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: suffixWidgets
                        .map((w) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: w,
                            ))
                        .toList(),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
