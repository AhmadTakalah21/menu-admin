import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';

class MainTextField extends StatefulWidget {
  const MainTextField({
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
    this.showCloseIcon,
  });

  final String? hintText;
  final String? initialText;
  final ValueSetter<String>? onChanged;
  final ValueSetter<String>? onSubmitted;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;
  final EdgeInsets? padding;
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
  final bool? showCloseIcon;

  @override
  State<MainTextField> createState() => _MainTextFieldState();
}

class _MainTextFieldState extends State<MainTextField> {
  late Color? floatingLabelColor = widget.floatingLabelColor;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialText);
  }

  @override
  Widget build(BuildContext context) {
    final suffixIcon = widget.suffixIcon;
    final showCloseIcon = widget.showCloseIcon ?? true;

    return TextFormField(
      controller: _controller,
      obscureText: widget.obscureText,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      onChanged: (text) {
        widget.onChanged?.call(text);
        setState(() {});
      },
      onFieldSubmitted: widget.onSubmitted,
      focusNode: widget.focusNode,
      keyboardType: widget.textInputType ?? TextInputType.name,
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(
        contentPadding: widget.padding,
        labelText: widget.labelText,
        floatingLabelStyle: TextStyle(
          color: widget.errorText == null
              ? floatingLabelColor ?? AppColors.blue
              : AppColors.red,
        ),
        labelStyle: TextStyle(
          color: widget.errorText == null ? AppColors.grey : AppColors.red,
          fontSize: 14,
        ),
        hintText: widget.hintText,
        hintStyle: widget.hintStyle ??
            const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              height: 1.19,
            ),
        errorStyle: const TextStyle(
          fontSize: 16,
          color: AppColors.red,
        ),
        errorText: widget.errorText,
        border: widget.outlineInputBorder ??
            OutlineInputBorder(
              borderRadius: widget.borderRadius ?? AppConstants.borderRadius5,
              borderSide: BorderSide(
                color: widget.borderColor ?? AppColors.grey.withOpacity(0.5),
              ),
            ),
        focusedBorder: widget.outlineInputBorder ??
            OutlineInputBorder(
              borderRadius: widget.borderRadius ?? AppConstants.borderRadius5,
              borderSide: BorderSide(
                color: widget.borderColor ?? AppColors.blue,
              ),
            ),
        enabledBorder: widget.outlineInputBorder ??
            OutlineInputBorder(
              borderRadius: widget.borderRadius ?? AppConstants.borderRadius5,
              borderSide: BorderSide(
                color: widget.borderColor ?? AppColors.grey.withOpacity(0.5),
              ),
            ),
        errorBorder: widget.outlineInputBorder ??
            OutlineInputBorder(
              borderRadius: widget.borderRadius ?? AppConstants.borderRadius5,
              borderSide: const BorderSide(color: AppColors.red),
            ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (suffixIcon != null) suffixIcon,
            if (_controller.text.isNotEmpty && showCloseIcon)
              IconButton(
                onPressed: () {
                  _controller.clear();
                  widget.onChanged?.call("");
                  widget.onClearTap?.call();
                  setState(() {});
                },
                icon: const Icon(Icons.close),
              ),
          ],
        ),
        fillColor: widget.fillColor,
        filled: widget.filled,
      ),
    );
  }
}
