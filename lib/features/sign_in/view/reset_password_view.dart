import 'package:user_admin/features/sign_in/cubit/sign_in_cubit.dart';
import 'package:user_admin/features/sign_in/view/widgets/auth_page_title.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/widgets/app_image_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/sign_in/view/sign_in_view.dart';
import 'package:user_admin/global/di/di.dart';
import 'package:user_admin/global/widgets/auth_action_button.dart';
import 'package:user_admin/global/widgets/auth_text_field.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';

abstract class ResetPasswordViewCallBacks {
  void onResetPasswordTap();
}

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key, required this.restaurant});

  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => get<SignInCubit>(),
      child: ResetPasswordPage(restaurant: restaurant),
    );
  }
}

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key, required this.restaurant});

  final RestaurantModel restaurant;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage>
    implements ResetPasswordViewCallBacks {
  late final SignInCubit signInCubit = context.read();

  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  @override
  void onResetPasswordTap() => signInCubit.resetPassword();

  @override
  void dispose() {
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.restaurant.backgroundColor,
      body: Stack(
        children: [
          if (widget.restaurant.backgroundImageHomePage != null)
            Positioned.fill(
              child: AppImageWidget(
                url: widget.restaurant.backgroundImageHomePage!,
                errorWidget: const SizedBox.shrink(),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9).withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(width: 2, color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            offset: const Offset(0, 8),
                            blurRadius: 8,
                          )
                        ]),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          AuthPageTitle(title: "enter_new_password".tr()),
                          const SizedBox(height: 50),
                          _buildPasswordTextField(),
                          const SizedBox(height: 16),
                          _buildConfirmPasswordTextField(),
                          const SizedBox(height: 30),
                          _buildMainActionBtn(),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return AuthTextField(
      obscureText: true,
      onChanged: signInCubit.setPassword,
      onSubmitted: (_) => confirmPasswordFocusNode.requestFocus(),
      focusNode: passwordFocusNode,
      title: "new_password".tr(),
    );
  }

  Widget _buildConfirmPasswordTextField() {
    return AuthTextField(
      obscureText: true,
      onChanged: signInCubit.setRepeatPassword,
      onSubmitted: (value) => confirmPasswordFocusNode.unfocus(),
      focusNode: confirmPasswordFocusNode,
      title: "confirm_password".tr(),
    );
  }

  Widget _buildMainActionBtn() {
    return BlocConsumer<SignInCubit, GeneralSignInState>(
      buildWhen: (previous, current) => current is ResetPasswordState,
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          MainSnackBar.showSuccessMessage(
              context, "password_reset_success".tr());
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SignInView(restaurant: widget.restaurant),
            ),
          );
        } else if (state is ResetPasswordFail) {
          MainSnackBar.showErrorMessage(context, state.error);
        }
      },
      builder: (context, state) {
        return AuthActionButton(
          onPressed: onResetPasswordTap,
          text: "reset".tr(),
          isLoading: state is ResetPasswordLoading,
          buttonColor: widget.restaurant.color,
        );
      },
    );
  }
}
