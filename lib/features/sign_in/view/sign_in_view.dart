import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/sign_in/cubit/sign_in_cubit.dart';
import 'package:user_admin/features/welcome/view/welcome_view.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';
import 'package:user_admin/global/widgets/main_text_field.dart';

abstract class SignInViewCallBacks {
  void onPasswordChanged(String password);

  void onPasswordSubmitted(String password);

  void onUserNameChanged(String username);

  void onUserNameSubmitted(String username);

  void onSignInTap();
}

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SignInPage();
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>
    implements SignInViewCallBacks {
  late final SignInCubit signInCubit = context.read();

  final userNameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    userNameFocusNode.requestFocus();
  }

  @override
  void onPasswordChanged(String password) {
    signInCubit.setPassword(password);
  }

  @override
  void onPasswordSubmitted(String password) {
    passwordFocusNode.unfocus();
  }

  @override
  void onUserNameChanged(String username) {
    signInCubit.setUserName(username);
  }

  @override
  void onUserNameSubmitted(String username) {
    passwordFocusNode.requestFocus();
  }

  @override
  void onSignInTap() {
    signInCubit.signIn();
  }

  @override
  void dispose() {
    userNameFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.png"),
            Text(
              "sign_in".tr(),
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: AppConstants.paddingH36V12,
              child: Column(
                children: [
                  BlocBuilder<SignInCubit, GeneralSignInState>(
                    buildWhen: (previous, current) =>
                        (current is TextFieldState &&
                            current.type == TextFieldType.username),
                    builder: (context, state) {
                      return MainTextField(
                        padding: AppConstants.padding20,
                        errorText: state is TextFieldState &&
                                state.type == TextFieldType.username
                            ? state.error
                            : null,
                        hintText: "username".tr(),
                        onChanged: onUserNameChanged,
                        onSubmitted: onUserNameSubmitted,
                        focusNode: userNameFocusNode,
                        filled: true,
                        fillColor: AppColors.white,
                        borderRadius: AppConstants.borderRadius30,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<SignInCubit, GeneralSignInState>(
                    buildWhen: (previous, current) =>
                        (current is TextFieldState &&
                            current.type == TextFieldType.password),
                    builder: (context, state) {
                      return MainTextField(
                        padding: AppConstants.padding20,
                        obscureText: true,
                        errorText: state is TextFieldState &&
                                state.type == TextFieldType.password
                            ? state.error
                            : null,
                        hintText: "password".tr(),
                        onChanged: onPasswordChanged,
                        onSubmitted: onPasswordSubmitted,
                        focusNode: passwordFocusNode,
                        filled: true,
                        fillColor: AppColors.white,
                        borderRadius: AppConstants.borderRadius30,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            BlocConsumer<SignInCubit, GeneralSignInState>(
              buildWhen: (previous, current) => current is SignInState,
              listener: (context, state) {
                if (state is SignInSuccess) {
                  MainSnackBar.showSuccessMessage(
                    context,
                    "login_success".tr(),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WelcomeView(
                        signInModel: state.signInModel,
                      ),
                    ),
                  );
                } else if (state is SignInFail) {
                  MainSnackBar.showErrorMessage(context, state.error);
                }
              },
              builder: (context, state) {
                var onTap = onSignInTap;
                Widget? child;
                if (state is SignInLoading) {
                  child = const LoadingIndicator(size: 30);
                  onTap = () {};
                }
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MainActionButton(
                      onPressed: onTap,
                      padding: AppConstants.paddingH36V12,
                      borderRadius: AppConstants.borderRadius20,
                      text: "sign_in".tr(),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      buttonColor: AppColors.mainColorSecondary,
                      child: child,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
