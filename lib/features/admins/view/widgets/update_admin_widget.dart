import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/admins/cubit/admins_cubit.dart';
import 'package:user_admin/features/admins/model/admin_model/admin_model.dart';
import 'package:user_admin/features/admins/model/update_admin_model/update_admin_model.dart';
import 'package:user_admin/features/admins/model/user_type_model/user_type_model.dart';
import 'package:user_admin/features/home/model/category_model/category_model.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';
import 'package:user_admin/global/widgets/main_error_widget.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';
import 'package:user_admin/global/widgets/main_text_field.dart';

abstract class UpdateAdminWidgetCallBack {
  void onNameChanged(String name);
  void onNameSubmitted(String name);
  void onUsernameChanged(String username);
  void onUsernameSubmitted(String username);
  void onEmailChanged(String email);
  void onEmailSubmitted(String email);
  void onPasswordChanged(String password);
  void onPasswordSubmitted(String password);
  void onMobileChanged(String mobile);
  void onMobileSubmitted(String mobile);
  void onUserTypeSelected(UserTypeModel? userTypeModel);
  void onCategorySelected(CategoryModel? category);
  void onSaveTap();
  void onIgnoreTap();
}

class UpdateAdminView extends StatelessWidget {
  const UpdateAdminView({
    super.key,
    this.admin,
    required this.adminsCubit,
    required this.restaurant,
    required this.selectedPage,
  });

  final AdminModel? admin;
  final AdminsCubit adminsCubit;
  final RestaurantModel restaurant;
  final int selectedPage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: adminsCubit,
        child: UpdateAdminWidget(
          admin: admin,
          selectedPage: selectedPage,
          restaurant: restaurant,
        ));
  }
}

class UpdateAdminWidget extends StatefulWidget {
  const UpdateAdminWidget({
    super.key,
    this.admin,
    required this.selectedPage,
    required this.restaurant,
  });

  final AdminModel? admin;
  final RestaurantModel restaurant;
  final int selectedPage;

  @override
  State<UpdateAdminWidget> createState() => _UpdateAdminWidgetState();
}

