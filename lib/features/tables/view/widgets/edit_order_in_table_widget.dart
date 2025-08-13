import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/items/cubit/items_cubit.dart';
import 'package:user_admin/features/items/model/add_order_item/add_order_item.dart';

import 'package:user_admin/features/items/model/item_model/item_model.dart';
import 'package:user_admin/features/items/model/item_type_model/item_type_model.dart';
import 'package:user_admin/features/tables/cubit/tables_cubit.dart';
import 'package:user_admin/features/tables/model/order_details_model/order_details_model.dart';
import 'package:user_admin/features/tables/model/order_status_enum.dart';
import 'package:user_admin/global/model/table_model/table_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';
import 'package:user_admin/global/widgets/main_error_widget.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';
import 'package:user_admin/global/widgets/main_text_field.dart';

abstract class EditOrderInTableWidgetCallBack {
  void onQuantityChanged(String quantity);

  void onQuantitySubmitted(String quantity);

  void onItemSelected(ItemModel? item);

  void onExtraItemSelected(ItemTypeModel? itemType);

  void onStatusSelected(OrderStatusEnum? orderStatusEnum);

  void onTryAgainTap();

  void onSaveTap();

  void onIgnoreTap();
}

class EditOrderInTableWidget extends StatefulWidget {
  const EditOrderInTableWidget({
    super.key,
    required this.table,
    required this.restaurantId,
    required this.isEdit,
    this.orderDetailsModel,
    required this.selectedPage,
  });
  final TableModel table;
  final OrderDetailsModel? orderDetailsModel;
  final int restaurantId;
  final bool isEdit;
  final int selectedPage;

  @override
  State<EditOrderInTableWidget> createState() => _EditOrderInTableWidgetState();
}

