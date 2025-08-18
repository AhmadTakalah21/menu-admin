import 'package:user_admin/features/sign_in/cubit/sign_in_cubit.dart';
import 'package:user_admin/features/sign_in/view/reset_password_view.dart';
import 'package:user_admin/features/sign_in/view/widgets/auth_page_title.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/widgets/app_image_widget.dart';
import 'package:user_admin/global/widgets/auth_action_button.dart';
import 'package:easy_localization/easy_localization.dart' as tr;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/global/di/di.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';

abstract class VerifyCodeViewCallBacks {
  void onVerifyCodeTap();
}

class VerifyCodeView extends StatelessWidget {
  const VerifyCodeView({super.key, required this.restaurant});

  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => get<SignInCubit>(),
      child: VerifyCodePage(restaurant: restaurant),
    );
  }
}

class VerifyCodePage extends StatefulWidget {
  const VerifyCodePage({super.key, required this.restaurant});

  final RestaurantModel restaurant;

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage>
    implements VerifyCodeViewCallBacks {
  late final SignInCubit signInCubit = context.read();

  final codeFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    codeFocusNode.requestFocus();
  }

  @override
  void onVerifyCodeTap() => signInCubit.verifyCode();


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
                          AuthPageTitle(title: "check_email".tr()),
                          const SizedBox(height: 20),
                          SvgPicture.asset("assets/images/email_logo.svg"),
                          const SizedBox(height: 50),
                          _buildCodeFields(),
                          const SizedBox(height: 16),
                          _buildMainActionBtn(),
                          const SizedBox(height: 30),
                          const Divider(color: Colors.white),
                          const SizedBox(height: 10),
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

  Widget _buildCodeFields() {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBB2),
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      color: const Color(0xFFF9FBB2),
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        submittedPinTheme: submittedPinTheme,
        onChanged: signInCubit.setCode,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      ),
    );
  }

  Widget _buildMainActionBtn() {
    return BlocConsumer<SignInCubit, GeneralSignInState>(
      buildWhen: (previous, current) => current is VerifyCodeState,
      listener: (context, state) {
        if (state is VerifyCodeSuccess) {
          MainSnackBar.showSuccessMessage(context, "verify_success".tr());
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ResetPasswordView(restaurant: widget.restaurant),
            ),
          );
        } else if (state is VerifyCodeFail) {
          MainSnackBar.showErrorMessage(context, state.error);
        }
      },
      builder: (context, state) {
        return AuthActionButton(
          onPressed: onVerifyCodeTap,
          text: "verify_code".tr(),
          buttonColor: widget.restaurant.color,
          isLoading: state is VerifyCodeLoading,
        );
      },
    );
  }

}
