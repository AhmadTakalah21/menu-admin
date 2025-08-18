import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/app_manager/cubit/app_manager_cubit.dart';
import 'package:user_admin/features/home/model/category_model/category_model.dart';
import 'package:user_admin/features/home/view/widgets/category_tile.dart';
import 'package:user_admin/features/items/cubit/items_cubit.dart';
import 'package:user_admin/features/items/model/item_model/item_model.dart';
import 'package:user_admin/features/items/view/widgets/add_to_cart_widget.dart';
import 'package:user_admin/features/items/view/widgets/edit_item_widget.dart';
import 'package:user_admin/features/items/view/widgets/item_details_widget.dart';
import 'package:user_admin/global/blocs/delete_cubit/cubit/delete_cubit.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/model/role_model/role_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/utils/utils.dart';
import 'package:user_admin/global/widgets/insure_delete_widget.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_add_button.dart';
import 'package:user_admin/global/widgets/main_app_bar.dart';
import 'package:user_admin/global/widgets/main_error_widget.dart';
import 'package:user_admin/global/widgets/switch_view_button.dart';

abstract class ItemsViewCallBacks {
  void onAddTap();
  Future<void> onRefresh();
  void onEditTap(ItemModel item);
  void onDeleteTap(ItemModel item);
  void onSaveDeleteTap(ItemModel item);
  void onSaveActivateTap(ItemModel item);
  void onActivateTap(ItemModel item);
  void onShowDetailsTap(ItemModel item);
  void onAddToCart(ItemModel item);
  void onMoreOptionsTap(ItemModel item);
  void onSwichViewTap();
  void onTryAgainTap();
}

class ItemsView extends StatelessWidget {
  const ItemsView({
    super.key,
    required this.category,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;
  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return ItemsPage(
      category: category,
      permissions: permissions,
      restaurant: restaurant,
    );
  }
}

class ItemsPage extends StatefulWidget {
  const ItemsPage({
    super.key,
    required this.category,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;
  final CategoryModel category;

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> implements ItemsViewCallBacks {
  late final ItemsCubit itemsCubit = context.read();
  late final DeleteCubit deleteCubit = context.read();

  bool isCardView = true;

  late final StreamSubscription<List<ConnectivityResult>> subscription;

  @override
  void initState() {
    super.initState();
    itemsCubit.getItems(categoryId: widget.category.id, isRefresh: false);
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.isNotEmpty && !result.contains(ConnectivityResult.none)) {
        itemsCubit.getItems(categoryId: widget.category.id, isRefresh: true);
      } else {
        itemsCubit.getItems(categoryId: widget.category.id, isRefresh: false);
      }
    });
  }

  @override
  Future<bool> onActivateTap(ItemModel item) async {
    final success = await showDialog<bool>(
      context: context,
      builder: (context) {
        return InsureDeleteWidget(
          isDelete: false,
          item: item,
          onSaveTap: onSaveActivateTap,
        );
      },
    );
    return success ?? false;
  }

  @override
  void onAddTap() {
    showDialog(
      context: context,
      builder: (context) {
        return EditItemWidget(
          isEdit: false,
          category: widget.category,
        );
      },
    );
  }

  @override
  void onAddToCart(ItemModel item) {
    showDialog(
      context: context,
      builder: (context) {
        return AddToCartWidget(item: item);
      },
    );
  }

  @override
  void onShowDetailsTap(ItemModel item) {
    showDialog(
      context: context,
      builder: (context) {
        return ItemDetailsWidget(item: item);
      },
    );
  }

  @override
  void onSaveActivateTap(ItemModel item) {
    deleteCubit.deactivateItem(item);
  }

  @override
  void onDeleteTap(ItemModel item) {
    showDialog(
      context: context,
      builder: (context) {
        return InsureDeleteWidget(
          isDelete: true,
          item: item,
          onSaveTap: onSaveDeleteTap,
        );
      },
    );
  }

  @override
  void onEditTap(ItemModel item) {
    showDialog(
      context: context,
      builder: (context) {
        return EditItemWidget(
          category: widget.category,
          item: item,
          isEdit: true,
        );
      },
    );
  }

