import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/add_order/cubit/add_order_cubit.dart'
    as order_cubit;
import 'package:user_admin/features/items/cubit/items_cubit.dart';
import 'package:user_admin/features/items/model/item_model/item_model.dart';
import 'package:user_admin/features/sign_in/model/sign_in_model/sign_in_model.dart';
import 'package:user_admin/global/model/table_model/table_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/app_image_widget.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';
import 'package:user_admin/global/widgets/main_error_widget.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';

import '../model/cart_item_model/cart_item_model.dart';

abstract class CartViewCallBacks {
  void onAddTap(CartItemModel item);
  void onRemoveTap(CartItemModel item);
  void onTryAgainTap();
  void onTableSelected(TableModel? table);
  void onAddOrder();
}


class CartView extends StatefulWidget {
  const CartView({
    super.key,
    required this.signInModel,
  });

  final SignInModel signInModel;

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> implements CartViewCallBacks {
  late final order_cubit.AddOrderCubit addOrderCubit = context.read();
  late final ItemsCubit itemsCubit = context.read();

  @override
  void initState() {
    super.initState();
    addOrderCubit.getCartItems();
    itemsCubit.getTables();
  }

  @override
  void onAddTap(CartItemModel item) {
    addOrderCubit.addItem(item);
  }

  @override
  void onRemoveTap(CartItemModel item) {
    addOrderCubit.removeItem(item);
  }



  @override
  void onAddOrder() {
    addOrderCubit.postOrder();
  }

  @override
  void onTryAgainTap() {
    itemsCubit.getTables();
  }

  @override
  void onTableSelected(TableModel? table) {
    addOrderCubit.setTableId(table);
  }

  void onIgnoreTap(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: AppConstants.padding16,
      contentPadding: AppConstants.padding16,
      content: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<order_cubit.AddOrderCubit,
                order_cubit.GeneralAddOrderState>(
              buildWhen: (previous, current) =>
                  current is order_cubit.CartState,
              builder: (context, state) {
                if (state is order_cubit.CartSuccess) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          const Spacer(),
                          const SizedBox(width: 10),
                          Text(
                            "cart".tr(),
                            style: const TextStyle(
                              color: AppColors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 25,
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () => onIgnoreTap(context),
                            child: const Icon(
                              Icons.close,
                              color: AppColors.greyShade,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 30),


                      ...List.generate(
                        state.cartItems.length * 2 - 1,
                            (index) {
                          if (index.isOdd) {
                            return const Divider(
                              height: 40,
                              color: AppColors.black,
                              thickness: 0.5,
                            );
                          }

                          final itemIndex = index ~/ 2;
                          final cartItem = state.cartItems[itemIndex];
                          final item = cartItem.item;

                          final selectedSize = cartItem.selectedSizeId != null
                              ? item.sizesTypes.firstWhere(
                                (s) => s.id == cartItem.selectedSizeId,
                            orElse: () => item.sizesTypes.first,
                          )
                              : null;

                          final selectedToppings = item.itemTypes
                              .where((t) => cartItem.selectedToppingIds.contains(t.id))
                              .toList();

                          final selectedComponents = item.componentsTypes
                              .where((c) => cartItem.selectedComponentIds.contains(c.id))
                              .toList();

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppImageWidget(
                                width: 80,
                                height: 80,
                                borderRadius: AppConstants.borderRadius15,
                                fit: BoxFit.cover,
                                url: item.image,
                                errorWidget: const SizedBox.shrink(),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: AppColors.greyShade2,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 6),

                                    if (selectedSize != null)
                                      Text(
                                        "${"size".tr()}: ${selectedSize.name}",
                                        style: const TextStyle(fontSize: 13, color: Colors.black87),
                                      ),

                                    if (selectedToppings.isNotEmpty)
                                      Text(
                                        "${"toppings".tr()}: ${selectedToppings.map((t) => t.name).join(", ")}",
                                        style: const TextStyle(fontSize: 13, color: Colors.black87),
                                      ),

                                    if (selectedComponents.isNotEmpty)
                                      Text(
                                        "${"components".tr()}: ${selectedComponents.map((c) => c.name).join(", ")}",
                                        style: const TextStyle(fontSize: 13, color: Colors.black87),
                                      ),

                                    const SizedBox(height: 8),
                                    Text(
                                      "${"price".tr()}: ${addOrderCubit.calculateCartItemPrice(cartItem)} \$",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: widget.signInModel.restaurant.color,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 5),
                              Container(
                                padding: AppConstants.padding8,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: AppConstants.borderRadius20,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () => onAddTap(cartItem),
                                      child: Icon(Icons.add, color: widget.signInModel.restaurant.color),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      cartItem.count.toString(),
                                      style: const TextStyle(fontSize: 16, color: AppColors.black),
                                    ),
                                    const SizedBox(width: 5),
                                    InkWell(
                                      onTap: () => onRemoveTap(cartItem),
                                      child: Icon(
                                        cartItem.count == 1 ? Icons.delete : Icons.remove,
                                        color: AppColors.greyShade3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),


                      const Divider(
                        indent: 8,
                        endIndent: 8,
                        height: 40,
                        color: AppColors.black,
                        thickness: 0.5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${"cost".tr()} :",
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            "${(addOrderCubit.total).toInt()} \$",
                            style: TextStyle(
                              fontSize: 18,
                              color: widget.signInModel.restaurant.color,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      BlocBuilder<ItemsCubit, GeneralItemsState>(
                        builder: (context, state) {
                          if (state is TablesLoading) {
                            return const LoadingIndicator(
                                color: AppColors.black);
                          } else if (state is TablesSuccess) {
                            return MainDropDownWidget(
                              items: state.tables.data,
                              text: "table".tr(),
                              onChanged: onTableSelected,
                              focusNode: FocusNode(),
                            );
                          } else if (state is TablesFail) {
                            return MainErrorWidget(
                              error: state.error,
                              onTryAgainTap: onTryAgainTap,
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      BlocConsumer<order_cubit.AddOrderCubit,
                          order_cubit.GeneralAddOrderState>(
                        listener: (context, state) {
                          if (state is order_cubit.AddOrderSuccess) {
                            Navigator.pop(context);
                            MainSnackBar.showSuccessMessage(
                                context, "add_order_success".tr());
                            setState(() {});
                          } else if (state is order_cubit.AddOrderFail) {
                            MainSnackBar.showErrorMessage(context, state.error);
                          }
                        },
                        builder: (context, state) {
                          var onTap = onAddOrder;
                          Widget? child;
                          if (state is order_cubit.AddOrderLoading) {
                            onTap = () {};
                            child = const LoadingIndicator();
                          }
                          return MainActionButton(
                            padding: AppConstants.padding8,
                            onPressed: onTap,
                            text: "add_order".tr(),
                            buttonColor: widget.signInModel.restaurant.color,
                            child: child,
                          );
                        },
                      ),
                    ],
                  );
                } else if (state is order_cubit.CartEmpty) {
                  return Text(state.message);
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