class _UpdateAdminWidgetState extends State<UpdateAdminWidget>
    implements UpdateAdminWidgetCallBack {
  late final AdminsCubit adminsCubit = context.read();

  final nameFocusNode = FocusNode();
  final usernameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final mobileFocusNode = FocusNode();

  bool isShowCategories = false;

  final List<CategoryModel> categories = [];

  @override
  void initState() {
    super.initState();
    final admin = widget.admin;

    adminsCubit.setName(admin?.name);
    adminsCubit.setUsername(admin?.userName);
    adminsCubit.setMobile(admin?.mobile);
    adminsCubit.setUserType(admin?.typeId);
    if (admin?.typeId == 4 || admin?.typeId == 8) {
      adminsCubit.getCategoriesSubInItem(isRefresh: false);
      setState(() => isShowCategories = true);
    }
  }

  @override
  void onNameChanged(String name) {
    adminsCubit.setName(name);
  }

  @override
  void onNameSubmitted(String name) {
    usernameFocusNode.requestFocus();
  }

  @override
  void onUsernameChanged(String username) {
    adminsCubit.setUsername(username);
  }

  @override
  void onUsernameSubmitted(String name) {
    passwordFocusNode.requestFocus();
  }

  @override
  void onEmailChanged(String email) {
    adminsCubit.setEmail(email);
  }

  @override
  void onEmailSubmitted(String email) {
    passwordFocusNode.requestFocus();
  }

  @override
  void onPasswordChanged(String password) {
    adminsCubit.setPassword(password);
  }

  @override
  void onPasswordSubmitted(String password) {
    passwordFocusNode.unfocus();
  }

  @override
  void onMobileChanged(String mobile) {
    adminsCubit.setMobile(mobile);
  }

  @override
  void onMobileSubmitted(String mobile) {
    mobileFocusNode.unfocus();
  }

  @override
  void onUserTypeSelected(UserTypeModel? userTypeModel) {
    adminsCubit.setUserType(userTypeModel?.id);
    bool newBool = false;
    if (userTypeModel != null &&
        (userTypeModel.id == 4 || userTypeModel.id == 8)) {
      adminsCubit.getCategoriesSubInItem(isRefresh: false);
      newBool = true;
    } else {
      newBool = false;
    }
    setState(() {
      isShowCategories = newBool;
    });
  }

  @override
  void onCategorySelected(CategoryModel? category) {
    adminsCubit.setCategories(category);

    if (category != null) {
      final exist = categories.any((element) => element == category);
      setState(() {
        if (!exist) {
          categories.add(category);
        } else {
          categories.remove(category);
        }
      });
    } else {
      setState(() {
        categories.clear();
      });
    }
  }

  @override
  void onSaveTap() {
    adminsCubit.updateAdmin(
      adminAd: widget.admin?.id,
      isEdit: widget.admin != null,
    );
  }

  @override
  void onIgnoreTap() => Navigator.pop(context);

  @override
  void dispose() {
    adminsCubit.updateAdminModel = const UpdateAdminModel();
    adminsCubit.getUserTypes(isRefresh: true);
    nameFocusNode.dispose();
    usernameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    mobileFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.admin != null;
    return AlertDialog(
      insetPadding: AppConstants.padding16,
      contentPadding: AppConstants.padding16,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const SizedBox(width: 20),
                const Spacer(),
                Text(
                  isEdit ? "edit_employee".tr() : "add_employee".tr(),
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
            const SizedBox(height: 20),
            MainTextField(
              initialText: widget.admin?.name,
              onChanged: onNameChanged,
              onSubmitted: onNameSubmitted,
              focusNode: nameFocusNode,
              title: "name".tr(),
              borderColor: widget.restaurant.color,
            ),
            MainTextField(
              initialText: widget.admin?.userName,
              onChanged: onUsernameChanged,
              onSubmitted: onUsernameSubmitted,
              focusNode: usernameFocusNode,
              title: "username".tr(),
              borderColor: widget.restaurant.color,
            ),
            MainTextField(
              initialText: widget.admin?.email,
              onChanged: onEmailChanged,
              onSubmitted: onEmailSubmitted,
              focusNode: emailFocusNode,
              title: "email".tr(),
              borderColor: widget.restaurant.color,
              textInputType: TextInputType.emailAddress,
            ),
            MainTextField(
              onChanged: onPasswordChanged,
              onSubmitted: onPasswordSubmitted,
              focusNode: passwordFocusNode,
              title: "password".tr(),
              borderColor: widget.restaurant.color,
            ),
            MainTextField(
              initialText: widget.admin?.mobile,
              onChanged: onMobileChanged,
              onSubmitted: onMobileSubmitted,
              focusNode: mobileFocusNode,
              title: "phone_number".tr(),
              borderColor: widget.restaurant.color,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            BlocBuilder<AdminsCubit, GeneralAdminsState>(
              buildWhen: (previous, current) => current is UserTypesState,
              builder: (context, state) {
                if (state is UserTypesLoading) {
                  return const LoadingIndicator(color: AppColors.black);
                } else if (state is UserTypesSuccess) {
                  final selectedType = state.userTypes.firstWhereOrNull(
                        (role) => role.id == widget.admin?.typeId,
                  );
                  return MainDropDownWidget(
                    items: state.userTypes,
                    text: "type".tr(),
                    onChanged: onUserTypeSelected,
                    focusNode: FocusNode(),
                    selectedValue: selectedType,
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            if (isShowCategories) const SizedBox(height: 20),
            if (isShowCategories)
              Column(
                children: [
                  BlocBuilder<AdminsCubit, GeneralAdminsState>(
                    buildWhen: (previous, current) =>
                    current is CategoriesSubInItemState,
                    builder: (context, state) {
                      if (state is CategoriesSubInItemLoading) {
                        return const LoadingIndicator(color: AppColors.black);
                      } else if (state is CategoriesSubInItemSuccess) {
                        return MainDropDownWidget(
                          items: state.categories,
                          text: "category".tr(),
                          onChanged: onCategorySelected,
                          focusNode: FocusNode(),
                        );
                      } else if (state is CategoriesSubInItemEmpty) {
                        return MainErrorWidget(error: state.message);
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  if (categories.isNotEmpty) const SizedBox(height: 10),
                  if (categories.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: List.generate(categories.length, (index) {
                        return Text(categories[index].name);
                      }),
                    )
                ],
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Spacer(),
                Expanded(
                  flex: 4,
                  child: MainActionButton(
                    padding: AppConstants.paddingV10,
                    buttonColor: widget.restaurant.color,
                    onPressed: onIgnoreTap,
                    text: "cancel".tr(),
                  ),
                ),
                const SizedBox(width: 8),
                BlocConsumer<AdminsCubit, GeneralAdminsState>(
                  listener: (context, state) {
                    if (state is UpdateAdminSuccess) {
                      adminsCubit.getAdmins(widget.selectedPage);
                      onIgnoreTap();
                      MainSnackBar.showSuccessMessage(context, state.message);
                    } else if (state is UpdateAdminFail) {
                      MainSnackBar.showErrorMessage(context, state.error);
                    }
                  },
                  builder: (context, state) {
                    return Expanded(
                      flex: 4,
                      child: MainActionButton(
                        padding: AppConstants.paddingV10,
                        buttonColor: widget.restaurant.color,
                        onPressed: onSaveTap,
                        text: "save".tr(),
                        isLoading: state is UpdateAdminLoading,
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
