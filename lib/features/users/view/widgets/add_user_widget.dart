import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/sign_in/model/sign_in_model/sign_in_model.dart';
import 'package:user_admin/features/users/cubit/users_cubit.dart';
import 'package:user_admin/features/users/model/user_model/user_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';
import 'package:user_admin/global/widgets/main_text_field.dart';

abstract class AddUserWidgetCallBacks {
  void onNameChanged(String name);

  void onNameSubmitted(String name);

  void onUsernameChanged(String username);

  void onUsernameSubmitted(String username);

  void onPasswordChanged(String password);

  void onPasswordSubmitted(String password);

  void onPhoneNumberChanged(String phoneNumber);

  void onPhoneNumberSubmitted(String phoneNumber);

  void onSaveTap();

  void onIgnoreTap();
}

class EditUserWidget extends StatefulWidget {
  const EditUserWidget({
    super.key,
    required this.user,
    required this.signInModel,
  });
  final SignInModel signInModel;
  final UserModel user;

  @override
  State<EditUserWidget> createState() => _EditUserWidgetState();
}

class _EditUserWidgetState extends State<EditUserWidget>
    implements AddUserWidgetCallBacks {
  late final UsersCubit usersCubit = context.read();

  final nameFocusNode = FocusNode();
  final usernameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final phoneNumberFocusNode = FocusNode();

  @override
  void initState() {
    final user = widget.user;
    super.initState();
    usersCubit.setName(user.name);
    usersCubit.setUsername(user.username);
    usersCubit.setPhone(user.phone);
  }

  @override
  void onIgnoreTap() {
    Navigator.pop(context);
  }

  @override
  void onNameChanged(String name) {
    usersCubit.setName(name);
  }

  @override
  void onNameSubmitted(String name) {
    usernameFocusNode.requestFocus();
  }

  @override
  void onPasswordChanged(String password) {
    usersCubit.setPassword(password);
  }

  @override
  void onPasswordSubmitted(String password) {
    phoneNumberFocusNode.requestFocus();
  }

  @override
  void onPhoneNumberChanged(String phoneNumber) {
    usersCubit.setPhone(phoneNumber);
  }

  @override
  void onPhoneNumberSubmitted(String phoneNumber) {
    phoneNumberFocusNode.unfocus();
  }

  @override
  void onSaveTap() {
    usersCubit.editUser(
      restaurantId: widget.signInModel.restaurantId,
      driverId: widget.user.id,
    );
  }

  @override
  void onUsernameChanged(String username) {
    usersCubit.setUsername(username);
  }

  @override
  void onUsernameSubmitted(String username) {
    passwordFocusNode.requestFocus();
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    usernameFocusNode.dispose();
    passwordFocusNode.dispose();
    phoneNumberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final driver = widget.user;
    return AlertDialog(
      insetPadding: AppConstants.padding16,
      contentPadding: AppConstants.padding16,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "edit_user".tr(),
            style: const TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          const Divider(height: 30),
          MainTextField(
            initialText: driver.name,
            onChanged: onNameChanged,
            onSubmitted: onNameSubmitted,
            focusNode: nameFocusNode,
            labelText: "name".tr(),
          ),
          const SizedBox(height: 10),
          MainTextField(
            initialText: driver.username,
            onChanged: onUsernameChanged,
            onSubmitted: onUsernameSubmitted,
            focusNode: usernameFocusNode,
            labelText: "username".tr(),
          ),
          const SizedBox(height: 10),
          MainTextField(
            onChanged: onPasswordChanged,
            onSubmitted: onPasswordSubmitted,
            focusNode: passwordFocusNode,
            labelText: "password".tr(),
          ),
          const SizedBox(height: 10),
          MainTextField(
            initialText: driver.phone,
            onChanged: onPhoneNumberChanged,
            onSubmitted: onPhoneNumberSubmitted,
            focusNode: phoneNumberFocusNode,
            labelText: "phone_number".tr(),
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
              BlocConsumer<UsersCubit, GeneralUsersState>(
                listener: (context, state) {
                  if (state is EditUserSuccess) {
                    usersCubit.getUsers(1);
                    onIgnoreTap();
                    MainSnackBar.showSuccessMessage(context, state.message);
                  } else if (state is EditUserFail) {
                    MainSnackBar.showErrorMessage(context, state.error);
                  }
                },
                builder: (context, state) {
                  var onTap = onSaveTap;
                  Widget? child;
                  if (state is EditUserLoading) {
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
    );
  }
}
