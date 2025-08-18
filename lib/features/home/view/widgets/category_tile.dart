import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:user_admin/global/localization/supported_locales.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/app_image_widget.dart';

abstract class ItemTileModel {
  String get nameEn;
  String get nameAr;
  String get image;
  bool get isActive;
}

class CategoryTile<T extends ItemTileModel> extends StatefulWidget {
  const CategoryTile({
    super.key,
    required this.item,
    required this.restaurant,
    required this.locale,
    this.onTap,
    this.onAddToCart,
    this.onShowDetailsTap,
    this.onEditTap,
    this.onDeleteTap,
    this.onDeactivateTap,
    this.onMoreOptionsTap,
  });

  final T item;
  final RestaurantModel restaurant;
  final Locale locale;
  final void Function(T item)? onTap;
  final void Function(T item)? onAddToCart;
  final void Function(T item)? onShowDetailsTap;
  final void Function(T item)? onEditTap;
  final void Function(T item)? onDeleteTap;
  final void Function(T item)? onMoreOptionsTap;
  final Future<bool> Function(T item)? onDeactivateTap;

  @override
  State<CategoryTile<T>> createState() => _CategoryTileState<T>();
}

class _CategoryTileState<T extends ItemTileModel>
    extends State<CategoryTile<T>> {
  // bool isActive = true;
  late bool isActive = widget.item.isActive;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onTap?.call(widget.item),
      child: Container(
        padding: AppConstants.padding4,
        decoration: const BoxDecoration(
          color: Color(0xFFD9D9D9),
          borderRadius: AppConstants.borderRadius20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 4 / 2.8,
              child: AppImageWidget(
                fit: BoxFit.cover,
                borderRadius: AppConstants.borderRadius15,
                backgroundColor: widget.restaurant.color,
                url: widget.item.image,
                errorWidget: Center(
                  child: Text(
                    "no_image".tr(),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    final name = widget.locale == SupportedLocales.english
        ? widget.item.nameEn
        : widget.item.nameAr;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (widget.onShowDetailsTap != null)
          _ActionIcon(
            icon: Icons.remove_red_eye_outlined,
            onPressed: () => widget.onShowDetailsTap!(widget.item),
          ),
        if (widget.onEditTap != null)
          _ActionIcon(
            icon: Icons.edit_outlined,
            onPressed: () => widget.onEditTap!(widget.item),
          ),
          if (widget.onAddToCart != null)
          _ActionIcon(
            icon: Icons.add_shopping_cart_outlined,
            onPressed: () => widget.onAddToCart!(widget.item),
          ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              child: Text(
                name,
                style: TextStyle(
                  color: widget.restaurant.color,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (widget.onDeactivateTap != null)
              CustomSwitch(
                value: isActive,
                onChanged: (val) => widget.onDeactivateTap?.call(widget.item),
              )
          ],
        ),
        if (widget.onDeleteTap != null)
          _ActionIcon(
            icon: Icons.delete_outline_outlined,
            onPressed: () => widget.onDeleteTap!(widget.item),
          ),
        if (widget.onMoreOptionsTap != null)
          _ActionIcon(
            icon: Icons.more_vert_outlined,
            onPressed: () => widget.onMoreOptionsTap!(widget.item),
          ),
      ],
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: DecoratedBox(
          decoration: const BoxDecoration(
              color: Color(0xFFBDD358),
              borderRadius: AppConstants.borderRadius5),
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Icon(icon, size: 25),
          )),
    );
  }
}

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double height;
  final double width;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;

  const CustomSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.height = 20,
    this.width = 80,
    this.activeColor = const Color(0xFF000000),
    this.inactiveColor = const Color(0xFFBDD358),
    this.thumbColor = Colors.white,
  });

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onChanged(!widget.value),
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
            color: widget.value ? widget.activeColor : widget.inactiveColor,
            borderRadius: AppConstants.borderRadius10,
            border: Border.all(width: 1.5, color: AppColors.white)),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment:
              widget.value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: widget.width / 2,
            decoration: BoxDecoration(
              color: widget.thumbColor,
              borderRadius: AppConstants.borderRadius10,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
