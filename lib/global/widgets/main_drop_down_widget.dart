import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';

abstract class DropDownItemModel {
  String get displayName;

  int get id;
}

class MainDropDownWidget<T extends DropDownItemModel> extends StatefulWidget {
  const MainDropDownWidget({
    super.key,
    required this.items,
    required this.text,
    this.offsetY = 0,
    required this.onChanged,
    required this.focusNode,
    this.selectedValue,
    this.expandedHeight = 200,
    this.errorText,
    this.height,
    this.width,
    this.label,
    this.backgrounColor,
    this.color,
    this.onClearTap,
  });

  final List<T> items;
  final String text;
  final ValueSetter<T?> onChanged;
  final T? selectedValue;
  final double? expandedHeight;
  final String? errorText;
  final double offsetY;
  final FocusNode focusNode;
  final double? height;
  final double? width;
  final String? label;
  final Color? backgrounColor;
  final Color? color;
  final VoidCallback? onClearTap;

  @override
  State<MainDropDownWidget<T>> createState() => _MainDropDownWidgetState<T>();
}

class _MainDropDownWidgetState<T extends DropDownItemModel>
    extends State<MainDropDownWidget<T>> {
  late T? selectedValue = widget.selectedValue;

  @override
  Widget build(BuildContext context) {
    final errorText = widget.errorText;
    final label = widget.label;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: AppConstants.paddingH8,
            child: Text(label),
          ),
        if (label != null) const SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton2<T>(
                  iconStyleData: IconStyleData(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: widget.color,
                    ),
                  ),
                  focusNode: widget.focusNode,
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: widget.expandedHeight,
                    width: widget.width,
                    offset: Offset(0, widget.offsetY),
                  ),
                  buttonStyleData: ButtonStyleData(
                    height: widget.height,
                    padding: AppConstants.paddingH4,
                    decoration: BoxDecoration(
                      color: widget.backgrounColor,
                      border: Border.all(
                        color: errorText == null
                            ? AppColors.grey.withOpacity(0.5)
                            : AppColors.red,
                      ),
                      borderRadius: AppConstants.borderRadius5,
                    ),
                  ),
                  isExpanded: true,
                  value: selectedValue,
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.19,
                    overflow: TextOverflow.ellipsis,
                  ),
                  hint: Text(
                    widget.text,
                    style: TextStyle(
                      color: errorText == null
                          ? widget.color ?? AppColors.grey
                          : AppColors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.19,
                    ),
                  ),
                  items: widget.items
                      .map(
                        (T item) => DropdownMenuItem<T>(
                          value: item,
                          child: Text(
                            item.displayName,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                    widget.onChanged(value);
                  },
                ),
              ),
            ),
            if (selectedValue != null)
              IconButton(
                onPressed: () {
                  setState(() {
                    selectedValue = null;
                  });
                  widget.onChanged(null);
                },
                icon: const Icon(Icons.close),
              )
          ],
        ),
        if (errorText != null) const SizedBox(height: 8),
        if (errorText != null)
          Padding(
            padding: AppConstants.paddingH8,
            child: Text(
              errorText,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.red,
              ),
            ),
          )
      ],
    );
  }
}
