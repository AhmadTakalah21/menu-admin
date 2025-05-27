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
import 'package:user_admin/features/sign_in/model/sign_in_model/sign_in_model.dart';
import 'package:user_admin/global/blocs/delete_cubit/cubit/delete_cubit.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/edit_category_widget.dart';
import 'package:user_admin/global/widgets/insure_delete_widget.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_back_button.dart';
import 'package:user_admin/global/widgets/main_drawer.dart';
import 'package:user_admin/global/widgets/main_error_widget.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';

abstract class SubCategoriesViewCallbacks {
  void onAddCategoryTap();
  Future<void> onRefresh();
  void onEditTap(CategoryModel category);
  void onDeleteTap(CategoryModel category);
  void onSaveDeleteTap(CategoryModel category);
  void onSaveActivateTap(CategoryModel category);
  void onActivateTap(CategoryModel category);
  void onCategoryTap(CategoryModel category);
  void onTryAgainTap();
}

class SubCategoriesView extends StatelessWidget {
  const SubCategoriesView({
    super.key,
    required this.signInModel,
    required this.masterCategory,
  });

  final SignInModel signInModel;
  final CategoryModel masterCategory;

  @override
  Widget build(BuildContext context) {
    return SubCategoriesPage(
      signInModel: signInModel,
      masterCategory: masterCategory,
    );
  }
}

class SubCategoriesPage extends StatefulWidget {
  const SubCategoriesPage({
    super.key,
    required this.signInModel,
    required this.masterCategory,
  });

  final SignInModel signInModel;
  final CategoryModel masterCategory;

  @override
  State<SubCategoriesPage> createState() => _SubCategoriesPageState();
}

class _SubCategoriesPageState extends State<SubCategoriesPage>
    implements SubCategoriesViewCallbacks {
  late final HomeCubit homeCubit = context.read();
  late final DeleteCubit deleteCubit = context.read();

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
    return widget.signInModel.permissions
        .any((permission) => permission.name == permissionName);
  }

  @override
  void onAddCategoryTap() {
    showDialog(
      context: context,
      builder: (_) => EditCategoryWidget(
        isEdit: false,
        masterCategory: widget.masterCategory,
      ),
    );
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
  void onActivateTap(CategoryModel category) {
    showDialog(
      context: context,
      builder: (_) => InsureDeleteWidget(
        isDelete: false,
        item: category,
        onSaveTap: onSaveActivateTap,
      ),
    );
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
    if (homeCubit.isShowItems(widget.signInModel.permissions)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ItemsView(
            signInModel: widget.signInModel,
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
    bool isEdit = hasPermission("category.update");
    bool isActive = hasPermission("category.active");
    bool isDelete = hasPermission("category.delete");

    final restColor = widget.signInModel.restaurant.color;

    return BlocListener<AppManagerCubit, AppManagerState>(
      listener: (context, state) {
        _fetchCategories(true);
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MainBackButton(color: restColor ?? AppColors.black),
                  const SizedBox(height: 20),
                  _buildHeader(isAdd),
                  const SizedBox(height: 20),
                  BlocBuilder<HomeCubit, GeneralHomeState>(
                    buildWhen: (previous, current) =>
                        current is SubCategoriesInMasterState,
                    builder: (context, state) =>
                        _buildCategoriesList(state, isEdit, isDelete, isActive),
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

  Widget _buildHeader(bool isAdd) {
    return Row(
      children: [
        Text(
          "sub_categories".tr(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        MainActionButton(
          padding: AppConstants.padding10,
          onPressed: onRefresh,
          text: "",
          child: const Icon(Icons.refresh, color: AppColors.white),
        ),
        if (isAdd) ...[
          const SizedBox(width: 10),
          MainActionButton(
            padding: AppConstants.padding10,
            onPressed: onAddCategoryTap,
            text: "Add Category",
            child: const Icon(Icons.add_circle, color: AppColors.white),
          ),
        ],
      ],
    );
  }

  Widget _buildCategoriesList(
      GeneralHomeState state, bool isEdit, bool isDelete, bool isActive) {
    if (state is SubCategoriesInMasterLoading) {
      return const LoadingIndicator(color: AppColors.black);
    } else if (state is SubCategoriesInMasterSuccess) {
      return Padding(
        padding: AppConstants.paddingH60,
        child: ListView.separated(
          itemCount: state.categories.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) {
            final item = state.categories[index];
            return CategoryTile(
              onTap: onCategoryTap,
              onEditTap: isEdit ? onEditTap : null,
              onDeleteTap: isDelete ? onDeleteTap : null,
              onDeactivateTap: isActive ? onActivateTap : null,
              item: item,
              restaurant: widget.signInModel.restaurant,
              locale: context.locale,
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 20),
        ),
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
