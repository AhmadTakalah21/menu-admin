// import 'package:user_admin/features/sign_in/cubit/sign_in_cubit.dart';
// import 'package:user_admin/features/sign_in/view/reset_password_view.dart';
// import 'package:user_admin/features/sign_in/view/widgets/auth_page_title.dart';
// import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
// import 'package:user_admin/global/utils/constants.dart';
// import 'package:user_admin/global/widgets/app_image_widget.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:user_admin/global/di/di.dart';
// import 'package:user_admin/global/utils/app_colors.dart';
// import 'package:user_admin/global/widgets/loading_indicator.dart';
// import 'package:user_admin/global/widgets/main_action_button.dart';
// import 'package:user_admin/global/widgets/main_drop_down_widget.dart';
// import 'package:user_admin/global/widgets/main_error_widget.dart';
// import 'package:user_admin/global/widgets/main_snack_bar.dart';
// import 'package:user_admin/global/widgets/main_text_field.dart';
// import 'package:flutter_svg/svg.dart';

// import '../../app_manager/cubit/app_manager_cubit.dart';
// import '../../sign_in/model/question_model/question_model.dart';

// abstract class ResetViaQuestionViewCallBacks {
//   void onQuestionSelected(QuestionModel question);
//   void onVerifyTap();
//   void onTryAgainTap();
// }

// class ResetViaQuestionView extends StatelessWidget {
//   const ResetViaQuestionView({
//     super.key,
//     required this.questions,
//     required this.restaurant,
//   });

//   final List<QuestionModel> questions;
//   final RestaurantModel restaurant;

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => get<SignInCubit>(),
//       child: ResetViaQuestionPage(questions: questions, restaurant: restaurant),
//     );
//   }
// }

// class ResetViaQuestionPage extends StatefulWidget {
//   const ResetViaQuestionPage({
//     super.key,
//     required this.questions,
//     required this.restaurant,
//   });

//   final RestaurantModel restaurant;
//   final List<QuestionModel> questions;

//   @override
//   State<ResetViaQuestionPage> createState() => _ResetViaQuestionPageState();
// }

// class _ResetViaQuestionPageState extends State<ResetViaQuestionPage>
//     implements ResetViaQuestionViewCallBacks {
//   late final SignInCubit signInCubit = context.read();
//   late final AppManagerCubit appManagerCubit = context.read();

//   final userNameFocusNode = FocusNode();
//   final answerFocusNode = FocusNode();
//   final questionFocusNode = FocusNode();

//   @override
//   void onTryAgainTap() => appManagerCubit.getQuestions(context.locale);

//   @override
//   void onQuestionSelected(QuestionModel? question) {
//     signInCubit.setQuestion(question);
//     answerFocusNode.requestFocus();
//   }

//   @override
//   void onVerifyTap() => signInCubit.resetViaQuestion();

//   @override
//   void dispose() {
//     userNameFocusNode.dispose();
//     answerFocusNode.dispose();
//     questionFocusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: widget.restaurant.backgroundColor,
//       body: Stack(
//         children: [
//           if (widget.restaurant.backgroundImageHomePage != null)
//             Positioned.fill(
//               child: AppImageWidget(
//                 url: widget.restaurant.backgroundImageHomePage!,
//                 errorWidget: const SizedBox.shrink(),
//               ),
//             ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
//             child: Column(
//               children: [
//                 Expanded(
//                   child: Container(
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                         color: const Color(0xFFD9D9D9).withValues(alpha: 0.6),
//                         borderRadius: BorderRadius.circular(50),
//                         border: Border.all(width: 2, color: Colors.white),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withValues(alpha: 0.3),
//                             offset: const Offset(0, 8),
//                             blurRadius: 8,
//                           )
//                         ]),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const SizedBox(height: 20),
//                           AuthPageTitle(title: "select_question".tr()),
//                           const SizedBox(height: 20),
//                           _buildImage(),
//                           const SizedBox(height: 50),
//                           _buildUsernameTextField(),
//                           const SizedBox(height: 16),
//                           _buildQuestionDropDown(),
//                           const SizedBox(height: 16),
//                           _buildAnswerTextField(),
//                           const SizedBox(height: 35),
//                           _buildMainActionBtn(),
//                           const SizedBox(height: 30),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildImage() =>
//       SvgPicture.asset("assets/images/question_mark_logo.svg");

//   Widget _buildUsernameTextField() {
//     return MainTextField(
//       onChanged: signInCubit.setUsername,
//       onSubmitted: (_) => questionFocusNode.requestFocus(),
//       focusNode: userNameFocusNode,
//       title: "username".tr(),
//     );
//   }

//   Widget _buildQuestionDropDown() {
//     return BlocBuilder<AppManagerCubit, AppManagerState>(
//       buildWhen: (previous, current) => current is QuestionsState,
//       builder: (context, outerState) {
//         if (outerState is QuestionsLoading) {
//           return const LoadingIndicator(
//             color: AppColors.black,
//           );
//         } else if (outerState is QuestionsSuccess) {
//           return BlocBuilder<SignInCubit, GeneralSignInState>(
//             buildWhen: (previous, current) => current is SetQuestionState,
//             builder: (context, state) {
//               return MainDropDownWidget<QuestionModel>(
//                 focusNode: questionFocusNode,
//                 items: outerState.questions,
//                 onChanged: onQuestionSelected,
//                 label: "question".tr(),
//                 offsetY: 100,
//                 selectedValue:
//                     state is SetQuestionState ? state.question : null,
//               );
//             },
//           );
//         } else if (outerState is QuestionsFail) {
//           return MainErrorWidget(
//             error: outerState.error,
//             onTryAgainTap: onTryAgainTap,
//           );
//         } else {
//           return const SizedBox.shrink();
//         }
//       },
//     );
//   }

//   Widget _buildAnswerTextField() {
//     return MainTextField(
//       filled: false,
//       onChanged: signInCubit.setAnswer,
//       onSubmitted: (_) => answerFocusNode.unfocus(),
//       focusNode: answerFocusNode,
//       maxLines: null,
//       minLines: 3,
//       borderRadius: AppConstants.borderRadius15,
//       title: "answer".tr(),
//     );
//   }

//   Widget _buildMainActionBtn() {
//     return BlocConsumer<SignInCubit, GeneralSignInState>(
//       buildWhen: (previous, current) => current is ResetViaQuestionState,
//       listener: (context, state) {
//         if (state is ResetViaQuestionSuccess) {
//           MainSnackBar.showSuccessMessage(context, "verify_success".tr());
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) =>
//                   ResetPasswordView(restaurant: widget.restaurant),
//             ),
//           );
//         } else if (state is ResetViaQuestionFail) {
//           MainSnackBar.showErrorMessage(context, state.error);
//         }
//       },
//       builder: (context, state) {
//         return MainActionButton(
//           onPressed: onVerifyTap,
//           text: "verify".tr(),
//           isLoading: state is ResetViaQuestionLoading,
//           buttonColor: widget.restaurant.color,
//         );
//       },
//     );
//   }
// }
