// import 'package:user_admin/features/sign_in/view/reset_via_email_view.dart';
// import 'package:user_admin/features/sign_in/view/reset_via_question_view.dart';
// import 'package:user_admin/features/sign_in/view/widgets/auth_page_title.dart';
// import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
// import 'package:user_admin/global/widgets/app_image_widget.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:user_admin/features/sign_in/model/question_model/question_model.dart';
// import 'package:user_admin/global/widgets/main_action_button.dart';

// abstract class SelectResetMethodViewCallBacks {
//   void onResetViaEmailTap();
//   void onResetViaQuestionTap();
// }

// class SelectResetMethodView extends StatefulWidget {
//   const SelectResetMethodView({
//     super.key,
//     required this.questions,
//     required this.restaurant,
//   });

//   final List<QuestionModel> questions;
//   final RestaurantModel restaurant;

//   @override
//   State<SelectResetMethodView> createState() => _SelectResetMethodViewState();
// }

// class _SelectResetMethodViewState extends State<SelectResetMethodView>
//     implements SelectResetMethodViewCallBacks {
//   @override
//   void onResetViaEmailTap() {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ResetViaEmailView(restaurant: widget.restaurant),
//       ),
//     );
//   }

//   @override
//   void onResetViaQuestionTap() {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ResetViaQuestionView(
//           questions: widget.questions,
//           restaurant: widget.restaurant,
//         ),
//       ),
//     );
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
//                           AuthPageTitle(title: "reset_password".tr()),
//                           const SizedBox(height: 50),
//                           _buildSubTitle(),
//                           const SizedBox(height: 50),
//                           _buildViaEmailBtn(),
//                           const SizedBox(height: 16),
//                           _buildViaQuestionBtn(),
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

//   Widget _buildSubTitle() {
//     return Text(
//       "you_can_reset".tr(),
//       style: const TextStyle(
//         fontSize: 14,
//         color: Color(0xFF1E1E1E),
//       ),
//       textAlign: TextAlign.center,
//     );
//   }

//   Widget _buildViaEmailBtn() {
//     return MainActionButton(
//       border: Border.all(color:widget.restaurant.color),
//       onPressed: onResetViaEmailTap,
//       text: "reset_via_email".tr(),
//       textColor: const Color(0xFF1E1E1E),
//       buttonColor:widget.restaurant.color,
//       isTextExpanded: true,
//     );
//   }

//   Widget _buildViaQuestionBtn() {
//     return MainActionButton(
//       border: Border.all(color:widget.restaurant.color),
//       onPressed: onResetViaQuestionTap,
//       text: "reset_via_security_question".tr(),
//       textColor: const Color(0xFF1E1E1E),
//       buttonColor:widget.restaurant.color,
//       isTextExpanded: true,
//     );
//   }
// }
