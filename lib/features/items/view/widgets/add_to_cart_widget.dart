import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/items/cubit/items_cubit.dart';

import 'package:user_admin/features/items/model/item_model/item_model.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/model/table_model/table_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';
import 'package:user_admin/global/widgets/main_text_field.dart';

abstract class AddToCartWidgetCallBack {
  void onQuantityChanged(String quantity);
  void onQuantitySubmitted(String quantity);
  void onTableNumberSelected(TableModel? table);
  void onSaveTap();
  void onIgnoreTap();
}

class AddToCartWidget extends StatefulWidget {
  const AddToCartWidget(
      {super.key, required this.item, required this.restaurant});

  final ItemModel item;
  final RestaurantModel restaurant;

  @override
  State<AddToCartWidget> createState() => _AddToCartWidgetState();
}

class _AddToCartWidgetState extends State<AddToCartWidget>
    implements AddToCartWidgetCallBack {
  late final ItemsCubit itemsCubit = context.read();

  final quantityFocusNode = FocusNode();
  final tableNumberFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    itemsCubit.setItemId(widget.item.id);
    itemsCubit.getTables();
    quantityFocusNode.requestFocus();
  }

  @override
  void onQuantityChanged(String quantity) {
    itemsCubit.setCount(quantity);
  }

  @override
  void onQuantitySubmitted(String quantity) {
    tableNumberFocusNode.requestFocus();
  }

  @override
  void onSaveTap() {
    itemsCubit.addOrder();
  }

  @override
  void onTableNumberSelected(TableModel? table) {
    itemsCubit.setTableId(table);
    tableNumberFocusNode.unfocus();
  }

  @override
  void onIgnoreTap() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: AppConstants.padding16,
      contentPadding: AppConstants.padding16,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 20),
                const Spacer(),
                Text(
                  "add_order".tr(),
                  style: const TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: onIgnoreTap,
                  child: const Icon(Icons.close, color: AppColors.black),
                ),
              ],
            ),
            MainTextField(
              onChanged: onQuantityChanged,
              onSubmitted: onQuantitySubmitted,
              focusNode: quantityFocusNode,
              borderColor: widget.restaurant.color,
              title: "quantity".tr(),
              textInputType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 20),
            BlocBuilder<ItemsCubit, GeneralItemsState>(
              buildWhen: (previous, current) => current is TablesState,
              builder: (context, state) {
                if (state is TablesLoading) {
                  return const LoadingIndicator(color: AppColors.black);
                } else if (state is TablesSuccess) {
                  return MainDropDownWidget(
                    items: state.tables.data,
                    text: "table_num".tr(),
                    onChanged: onTableNumberSelected,
                    expandedHeight: 200,
                    focusNode: tableNumberFocusNode,
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Spacer(),
                Expanded(
                  flex: 4,
                  child: MainActionButton(
                    onPressed: onIgnoreTap,
                    padding: AppConstants.paddingV10,
                    buttonColor: widget.restaurant.color,
                    text: "cancel".tr(),
                  ),
                ),
                const SizedBox(width: 8),
                BlocConsumer<ItemsCubit, GeneralItemsState>(
                  listener: (context, state) {
                    if (state is AddOrderSuccess) {
                      onIgnoreTap();
                      MainSnackBar.showSuccessMessage(context, state.message);
                    } else if (state is AddOrderFail) {
                      MainSnackBar.showErrorMessage(context, state.error);
                    }
                  },
                  builder: (context, state) {
                    return Expanded(
                      flex: 4,
                      child: MainActionButton(
                        onPressed: onSaveTap,
                        padding: AppConstants.paddingV10,
                        buttonColor: widget.restaurant.color,
                        text: "save".tr(),
                        isLoading: state is AddOrderLoading,
                      ),
                    );
                  },
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
