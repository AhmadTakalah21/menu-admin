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

  void onPasswordChanged(String password);

  void onPasswordSubmitted(String password);

  void onMobileChanged(String mobile);

  void onMobileSubmitted(String mobile);

  void onUserTypeSelected(UserTypeModel? userTypeModel);

  void onUserRoleSelected(UserTypeModel? userTypeModel);

  void onCategorySelected(CategoryModel? category);

  void onSaveTap();

  void onIgnoreTap();
}

class UpdateAdminWidget extends StatefulWidget {
  const UpdateAdminWidget({
    super.key,
    this.admin,
    required this.selectedPage,
    required this.isEdit,
  });

  final AdminModel? admin;
  final int selectedPage;
  final bool isEdit;

  @override
  State<UpdateAdminWidget> createState() => _UpdateAdminWidgetState();
}

class _UpdateAdminWidgetState extends State<UpdateAdminWidget>
    implements UpdateAdminWidgetCallBack {
  late final AdminsCubit adminsCubit = context.read();

  final nameFocusNode = FocusNode();
  final usernameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final mobileFocusNode = FocusNode();

  bool isShowTypes = false;
  bool isShowCategories = false;

  final List<CategoryModel> categories = [];

  @override
  void initState() {
    super.initState();
    adminsCubit.getUserRoles(isRefresh: false);
    nameFocusNode.requestFocus();
    final admin = widget.admin;
    if (admin != null) {
      final role = admin.roles;

      adminsCubit.setName(admin.name);
      adminsCubit.setUsername(admin.userName);
      adminsCubit.setMobile(admin.mobile);
      if (role != null) {
        adminsCubit.setRoleUpdate(UserTypeModel(id: 1, name: role));
        if (role == "employee" || role == "موظف") {
          adminsCubit.getUserTypes(isRefresh: false);
          setState(() {
            isShowTypes = true;
          });
        }
      }
      adminsCubit.setUserType(UserTypeModel(id: admin.typeId, name: ""));
      if (admin.typeId == 4 || admin.typeId == 8) {
        adminsCubit.getCategoriesSubInItem(isRefresh: false);
        setState(() {
          isShowCategories = true;
        });
      }
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
  void onUserRoleSelected(UserTypeModel? userTypeModel) {
    adminsCubit.setRoleUpdate(userTypeModel);
    if (userTypeModel == null) {
      setState(() {
        isShowTypes = false;
      });
    } else {
      if (userTypeModel.name == "موظف" || userTypeModel.name == "employee") {
        adminsCubit.getUserTypes(isRefresh: false);
        setState(() {
          isShowTypes = true;
        });
      }
    }
  }

  @override
  void onUserTypeSelected(UserTypeModel? userTypeModel) {
    adminsCubit.setUserType(userTypeModel);
    if (userTypeModel != null &&
        (userTypeModel.id == 4 || userTypeModel.id == 8)) {
      adminsCubit.getCategoriesSubInItem(isRefresh: false);
      setState(() {
        isShowCategories = true;
      });
    } else {
      setState(() {
        isShowCategories = false;
      });
    }
  }

  @override
  void onCategorySelected(CategoryModel? category) {
    adminsCubit.setCategories(category);

    if (category != null) {
      int index = categories.indexWhere(
        (element) => element == category,
      );
      if (index == -1) {
        setState(() {
          categories.add(category);
        });
      } else {
        setState(() {
          categories.remove(category);
        });
      }
    } else {
      setState(() {
        categories.clear();
      });
    }
  }

  @override
  void onSaveTap() {
    adminsCubit.updateAdmin(adminAd: widget.admin?.id, isEdit: widget.isEdit);
  }

  @override
  void onIgnoreTap() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    adminsCubit.updateAdminModel = const UpdateAdminModel();

    nameFocusNode.dispose();
    usernameFocusNode.dispose();
    passwordFocusNode.dispose();
    mobileFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
                  widget.isEdit ? "edit_admin".tr() : "add_admin".tr(),
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
            MainTextField(
              initialText: widget.admin?.name,
              onChanged: onNameChanged,
              onSubmitted: onNameSubmitted,
              focusNode: nameFocusNode,
              labelText: "name".tr(),
            ),
            const SizedBox(height: 20),
            MainTextField(
              initialText: widget.admin?.userName,
              onChanged: onUsernameChanged,
              onSubmitted: onUsernameSubmitted,
              focusNode: usernameFocusNode,
              labelText: "username".tr(),
            ),
            const SizedBox(height: 20),
            MainTextField(
              onChanged: onPasswordChanged,
              onSubmitted: onPasswordSubmitted,
              focusNode: passwordFocusNode,
              labelText: "password".tr(),
            ),
            const SizedBox(height: 20),
            MainTextField(
              initialText: widget.admin?.mobile,
              onChanged: onMobileChanged,
              onSubmitted: onMobileSubmitted,
              focusNode: mobileFocusNode,
              labelText: "phone_number".tr(),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            BlocBuilder<AdminsCubit, GeneralAdminsState>(
              buildWhen: (previous, current) => current is UserRolesState,
              builder: (context, state) {
                if (state is UserRolesLoading) {
                  return const LoadingIndicator(color: AppColors.black);
                } else if (state is UserRolesSuccess) {
                  final selectedRole = state.userRoles.firstWhereOrNull(
                    (role) => role.name == widget.admin?.roles,
                  );

                  return MainDropDownWidget(
                    items: state.userRoles,
                    text: "role".tr(),
                    onChanged: onUserRoleSelected,
                    focusNode: FocusNode(),
                    selectedValue: selectedRole,
                  );
                } else if (state is UserRolesFail) {
                  return MainErrorWidget(error: state.error);
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            if (isShowTypes) const SizedBox(height: 20),
            if (isShowTypes)
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
                      children: List.generate(
                        categories.length,
                        (index) {
                          return Text(categories[index].name);
                        },
                      ),
                    )
                ],
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
                    var onTap = onSaveTap;
                    Widget? child;
                    if (state is UpdateAdminLoading) {
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
    );
  }
}