class _EditOrderInTableWidgetState extends State<EditOrderInTableWidget>
    implements EditOrderInTableWidgetCallBack {
  late final ItemsCubit itemsCubit = context.read();
  late final TablesCubit tablesCubit = context.read();

  ItemModel? selectedItem;

  final itemFocusNode = FocusNode();
  final quantityFocusNode = FocusNode();
  final statusFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (!widget.isEdit) {
      tablesCubit.setCount("");
      itemsCubit.getItems(restaurantId: widget.restaurantId, isRefresh: true);
    }

    final orderDetailsModel = widget.orderDetailsModel;
    if (orderDetailsModel != null) {
      final orderStatusEnum = OrderStatusEnum.getStatus(
        orderDetailsModel.status,
      );
      itemsCubit.getSimilarItems(orderDetailsModel.name);

      tablesCubit.setCount(orderDetailsModel.count.toString());
      tablesCubit.setStatus(orderStatusEnum);
    }
    itemFocusNode.requestFocus();
  }

  @override
  void onQuantityChanged(String quantity) {
    tablesCubit.setCount(quantity);
  }

  @override
  void onQuantitySubmitted(String quantity) {
    statusFocusNode.requestFocus();
  }

  @override
  void onSaveTap() {
    final orderId = widget.orderDetailsModel?.id;
    if (widget.isEdit && orderId != null) {
      tablesCubit.editOrder(orderId);
    } else {
      tablesCubit.addOrder(widget.table.id);
    }
  }

  @override
  void onItemSelected(ItemModel? item) {
    setState(() {
      selectedItem = item;
    });

    tablesCubit.setItemId(item);
  }

  @override
  void onExtraItemSelected(ItemTypeModel? itemType) {}

  @override
  void onTryAgainTap() {
    final orderDetailsModel = widget.orderDetailsModel;
    itemsCubit.getItems(restaurantId: widget.restaurantId, isRefresh: true);

    if (widget.isEdit && orderDetailsModel != null) {
      itemsCubit.getSimilarItems(orderDetailsModel.name);
    }
  }

  @override
  void onStatusSelected(OrderStatusEnum? orderStatusEnum) {
    tablesCubit.setStatus(orderStatusEnum);
  }

  @override
  void onIgnoreTap() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    itemFocusNode.dispose();
    quantityFocusNode.dispose();
    statusFocusNode.dispose();

    tablesCubit.addOrderItem = const AddOrderItem();
    tablesCubit.resetParams();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final orderDetailsModel = widget.orderDetailsModel;
    OrderStatusEnum? orderStatusEnum;
    if (orderDetailsModel != null) {
      orderStatusEnum = OrderStatusEnum.getStatus(orderDetailsModel.status);
    }

    return BlocListener<ItemsCubit, GeneralItemsState>(
      listener: (context, state) {
        if (widget.isEdit && selectedItem == null && state is ItemsSuccess) {
          final matchedItem = state.items.firstWhereOrNull(
                (element) => element.name == orderDetailsModel?.name,
          );

          if (matchedItem != null) {
            selectedItem = matchedItem;
            tablesCubit.setItemId(matchedItem);
          }
        }
      },
      child: AlertDialog(
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
                    widget.isEdit ? "edit_order".tr() : "add_order".tr(),
                    style: const TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: onIgnoreTap,
                    child: const Icon(
                      Icons.close,
                      color: AppColors.greyShade,
                    ),
                  ),
                ],
              ),
              const Divider(height: 30),
              if (!widget.isEdit)
                BlocBuilder<ItemsCubit, GeneralItemsState>(
                  buildWhen: (previous, current) => current is ItemsState,
                  builder: (context, state) {
                    if (state is ItemsLoading) {
                      return const LoadingIndicator(color: AppColors.black);
                    } else if (state is ItemsSuccess) {
                      return MainDropDownWidget(
                        items: state.items,
                        text: "item".tr(),
                        expandedHeight: 300,
                        onChanged: onItemSelected,
                        focusNode: itemFocusNode,
                      );
                    } else if (state is ItemsEmpty) {
                      return MainErrorWidget(error: state.message);
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              if (!widget.isEdit) const SizedBox(height: 20),
              MainTextField(
                initialText: widget.orderDetailsModel?.count.toString(),
                onChanged: onQuantityChanged,
                onSubmitted: onQuantitySubmitted,
                focusNode: quantityFocusNode,
                labelText: "quantity".tr(),
                textInputType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              if (widget.isEdit) const SizedBox(height: 20),
              if (widget.isEdit)
                MainDropDownWidget(
                  items: OrderStatusEnum.values,
                  text: "status".tr(),
                  onChanged: onStatusSelected,
                  focusNode: statusFocusNode,
                  selectedValue: orderStatusEnum,
                ),
              const Divider(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MainActionButton(
                    padding: AppConstants.padding14,
                    onPressed: onIgnoreTap,
                    borderRadius: AppConstants.borderRadius5,
                    buttonColor: AppColors.blueShade3,
                    text: "ignore".tr(),
                    shadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  BlocConsumer<TablesCubit, GeneralTablesState>(
                    listener: (context, state) {
                      if (state is EditOrderInTableSuccess) {
                        tablesCubit.getTableOrders(
                          widget.table.id,
                          page: widget.selectedPage,
                        );
                        onIgnoreTap();
                        MainSnackBar.showSuccessMessage(context, state.message);
                      } else if (state is EditOrderInTableFail) {
                        MainSnackBar.showErrorMessage(context, state.error);
                      }
                    },
                    builder: (context, state) {
                      var onTap = onSaveTap;
                      Widget? child;
                      if (state is EditOrderInTableLoading) {
                        onTap = () {};
                        child = const LoadingIndicator(size: 20);
                      }
                      return MainActionButton(
                        padding: AppConstants.padding14,
                        onPressed: onTap,
                        borderRadius: AppConstants.borderRadius5,
                        buttonColor: AppColors.blueShade3,
                        text: "save".tr(),
                        shadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        child: child,
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
