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
import 'package:user_admin/global/widgets/more_options_widget.dart';

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
          restaurant: widget.restaurant,
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
        return AddToCartWidget(item: item, restaurant: widget.restaurant);
      },
    );
  }

  @override
  void onShowDetailsTap(ItemModel item) {
    showDialog(
      context: context,
      builder: (context) {
        return ItemDetailsWidget(restaurant: widget.restaurant, item: item);
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
          restaurant: widget.restaurant,
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
        return MoreOptionsWidget(
          item: item,
          onShowDetailsTap: onShowDetailsTap,
          onEditTap: onEditTap,
          onDeleteTap: onDeleteTap,
        );
      },
    );
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
    final restColor = widget.restaurant.color;
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
        appBar: MainAppBar(restaurant: widget.restaurant,
            title: "items".tr(),
          onSearchChanged: (q) => itemsCubit.searchByName(q),
          onSearchSubmitted: (q) => itemsCubit.searchByName(q),
          onSearchClosed: () => itemsCubit.searchByName(''),
          onLanguageToggle: (loc) {
          },
        ),
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
                  BlocBuilder<ItemsCubit, GeneralItemsState>(
                    buildWhen: (previous, current) => current is ItemsState,
                    builder: (context, state) {
                      if (state is ItemsLoading) {
                        return const LoadingIndicator(color: AppColors.black);
                      } else if (state is ItemsSuccess) {
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
                      } else if (state is ItemsEmpty) {
                        return MainErrorWidget(
                          buttonColor: restColor,
                          error: state.message,
                          isRefresh: true,
                          onTryAgainTap: onTryAgainTap,
                        );
                      } else if (state is ItemsFail) {
                        return MainErrorWidget(
                          buttonColor: restColor,
                          error: state.error,
                          onTryAgainTap: onTryAgainTap,
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  const SizedBox(height: 600),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (isAdd) MainAddButton(onTap: onAddTap, color: restColor)
          ],
        ),
      ),
    );
  }
}
