import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/home/cubit/home_cubit.dart';
import 'package:user_admin/features/home/model/category_model/category_model.dart';
import 'package:user_admin/features/home/model/edit_category_model/edit_category_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/app_image_widget.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';
import 'package:user_admin/global/widgets/main_text_field.dart';

abstract class EditCategoryWidgetCallBacks {
  void onCategoryChanged(CategoryModel? category);

  void onNameArChanged(String nameAr);

  void onNameArSubmitted(String nameAr);

  void onNameEnChanged(String nameEn);

  void onNameEnSubmitted(String nameEn);

  void onImageTap();

  void onSaveTap();

  void onIgnoreTap();
}

class EditCategoryWidget extends StatefulWidget {
  const EditCategoryWidget({
    super.key,
    this.category,
    required this.isEdit,
    this.masterCategory,
  });
  final CategoryModel? masterCategory;
  final CategoryModel? category;
  final bool isEdit;

  @override
  State<EditCategoryWidget> createState() => _EditCategoryWidgetState();
}

class _EditCategoryWidgetState extends State<EditCategoryWidget>
    implements EditCategoryWidgetCallBacks {
  late final HomeCubit homeCubit = context.read<HomeCubit>();

  final categoryFocusNode = FocusNode();
  final nameArFocusNode = FocusNode();
  final nameEnFocusNode = FocusNode();

  @override
  void onImageTap() {
    homeCubit.setImage();
  }

  @override
  void onCategoryChanged(CategoryModel? category) {
    homeCubit.setCategory(category);
    nameArFocusNode.requestFocus();
  }

  @override
  void onNameArChanged(String nameAr) {
    homeCubit.setNameAr(nameAr);
  }

  @override
  void onNameArSubmitted(String nameAr) {
    nameEnFocusNode.requestFocus();
  }

  @override
  void onNameEnChanged(String nameEn) {
    homeCubit.setNameEn(nameEn);
  }

  @override
  void onNameEnSubmitted(String nameEn) {
    nameEnFocusNode.unfocus();
  }

  @override
  void onIgnoreTap() {
    Navigator.pop(context);
  }

  @override
  void onSaveTap() {
    homeCubit.editCategory(
      isEdit: widget.isEdit,
      categoryId: widget.masterCategory?.id,
    );
  }

  @override
  void dispose() {
    categoryFocusNode.dispose();
    nameArFocusNode.dispose();
    nameEnFocusNode.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        homeCubit.editCategoryModel = const EditCategoryModel();
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.category;
    return AlertDialog(
      insetPadding: AppConstants.padding16,
      contentPadding: AppConstants.padding16,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.isEdit ? "edit_category".tr() : "add_category".tr(),
              style: const TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            const Divider(height: 30),
            InkWell(
              onTap: onImageTap,
              child: category != null
                  ? AppImageWidget(
                      width: 200,
                      fit: BoxFit.contain,
                      url: category.image,
                      errorWidget: Image.asset(
                        "assets/images/upload_image.png",
                        scale: 1.5,
                      ),
                    )
                  : Image.asset("assets/images/upload_image.png", scale: 1.5),
            ),
            const SizedBox(height: 10),
            if (widget.category != null)
              BlocBuilder<HomeCubit, GeneralHomeState>(
                buildWhen: (previous, current) => current is SubCategoriesState,
                builder: (context, state) {
                  if (state is SubCategoriesLoading) {
                    return const LoadingIndicator(
                      color: AppColors.black,
                    );
                  } else if (state is SubCategoriesSuccess) {
                    return MainDropDownWidget<CategoryModel>(
                      items: state.categories,
                      text: "category".tr(),
                      onChanged: onCategoryChanged,
                      focusNode: categoryFocusNode,
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            const SizedBox(height: 10),
            MainTextField(
              initialText: widget.category?.nameAr,
              onChanged: onNameArChanged,
              onSubmitted: onNameArSubmitted,
              focusNode: nameArFocusNode,
              labelText: "name_ar".tr(),
            ),
            const SizedBox(height: 10),
            MainTextField(
              initialText: widget.category?.nameEn,
              onChanged: onNameEnChanged,
              onSubmitted: onNameEnSubmitted,
              focusNode: nameEnFocusNode,
              labelText: "name_en".tr(),
            ),
            const Divider(height: 40),
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
                BlocConsumer<HomeCubit, GeneralHomeState>(
                  listener: (context, state) {
                    if (state is EditCategorySuccess) {
                      homeCubit.getCategories(
                        isRefresh: true,
                        categoryId: widget.masterCategory?.id,
                      );
                      onIgnoreTap();
                      MainSnackBar.showSuccessMessage(context, state.message);
                    } else if (state is EditCategoryFail) {
                      MainSnackBar.showErrorMessage(context, state.error);
                    }
                  },
                  builder: (context, state) {
                    var onTap = onSaveTap;
                    Widget? child;
                    if (state is EditCategoryLoading) {
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
          ],
        ),
      ),
    );
  }
}
