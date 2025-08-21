import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/app_manager/cubit/app_manager_cubit.dart';
import 'package:user_admin/features/home/cubit/home_cubit.dart';
import 'package:user_admin/features/home/model/category_model/category_model.dart';
import 'package:user_admin/features/home/view/sub_categories_view.dart';
import 'package:user_admin/features/home/view/widgets/category_tile.dart';
import 'package:user_admin/global/blocs/delete_cubit/cubit/delete_cubit.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/model/role_model/role_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/edit_category_widget.dart';
import 'package:user_admin/global/widgets/insure_delete_widget.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_add_button.dart';
import 'package:user_admin/global/widgets/main_app_bar.dart';
import 'package:user_admin/global/widgets/main_error_widget.dart';

import '../../items/view/items_view.dart';

abstract class HomeViewCallBacks {
  void onAddTap();
  Future<void> onRefresh();
  void onEditTap(CategoryModel category);
  void onDeleteTap(CategoryModel category);
  void onSaveDeleteTap(CategoryModel category);
  void onSaveActivateTap(CategoryModel category);
  Future<bool> onActivateTap(CategoryModel category);
  void onCategoryTap(CategoryModel category);
  //void onSwichViewTap();
  void onTryAgainTap();
}

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return HomePage(permissions: permissions, restaurant: restaurant);
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> implements HomeViewCallBacks {
  late final HomeCubit homeCubit = context.read();
  late final DeleteCubit deleteCubit = context.read();

  bool isCardView = true;

  late final StreamSubscription<List<ConnectivityResult>> subscription;

  @override
  void initState() {
    super.initState();
    homeCubit.getCategories(isRefresh: false);
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.isNotEmpty && !result.contains(ConnectivityResult.none)) {
        homeCubit.getCategories(isRefresh: true);
      } else {
        homeCubit.getCategories(isRefresh: false);
      }
    });
  }

  bool hasPermission(String permissionName) {
    return widget.permissions
        .any((permission) => permission.name == permissionName);
  }

  @override
  Future<bool> onActivateTap(CategoryModel category) async {
    final success = await showDialog<bool>(
      context: context,
      builder: (context) {
        return InsureDeleteWidget(
          isDelete: false,
          item: category,
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
        return EditCategoryWidget(
          btnColor: widget.restaurant.color,
          isEdit: false,
        );
      },
    );
  }

  // @override
  // void onSwichViewTap() {
  //   setState(() {
  //     isCardView = !isCardView;
  //   });
  // }

  @override
  void onSaveActivateTap(CategoryModel category) {
    deleteCubit.deactivateItem<CategoryModel>(category);
  }

  @override
  void onCategoryTap(CategoryModel category) {
    final hasContent = category.content == 1 || category.content == 2;

    if (hasContent) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => category.content == 1
              ? SubCategoriesView(
                  masterCategory: category,
                  permissions: widget.permissions,
                  restaurant: widget.restaurant,
                )
              : ItemsView(
                  category: category,
                  permissions: widget.permissions,
                  restaurant: widget.restaurant,
                ),
        ),
      );
    } else {
      // الصنف فارغ → عرض مربع اختيار
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.category,
                    size: 48,
                    color: widget.restaurant.color,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "choose_action".tr(),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "add_item_or_subcategory".tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: MainActionButton(
                          padding: AppConstants.paddingH4V10,
                          isTextExpanded: true,
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ItemsView(
                                  category: category,
                                  permissions: widget.permissions,
                                  restaurant: widget.restaurant,
                                ),
                              ),
                            );
                          },
                          text: "items_managment".tr(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: MainActionButton(
                          padding: AppConstants.paddingH4V10,
                          isTextExpanded: true,
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SubCategoriesView(
                                  masterCategory: category,
                                  permissions: widget.permissions,
                                  restaurant: widget.restaurant,
                                ),
                              ),
                            );
                          },
                          text: "subcategories_managment".tr(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  @override
  void onDeleteTap(CategoryModel category) {
    showDialog(
      context: context,
      builder: (context) {
        return InsureDeleteWidget(
          isDelete: true,
          item: category,
          onSaveTap: onSaveDeleteTap,
        );
      },
    );
  }

  @override
  void onEditTap(CategoryModel category) {
    context.read<HomeCubit>().setCategory(category);

    showDialog(
      context: context,
      builder: (context) {
        return EditCategoryWidget(
          btnColor: widget.restaurant.color,
          category: category,
          isEdit: true,
        );
      },
    );
  }

  @override
  Future<void> onRefresh() async {
    homeCubit.getCategories(isRefresh: true);
  }

  @override
  void onTryAgainTap() {
    homeCubit.getCategories(isRefresh: true);
  }

  @override
  void onSaveDeleteTap(CategoryModel category) {
    deleteCubit.deleteItem<CategoryModel>(category);
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isAdd = hasPermission("category.add");
    return BlocListener<AppManagerCubit, AppManagerState>(
      listener: (context, state) {
        if (state is DeletedState && state.item is CategoryModel) {
          homeCubit.getCategories(isRefresh: true);
        }
      },
      child: Scaffold(
        appBar:
            MainAppBar(restaurant: widget.restaurant,
                title: "categories".tr(),
              onSearchChanged: (q) => homeCubit.searchCategoriesByName(q),
              onSearchSubmitted: (q) => homeCubit.searchCategoriesByName(q),
              onSearchClosed: () => homeCubit.searchCategoriesByName(''),
              onLanguageToggle: (loc) {
              },
            ),
        // drawer: MainDrawer(
        //   permissions: widget.permissions,
        //   restaurant: widget.restaurant,
        // ),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            child: Padding(
              padding: AppConstants.padding16,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BlocBuilder<HomeCubit, GeneralHomeState>(
                    buildWhen: (previous, current) =>
                        current is CategoriesState || current is ImageState,
                    builder: (context, state) => _buildCategoriesList(state),
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
            // SwitchViewButton(
            //   onTap: onSwichViewTap,
            //   isCardView: isCardView,
            //   color: widget.restaurant.color,
            // ),
            // const SizedBox(width: 10),
            if (isAdd)
              MainAddButton(onTap: onAddTap, color: widget.restaurant.color)
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesList(GeneralHomeState state) {
    bool isEdit = hasPermission("category.update");
    bool isActive = hasPermission("category.active");
    bool isDelete = hasPermission("category.delete");
    if (state is CategoriesLoading) {
      return const LoadingIndicator(color: AppColors.black);
    } else if (state is CategoriesSuccess) {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 20,
          childAspectRatio: 3 / 3.5,
        ),
        itemCount: state.categories.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final category = state.categories[index];
          return CategoryTile(
            onTap: onCategoryTap,
            onEditTap: isEdit ? onEditTap : null,
            onDeleteTap: isDelete ? onDeleteTap : null,
            onDeactivateTap: isActive ? onActivateTap : null,
            item: category,
            restaurant: widget.restaurant,
            locale: context.locale,
          );
        },
      );
    } else if (state is CategoriesFail) {
      return MainErrorWidget(
        error: state.error,
        onTryAgainTap: onTryAgainTap,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
