import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/add_order/cubit/add_order_cubit.dart';
import 'package:user_admin/features/items/model/item_model/item_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/app_image_widget.dart';
import '../../model/cart_item_model/cart_item_model.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';



class ItemListTile extends StatefulWidget {
  const ItemListTile({super.key, required this.item});
  final ItemModel item;

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

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppConstants.paddingB10,
      child: Container(
        padding: AppConstants.padding12,
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
            Row(
              children: [
                AppImageWidget(
                  width: 50,
                  height: 50,
                  url: widget.item.image,
                  borderRadius: AppConstants.borderRadiusCircle,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      AutoSizeText(
                        widget.item.name,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
                      InkWell(
                        onTap: onTap,
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.green.withOpacity(0.1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.add_shopping_cart, color: AppColors.green),
                              const SizedBox(width: 6),
                              Text("${calculateTotalPrice()} \$", style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),

            if (widget.item.sizesTypes.isNotEmpty)
              Column(
                children: [
                  const SizedBox(height: 12),
                  const Text(":اختر الحجم", style: TextStyle(fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 8,
                    children: widget.item.sizesTypes.map((size) {
                      final isSelected = selectedSizeId == size.id;
                      return ChoiceChip(
                        label: Text(size.displayName),
                        selected: isSelected,
                        onSelected: (_) => setState(() => selectedSizeId = size.id),
                      );
                    }).toList(),
                  ),
                ],
              ),

            if (widget.item.itemTypes.isNotEmpty)
              Column(
                children: [
                  const SizedBox(height: 12),
                  const Text(":اختر الإضافات", style: TextStyle(fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 8,
                    children: widget.item.itemTypes.map((topping) {
                      final isSelected = selectedToppings.contains(topping.id);
                      return FilterChip(
                        avatar: topping.image != null
                            ? CircleAvatar(backgroundImage: NetworkImage(topping.image!))
                            : null,
                        label: Text("${topping.displayName} (+${topping.price})"),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            isSelected
                                ? selectedToppings.remove(topping.id)
                                : selectedToppings.add(topping.id);
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),

            if (widget.item.componentsTypes.isNotEmpty)
              Column(
                children: [
                  const SizedBox(height: 12),
                  const Text(":اختر المكونات", style: TextStyle(fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 8,
                    children: widget.item.componentsTypes.map((component) {
                      final isSelectable = component.isSelectable;
                      final isSelected = selectedComponents.contains(component.id);
                      return FilterChip(
                        avatar: isSelectable ? null : const Icon(Icons.lock, size: 14),
                        label: Text(component.displayName),
                        selected: isSelected,
                        onSelected: isSelectable
                            ? (_) {
                          setState(() {
                            isSelected
                                ? selectedComponents.remove(component.id)
                                : selectedComponents.add(component.id);
                          });
                        }
                            : null,
                      );
                    }).toList(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

