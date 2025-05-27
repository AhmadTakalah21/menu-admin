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
import 'package:user_admin/features/sign_in/model/sign_in_model/sign_in_model.dart';
import 'package:user_admin/global/blocs/delete_cubit/cubit/delete_cubit.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/insure_delete_widget.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_back_button.dart';
import 'package:user_admin/global/widgets/main_drawer.dart';
import 'package:user_admin/global/widgets/main_error_widget.dart';

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

  void onTryAgainTap();
}

class ItemsView extends StatelessWidget {
  const ItemsView({
    super.key,
    required this.signInModel,
    required this.category,
  });

  final SignInModel signInModel;
  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    return ItemsPage(
      signInModel: signInModel,
      category: category,
    );
  }
}

class ItemsPage extends StatefulWidget {
  const ItemsPage({
    super.key,
    required this.signInModel,
    required this.category,
  });

  final SignInModel signInModel;
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
  void onActivateTap(ItemModel item) {
    showDialog(
      context: context,
      builder: (context) {
        return InsureDeleteWidget(
          isDelete: false,
          item: item,
          onSaveTap: onSaveActivateTap,
        );
      },
    );
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
    int addIndex = widget.signInModel.permissions.indexWhere(
      (element) => element.name == "item.add",
    );
    int editIndex = widget.signInModel.permissions.indexWhere(
      (element) => element.name == "item.update",
    );
    int activeIndex = widget.signInModel.permissions.indexWhere(
      (element) => element.name == "item.active",
    );
    int deleteIndex = widget.signInModel.permissions.indexWhere(
      (element) => element.name == "item.delete",
    );
    int orderIndex = widget.signInModel.permissions.indexWhere(
      (element) => element.name == "order.add",
    );
    bool isAdd = addIndex != -1;
    bool isEdit = editIndex != -1;
    bool isActive = activeIndex != -1;
    bool isDelete = deleteIndex != -1;
    bool isOrder = orderIndex != -1;

    final restColor = widget.signInModel.restaurant.color;

    return BlocListener<AppManagerCubit, AppManagerState>(
      listener: (context, state) {
        if (state is DeletedState && state.item is ItemModel) {
          itemsCubit.getItems(categoryId: widget.category.id, isRefresh: true);
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        drawer: MainDrawer(signInModel: widget.signInModel),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            child: Padding(
              padding: AppConstants.padding16,
              child: Column(
                children: [
                  MainBackButton(color: restColor ?? AppColors.black),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "items".tr(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      MainActionButton(
                        padding: AppConstants.padding10,
                        onPressed: onRefresh,
                        text: "",
                        child:
                            const Icon(Icons.refresh, color: AppColors.white),
                      ),
                      if (isAdd) const SizedBox(width: 10),
                      if (isAdd)
                        MainActionButton(
                          padding: AppConstants.padding10,
                          onPressed: onAddTap,
                          text: "Add Category",
                          child: const Icon(
                            Icons.add_circle,
                            color: AppColors.white,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<ItemsCubit, GeneralItemsState>(
                    buildWhen: (previous, current) => current is ItemsState,
                    builder: (context, state) {
                      if (state is ItemsLoading) {
                        return const LoadingIndicator(color: AppColors.black);
                      } else if (state is ItemsSuccess) {
                        if (state.items.isEmpty) {
                          return Text("no_items".tr());
                        }
                        return Padding(
                          padding: AppConstants.paddingH60,
                          child: ListView.separated(
                            itemCount: state.items.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final item = state.items[index];
                              return CategoryTile(
                                onEditTap: isEdit ? onEditTap : null,
                                onDeleteTap: isDelete ? onDeleteTap : null,
                                onDeactivateTap:
                                    isActive ? onActivateTap : null,
                                onAddToCart: isOrder ? onAddToCart : null,
                                onShowDetailsTap: onShowDetailsTap,
                                item: item,
                                restaurant: widget.signInModel.restaurant,
                                locale: context.locale,
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 20);
                            },
                          ),
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
      ),
    );
  }
}
