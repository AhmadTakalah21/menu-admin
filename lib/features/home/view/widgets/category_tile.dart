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

class CategoryTile<T extends ItemTileModel> extends StatelessWidget {
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
  });

  final T item;
  final RestaurantModel restaurant;
  final Locale locale;
  final ValueSetter<T>? onTap;
  final ValueSetter<T>? onAddToCart;
  final ValueSetter<T>? onShowDetailsTap;
  final ValueSetter<T>? onEditTap;
  final ValueSetter<T>? onDeleteTap;
  final ValueSetter<T>? onDeactivateTap;

  @override
  Widget build(BuildContext context) {
    final name = locale == SupportedLocales.english ? item.nameEn : item.nameAr;

    return InkWell(
      onTap: () => onTap?.call(item),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: AppConstants.borderRadius10,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppImageWidget(
              fit: BoxFit.contain,
              borderRadius: AppConstants.borderRadius10,
              url: item.image,
              errorWidget: SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    "no_image".tr(),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              name,
              style: TextStyle(
                // color: restaurant.fColorCategory,
                color: Colors.black,

              overflow: TextOverflow.ellipsis,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            _buildActions(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (onShowDetailsTap != null)
          _ActionIcon(
            icon: Icons.remove_red_eye,
            onPressed: () => onShowDetailsTap!(item),
          ),
        if (onEditTap != null)
          _ActionIcon(
            icon: Icons.edit,
            onPressed: () => onEditTap!(item),
          ),
        if (onDeleteTap != null)
          _ActionIcon(
            icon: Icons.delete,
            onPressed: () => onDeleteTap!(item),
          ),
        if (onDeactivateTap != null)
          _ActionIcon(
            icon: item.isActive ? Icons.block : Icons.check_circle,
            onPressed: () => onDeactivateTap!(item),
          ),
        if (onAddToCart != null)
          _ActionIcon(
            icon: Icons.add_shopping_cart,
            onPressed: () => onAddToCart!(item),
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
      child: Icon(icon, size: 30),
    );
  }
}
