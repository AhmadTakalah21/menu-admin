import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/app_manager/cubit/app_manager_cubit.dart';
import 'package:user_admin/features/home/cubit/home_cubit.dart';
import 'package:user_admin/features/home/model/category_model/category_model.dart';
import 'package:user_admin/features/home/view/widgets/category_tile.dart';
import 'package:user_admin/features/items/view/items_view.dart';
import 'package:user_admin/global/blocs/delete_cubit/cubit/delete_cubit.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/model/role_model/role_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/edit_category_widget.dart';
import 'package:user_admin/global/widgets/insure_delete_widget.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_add_button.dart';
import 'package:user_admin/global/widgets/main_app_bar.dart';
import 'package:user_admin/global/widgets/main_error_widget.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';
import 'package:user_admin/global/widgets/switch_view_button.dart';

abstract class SubCategoriesViewCallbacks {
  void onAddTap();
  Future<void> onRefresh();
  void onEditTap(CategoryModel category);
  void onDeleteTap(CategoryModel category);
  void onSaveDeleteTap(CategoryModel category);
  void onSaveActivateTap(CategoryModel category);
  Future<bool> onActivateTap(CategoryModel category);
  void onCategoryTap(CategoryModel category);
  void onSwichViewTap();
  void onTryAgainTap();
}

class SubCategoriesView extends StatelessWidget {
  const SubCategoriesView({
    super.key,
    required this.masterCategory,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;
  final CategoryModel masterCategory;

  @override
  Widget build(BuildContext context) {
    return SubCategoriesPage(
      masterCategory: masterCategory,
      permissions: permissions,
      restaurant: restaurant,
    );
  }
}

class SubCategoriesPage extends StatefulWidget {
  const SubCategoriesPage({
    super.key,
    required this.masterCategory,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;
  final CategoryModel masterCategory;

  @override
  State<SubCategoriesPage> createState() => _SubCategoriesPageState();
}

class _SubCategoriesPageState extends State<SubCategoriesPage>
    implements SubCategoriesViewCallbacks {
  late final HomeCubit homeCubit = context.read();
  late final DeleteCubit deleteCubit = context.read();

  bool isCardView = true;

  late final StreamSubscription<List<ConnectivityResult>> subscription;

  @override
  void initState() {
    super.initState();
    _fetchCategories(false);
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.isNotEmpty && !result.contains(ConnectivityResult.none)) {
        _fetchCategories(true);
      } else {
        _fetchCategories(false);
      }
    });
  }

  void _fetchCategories(bool isRefresh) {
    homeCubit.getCategories(
      categoryId: widget.masterCategory.id,
      isRefresh: isRefresh,
    );
  }

  bool hasPermission(String permissionName) {
    return widget.permissions
        .any((permission) => permission.name == permissionName);
  }

  @override
  void onAddTap() {
    showDialog(
      context: context,
      builder: (_) => EditCategoryWidget(
        btnColor: widget.restaurant.color!,
        isEdit: false,
        masterCategory: widget.masterCategory,
      ),
    );
  }

  @override
  void onSwichViewTap() {
    setState(() {
      isCardView = !isCardView;
    });
  }

  @override
  Future<void> onRefresh() async {
    _fetchCategories(true);
    homeCubit.getCategoriesSub(isRefresh: true);
  }

  @override
  void onEditTap(CategoryModel category) {
    showDialog(
      context: context,
      builder: (_) => EditCategoryWidget(
        btnColor: widget.restaurant.color!,
        masterCategory: widget.masterCategory,
        category: category,
        isEdit: true,
      ),
    );
  }

  @override
  void onDeleteTap(CategoryModel category) {
    showDialog(
      context: context,
      builder: (_) => InsureDeleteWidget(
        isDelete: true,
        item: category,
        onSaveTap: onSaveDeleteTap,
      ),
    );
  }

  @override
  Future<bool> onActivateTap(CategoryModel category) async {
    final success = await showDialog(
      context: context,
      builder: (_) => InsureDeleteWidget(
        isDelete: false,
        item: category,
        onSaveTap: onSaveActivateTap,
      ),
    );
    return success ?? false;
  }

  @override
  void onSaveDeleteTap(CategoryModel category) {
    deleteCubit.deleteItem<CategoryModel>(category);
  }

  @override
  void onSaveActivateTap(CategoryModel category) {
    deleteCubit.deactivateItem<CategoryModel>(category);
  }

  @override
  void onCategoryTap(CategoryModel category) {
    if (homeCubit.isShowItems(widget.permissions)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ItemsView(
            permissions: widget.permissions,
            restaurant: widget.restaurant,
            category: category,
          ),
        ),
      );
    } else {
      MainSnackBar.showErrorMessage(context, "no_permission".tr());
    }
  }

  @override
  void onTryAgainTap() => onRefresh();

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
        _fetchCategories(true);
      },
      child: Scaffold(
        appBar: MainAppBar(
          restaurant: widget.restaurant,
          title: "sub_categories".tr(),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // _buildHeader(),
                  // const SizedBox(height: 20),
                  BlocBuilder<HomeCubit, GeneralHomeState>(
                    buildWhen: (previous, current) =>
                        current is SubCategoriesInMasterState,
                    builder: (context, state) => _buildCategoriesList(state),
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

  // Widget _buildHeader() {
  //   final restColor = widget.restaurant.color;
  //   bool isAdd = hasPermission("category.add");
  //   return Row(
  //     children: [
  //       MainBackButton(color: restColor),
  //       const Spacer(),
  //       if (isAdd) ...[
  //         const SizedBox(width: 10),
  //         MainAddButton(
  //           onTap: onAddTap,
  //           title: "add_sub_category".tr(),
  //         )
  //       ],
  //     ],
  //   );
  // }

  Widget _buildCategoriesList(GeneralHomeState state) {
    bool isEdit = hasPermission("category.update");
    bool isActive = hasPermission("category.active");
    bool isDelete = hasPermission("category.delete");
    if (state is SubCategoriesInMasterLoading) {
      return const LoadingIndicator(color: AppColors.black);
    } else if (state is SubCategoriesInMasterSuccess) {
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
    } else if (state is SubCategoriesInMasterFail) {
      return MainErrorWidget(
        error: state.error,
        onTryAgainTap: onTryAgainTap,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
