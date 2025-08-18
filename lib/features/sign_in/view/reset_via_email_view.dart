import 'package:user_admin/features/sign_in/cubit/sign_in_cubit.dart';
import 'package:user_admin/features/sign_in/view/verify_code_view.dart';
import 'package:user_admin/features/sign_in/view/widgets/auth_page_title.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/widgets/app_image_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/global/di/di.dart';
import 'package:user_admin/global/widgets/auth_action_button.dart';
import 'package:user_admin/global/widgets/auth_text_field.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

abstract class ResetViaEmailViewCallBacks {
  void onSendCodeTap();
}

class ResetViaEmailView extends StatelessWidget {
  const ResetViaEmailView({super.key, required this.restaurant});

  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => get<SignInCubit>(),
      child: ResetViaEmailPage(restaurant: restaurant),
    );
  }
}

class ResetViaEmailPage extends StatefulWidget {
  const ResetViaEmailPage({super.key, required this.restaurant});

  final RestaurantModel restaurant;

  @override
  State<ResetViaEmailPage> createState() => _ResetViaEmailPageState();
}

class _ResetViaEmailPageState extends State<ResetViaEmailPage>
    implements ResetViaEmailViewCallBacks {
  late final SignInCubit signInCubit = context.read();

  final emailFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    emailFocusNode.requestFocus();
  }

  @override
  void onSendCodeTap() => signInCubit.resetViaEmail();

  @override
  void dispose() {
    emailFocusNode.dispose();
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
                          AuthPageTitle(title: "enter_email".tr()),
                          const SizedBox(height: 20),
                          SvgPicture.asset("assets/images/email_logo.svg"),
                          const SizedBox(height: 50),
                          _buildEmailTextField(),
                          const SizedBox(height: 16),
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

  Widget _buildEmailTextField() {
    return AuthTextField(
      onChanged: signInCubit.setEmail,
      onSubmitted: (_) => emailFocusNode.unfocus(),
      focusNode: emailFocusNode,
      title: "enter_email".tr(),
    );
  }

  Widget _buildMainActionBtn() {
    return BlocConsumer<SignInCubit, GeneralSignInState>(
      buildWhen: (previous, current) => current is ResetViaEmailState,
      listener: (context, state) {
        if (state is ResetViaEmailSuccess) {
          MainSnackBar.showSuccessMessage(context, "code_sent".tr());
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  VerifyCodeView(restaurant: widget.restaurant),
            ),
          );
        } else if (state is ResetViaEmailFail) {
          MainSnackBar.showErrorMessage(context, state.error);
        }
      },
      builder: (context, state) {
        return AuthActionButton(
          onPressed: onSendCodeTap,
          text: "send_code".tr(),
          isLoading: state is ResetViaEmailLoading,
          buttonColor: widget.restaurant.color,
        );
      },
    );
  }
}