  @override
  Future<void> onRefresh() async {
    itemsCubit.getItems(categoryId: widget.category.id, isRefresh: true);
  }

  @override
  void onTryAgainTap() {
    itemsCubit.getItems(categoryId: widget.category.id, isRefresh: true);
  }

  @override
  void onMoreOptionsTap(ItemModel item) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ActionTile(
                icon: Icons.remove_red_eye_outlined,
                label: 'عرض التفاصيل',
                onTap: () => onShowDetailsTap(item),
              ),
              _ActionTile(
                icon: Icons.edit_outlined,
                label: 'تعديل',
                onTap: () => onEditTap(item),
              ),
              _ActionTile(
                icon: Icons.delete_outline,
                label: 'حذف',
                isDestructive: true,
                onTap: () => onDeleteTap(item),
              ),
              const SizedBox(height: 6),
            ],
          ),
        );
      },
    );
  }

  @override
  void onSwichViewTap() {
    setState(() {
      isCardView = !isCardView;
    });
  }

  @override
  void onSaveDeleteTap(ItemModel item) {
    deleteCubit.deleteItem<ItemModel>(item);
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final permissions = widget.permissions;

    bool isAdd = Utils.hasPermission(permissions, "item.add");
    bool isEdit = Utils.hasPermission(permissions, "item.update");
    bool isActive = Utils.hasPermission(permissions, "item.active");
    bool isDelete = Utils.hasPermission(permissions, "item.delete");
    bool isOrder = Utils.hasPermission(permissions, "item.add");

    return BlocListener<AppManagerCubit, AppManagerState>(
      listener: (context, state) {
        if (state is DeletedState && state.item is ItemModel) {
          itemsCubit.getItems(categoryId: widget.category.id, isRefresh: true);
        }
      },
      child: Scaffold(
        appBar: MainAppBar(restaurant: widget.restaurant, title: "items".tr()),
        // drawer: MainDrawer(
        //   restaurant: widget.restaurant,
        //   permissions: widget.permissions,
        // ),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            child: Padding(
              padding: AppConstants.padding16,
              child: Column(
                children: [
                  // Row(
                  //   children: [
                  //     MainBackButton(color: restColor),
                  //     const Spacer(),
                  //     if (isAdd) ...[
                  //       const SizedBox(width: 10),
                  //       MainAddButton(onTap: onAddTap, title: "add_item".tr()),
                  //     ],
                  //   ],
                  // ),
                  // const SizedBox(height: 20),
                  BlocBuilder<ItemsCubit, GeneralItemsState>(
                    buildWhen: (previous, current) => current is ItemsState,
                    builder: (context, state) {
                      if (state is ItemsLoading) {
                        return const LoadingIndicator(color: AppColors.black);
                      } else if (state is ItemsSuccess) {
                        if (state.items.isEmpty) {
                          return Text("no_items".tr());
                        }
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 20,
                            childAspectRatio: 3 / 3.5,
                          ),
                          itemCount: state.items.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final item = state.items[index];
                            return CategoryTile(
                              // onEditTap: isEdit ? onEditTap : null,
                              // onDeleteTap: isDelete ? onDeleteTap : null,
                              onMoreOptionsTap: (isEdit && isDelete)
                                  ? onMoreOptionsTap
                                  : null,
                              onDeactivateTap: isActive ? onActivateTap : null,
                              onAddToCart: isOrder ? onAddToCart : null,
                              onShowDetailsTap: (!isEdit && !isDelete)
                                  ? onShowDetailsTap
                                  : null,
                              item: item,
                              restaurant: widget.restaurant,
                              locale: context.locale,
                            );
                          },
                        );
                      } else if (state is ItemsFail) {
                        return MainErrorWidget(
                          error: state.error,
                          onTryAgainTap: onTryAgainTap,
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SwitchViewButton(
              onTap: onSwichViewTap,
              isCardView: isCardView,
              color: widget.restaurant.color!,
            ),
            const SizedBox(width: 10),
            if (isAdd)
              MainAddButton(onTap: onAddTap, color: widget.restaurant.color!)
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? const Color(0xFFE53935) : Colors.black87;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label,
          style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      onTap: () {
        Navigator.of(context).pop();
        onTap?.call();
      },
    );
  }
}
