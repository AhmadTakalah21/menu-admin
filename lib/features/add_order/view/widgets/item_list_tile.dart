import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/add_order/cubit/add_order_cubit.dart';
import 'package:user_admin/features/items/model/item_model/item_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/app_image_widget.dart';
import '../../../../global/model/restaurant_model/restaurant_model.dart';
import '../../model/cart_item_model/cart_item_model.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';

class ItemListTile extends StatefulWidget {
  const ItemListTile({super.key, required this.item, required this.restaurant});
  final ItemModel item;
  final RestaurantModel restaurant;


  @override
  State<ItemListTile> createState() => _ItemListTileState();
}

class _ItemListTileState extends State<ItemListTile> {
  late final AddOrderCubit addOrderCubit = context.read();

  int? selectedSizeId;
  List<int> selectedToppings = [];
  List<int> selectedComponents = [];

  @override
  void initState() {
    super.initState();
    selectedSizeId = null;
    selectedToppings = [];
    selectedComponents = [];
  }

  @override
  void didUpdateWidget(covariant ItemListTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.id != widget.item.id) {
      selectedSizeId = null;
      selectedToppings = [];
      selectedComponents = [];
    }
  }

  void onTap() {
    if (widget.item.sizesTypes.isNotEmpty && selectedSizeId == null) {
      MainSnackBar.showErrorMessage(context, "size_required".tr());
      return;
    }

    addOrderCubit.addToCart(
      widget.item,
      selectedSizeId: selectedSizeId,
      selectedToppingIds: selectedToppings,
      selectedComponentIds: selectedComponents,
    );

    MainSnackBar.showSuccessMessage(context, "add_to_cart_success".tr());
    setState(() {});
  }

  int calculateTotalPrice() {
    return addOrderCubit.calculateCartItemPrice(
      CartItemModel(
        item: widget.item,
        count: 1,
        selectedSizeId: selectedSizeId,
        selectedToppingIds: selectedToppings,
        selectedComponentIds: selectedComponents,
      ),
    );
  }

  // === Helpers ===
  Color _on(Color c) => c.computeLuminance() > .55 ? Colors.black87 : Colors.white;

  OutlinedBorder _pillBorder(Color borderColor) => RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(999),
    side: BorderSide(color: borderColor.withOpacity(.12), width: 1),
  );

  TextStyle get _sectionTitle =>
      const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: AppColors.black);

  @override
  Widget build(BuildContext context) {
    final Color brand =widget.restaurant.color;

    return Padding(
      padding: AppConstants.paddingB10,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: AppConstants.borderRadius15,
          border: Border.all(color: Colors.black.withOpacity(.05), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.06),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: AppImageWidget(
                    url: widget.item.image,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AutoSizeText(
                    widget.item.name,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brand,
                    foregroundColor: _on(brand),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    shape: const StadiumBorder(),
                  ),
                  icon: const Icon(Icons.add_shopping_cart_rounded, size: 18,color: Colors.white),
                  label: Text(
                    "${calculateTotalPrice()} \$",
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),

            // الأحجام
            if (widget.item.sizesTypes.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text("choose_size".tr(), style: _sectionTitle),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: -4,
                children: widget.item.sizesTypes.map((size) {
                  final isSelected = selectedSizeId == size.id;
                  return ChoiceChip(
                    shape: _pillBorder(brand),
                    label: Text(
                      size.displayName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isSelected ? _on(brand) : AppColors.black,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: brand,
                    backgroundColor: const Color(0xFFF3F5F4),
                    onSelected: (_) => setState(() => selectedSizeId = size.id),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }).toList(),
              ),
            ],

            // الإضافات
            if (widget.item.itemTypes.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text("choose_toppings".tr(), style: _sectionTitle),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: -4,
                children: widget.item.itemTypes.map((topping) {
                  final selected = selectedToppings.contains(topping.id);
                  final label = topping.price != null
                      ? "${topping.displayName} (+${topping.price})"
                      : topping.displayName;
                  return FilterChip(
                    shape: _pillBorder(brand),
                    label: Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: selected ? _on(brand) : AppColors.black,
                      ),
                    ),
                    selected: selected,
                    selectedColor: brand,
                    backgroundColor: const Color(0xFFF6F7F6),
                    checkmarkColor: _on(brand),
                    onSelected: (_) {
                      setState(() {
                        selected
                            ? selectedToppings.remove(topping.id)
                            : selectedToppings.add(topping.id);
                      });
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }).toList(),
              ),
            ],

            // المكوّنات
            if (widget.item.componentsTypes.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text("choose_components".tr(), style: _sectionTitle),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: -4,
                children: widget.item.componentsTypes.map((component) {
                  final canSelect = component.isSelectable;
                  final selected = selectedComponents.contains(component.id);
                  return FilterChip(
                    shape: _pillBorder(brand),
                    avatar: canSelect ? null : const Icon(Icons.lock, size: 14, color: Colors.black54),
                    label: Text(
                      component.displayName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? _on(brand)
                            : (canSelect ? AppColors.black : Colors.black54),
                      ),
                    ),
                    selected: selected,
                    selectedColor: brand,
                    backgroundColor: const Color(0xFFF6F7F6),
                    checkmarkColor: _on(brand),
                    onSelected: canSelect
                        ? (_) {
                      setState(() {
                        selected
                            ? selectedComponents.remove(component.id)
                            : selectedComponents.add(component.id);
                      });
                    }
                        : null,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
