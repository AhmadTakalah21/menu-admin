import 'package:user_admin/features/sign_in/model/question_model/question_model.dart';
import 'package:user_admin/features/sign_in/view/reset_via_email_view.dart';
import 'package:user_admin/features/sign_in/view/widgets/auth_scaffold.dart';
import 'package:user_admin/features/welcome/view/welcome_view.dart';
import 'package:user_admin/global/di/di.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/widgets/app_image_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/sign_in/cubit/sign_in_cubit.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/auth_action_button.dart';
import 'package:user_admin/global/widgets/auth_text_field.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

abstract class SignInViewCallBacks {
  void onRemeberMe(bool? isChecked);
  void onForgetPasswordTap();
  void onSignInTap();
}

class SignInView extends StatelessWidget {
  const SignInView({super.key, required this.restaurant});

  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => get<SignInCubit>(),
      child: SignInPage(restaurant: restaurant),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key, required this.restaurant});

  final RestaurantModel restaurant;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>
    implements SignInViewCallBacks {
  late final SignInCubit signInCubit = context.read();
  //late final AppManagerCubit appManagerCubit = context.read();

  List<QuestionModel> questions = [];

  final userNameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  bool? _rememberMe = false;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   appManagerCubit.getQuestions(context.locale);
  // }

  @override
  void onForgetPasswordTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResetViaEmailView(restaurant: widget.restaurant),
      ),
    );
  }

  @override
  void onSignInTap() => signInCubit.signIn();

  @override
  void onRemeberMe(bool? isChecked) {
    setState(() {
      _rememberMe = isChecked;
    });
  }

  @override
  void dispose() {
    userNameFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return BlocListener<AppManagerCubit, AppManagerState>(
    //   listener: (context, state) {
    //     if (state is QuestionsSuccess) {
    //       questions = state.questions;
    //     }
    //   },
    //   child:
    return AuthScaffold(
      restaurant: widget.restaurant,
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildImage(),
          const SizedBox(height: 20),
          _buildUserNameTextField(),
          const SizedBox(height: 10),
          _buildPasswordTextField(),
          _buildRememberMeAndForgetPass(),
          const SizedBox(height: 10),
          _buildMainActionButton(),
          const SizedBox(height: 5),
          _buildOrText(),
          const SizedBox(height: 10),
          _buildAnotherLoginTypes(),
          const SizedBox(height: 20),
        ],
      ),
    );
    //);
  }

  Widget _buildImage() {
    return AppImageWidget(
      url: widget.restaurant.logo,
      borderRadius: AppConstants.borderRadius25,
      height: 200,
      scale: 1.3,
      errorWidget: Image.asset("assets/images/default_logo.png", scale: 1.3),
    );
  }

  Widget _buildUserNameTextField() {
    return BlocBuilder<SignInCubit, GeneralSignInState>(
      buildWhen: (previous, current) =>
      (current is TextFieldState && current.type == TextFieldType.username),
      builder: (context, state) {
        bool b =
            state is TextFieldState && state.type == TextFieldType.username;
        final errorText = b ? state.error : null;
        return AuthTextField(
          errorText: errorText,
          title: "username".tr(),
          onChanged: signInCubit.setUsernameSignIn,
          onSubmitted: (_) => passwordFocusNode.requestFocus(),
          focusNode: userNameFocusNode,
        );
      },
    );
  }

  Widget _buildPasswordTextField() {
    return BlocBuilder<SignInCubit, GeneralSignInState>(
      buildWhen: (previous, current) =>
      (current is TextFieldState && current.type == TextFieldType.password),
      builder: (context, state) {
        bool b =
            state is TextFieldState && state.type == TextFieldType.password;
        final errorText = b ? state.error : null;
        return AuthTextField(
          obscureText: true,
          errorText: errorText,
          title: "password".tr(),
          onChanged: signInCubit.setPasswordSignIn,
          onSubmitted: (_) => passwordFocusNode.unfocus(),
          focusNode: passwordFocusNode,
        );
      },
    );
  }

  Widget _buildRememberMeAndForgetPass() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: onRemeberMe,
              side: const BorderSide(width: 2, color: Color(0xFF1D1D1D)),
            ),
            Text(
              'remember_me'.tr(),
              style: const TextStyle(
                color: Color(0xFF1E1E1E),
                fontSize: 12,
              ),
              overflow: TextOverflow.fade,
            ),
          ],
        ),
        Expanded(
          child: TextButton(
            onPressed: onForgetPasswordTap,
            child: Text(
              'forgot_password?'.tr(),
              style: const TextStyle(
                color: Color(0xFFE3170A),
                fontSize: 12,
              ),
              overflow: TextOverflow.fade,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildMainActionButton() {
    return BlocConsumer<SignInCubit, GeneralSignInState>(
      buildWhen: (previous, current) => current is SignInState,
      listener: (context, state) {
        if (state is SignInSuccess) {
          MainSnackBar.showSuccessMessage(context, "login_success".tr());
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => WelcomeView(
                admin: state.signInModel,
                restaurant: state.signInModel.restaurant,
              ),
            ),
                (route) => false,
          );
        } else if (state is SignInFail) {
          MainSnackBar.showErrorMessage(context, state.error);
        }
      },
      builder: (context, state) {
        return AuthActionButton(
          onPressed: onSignInTap,
          text: "login".tr(),
          buttonColor: widget.restaurant.color,
          isLoading: state is SignInLoading,
        );
      },
    );
  }

  Widget _buildOrText() {
    return Text(
      "or".tr(),
      style: const TextStyle(color: Color(0xFF1E1E1E), fontSize: 14),
    );
  }

  Widget _buildAnotherLoginTypes() {
    final List<String> loginTypes = [
      "assets/images/apple_logo.svg",
      "assets/images/facebook_logo.svg",
      "assets/images/google_logo.svg",
    ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 20,
      children: loginTypes.map((e) {
        return SvgPicture.asset(e);
      }).toList(),
    );
  }
}
