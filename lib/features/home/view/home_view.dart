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

import '../../items/view/items_view.dart';

abstract class HomeViewCallBacks {
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

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.signInModel});

  final SignInModel signInModel;

  @override
  Widget build(BuildContext context) {
    return HomePage(signInModel: signInModel);
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.signInModel});

  final SignInModel signInModel;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> implements HomeViewCallBacks {
  late final HomeCubit homeCubit = context.read();
  late final DeleteCubit deleteCubit = context.read();

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
    return widget.signInModel.permissions
        .any((permission) => permission.name == permissionName);
  }

  @override
  void onActivateTap(CategoryModel category) {
    showDialog(
      context: context,
      builder: (context) {
        return InsureDeleteWidget(
          isDelete: false,
          item: category,
          onSaveTap: onSaveActivateTap,
        );
      },
    );
  }

  @override
  void onAddCategoryTap() {
    showDialog(
      context: context,
      builder: (context) {
        return const EditCategoryWidget(isEdit: false);
      },
    );
  }

  @override
  void onSaveActivateTap(CategoryModel category) {
    deleteCubit.deactivateItem<CategoryModel>(category);
  }

  @override
  void onCategoryTap(CategoryModel category) {
    final hasContent = category.content == 1 || category.content == 2;

    if (hasContent) {
      // الصنف يحتوي على بيانات (subcategories أو items) ← الدخول مباشرة
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => category.content == 1
              ? SubCategoriesView(
            masterCategory: category,
            signInModel: widget.signInModel,
          )
              : ItemsView(
            category: category,
            signInModel: widget.signInModel,
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
            insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.category, size: 48, color: Theme.of(context).primaryColor),
                  const SizedBox(height: 16),
                  Text(
                    'اختيار الإجراء'.tr(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'هل ترغب بإضافة عنصر مباشرة أو إدارة التصنيفات الفرعية؟'.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ItemsView(
                                  category: category,
                                  signInModel: widget.signInModel,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          label: Text('إضافة عنصر'.tr()),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.list),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SubCategoriesView(
                                  masterCategory: category,
                                  signInModel: widget.signInModel,
                                ),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: Theme.of(context).primaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          label: Text(
                            'إدارة التصنيفات الفرعية'.tr(),
                            style: TextStyle(color: Theme.of(context).primaryColor),
                          ),
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
    // 🟢 إعداد بيانات الصنف للتعديل
    context.read<HomeCubit>().setCategory(category);

    // 🔄 فتح نافذة التعديل
    showDialog(
      context: context,
      builder: (context) {
        return EditCategoryWidget(
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
    bool isEdit = hasPermission("category.update");
    bool isActive = hasPermission("category.active");
    bool isDelete = hasPermission("category.delete");

    return BlocListener<AppManagerCubit, AppManagerState>(
      listener: (context, state) {
        if (state is DeletedState && state.item is CategoryModel) {
          homeCubit.getCategories(isRefresh: true);
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
                  _buildHeader(isAdd),
                  const SizedBox(height: 20),
                  BlocBuilder<HomeCubit, GeneralHomeState>(
                    buildWhen: (previous, current) =>
                    current is CategoriesState || current is ImageState,
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
    final restColor = widget.signInModel.restaurant.color;
    return Row(
      children: [
        MainBackButton(color: restColor ?? AppColors.black),
        const SizedBox(width: 10),
        Text(
          "categories".tr(),
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
    if (state is CategoriesLoading) {
      return const LoadingIndicator(color: AppColors.black);
    } else if (state is CategoriesSuccess) {
      return Padding(
        padding: AppConstants.paddingH60,
        child: ListView.separated(
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
              restaurant: widget.signInModel.restaurant,
              locale: context.locale,
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 20),
        ),
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
