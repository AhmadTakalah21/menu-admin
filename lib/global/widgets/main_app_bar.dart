// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:user_admin/global/localization/supported_locales.dart';
// import 'package:user_admin/global/utils/app_colors.dart';
// import 'package:user_admin/global/utils/constants.dart';
// import 'package:user_admin/global/widgets/loading_indicator.dart';

// class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
//   const MainAppBar({
//     super.key,
//     required this.cafe,
//     this.actions,
//     this.title,
//     this.centerTitle,
//     this.socialMedia,
//   });

//   final CafeModel cafe;
//   final List<Widget>? actions;
//   final Widget? socialMedia;
//   final Widget? title;
//   final bool? centerTitle;

//   @override
//   State<MainAppBar> createState() => _MainAppBarState();

//   @override
//   Size get preferredSize => const Size.fromHeight(60);
// }

// class _MainAppBarState extends State<MainAppBar> {
//   late final SignInCubit signInCubit = context.read();
//   late final CartCubit cartCubit = context.read();

//   void changeLanguage(LanguageModel language) {
//     setState(() {
//       if (language.locale == SupportedLocales.english) {
//         context.setLocale(SupportedLocales.english);
//       } else {
//         context.setLocale(SupportedLocales.arabic);
//       }
//     });
//   }

//   void onCartTap() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => CartView(
//           cafe: widget.cafe,
//           locale: context.locale,
//         ),
//       ),
//     );
//   }

//   void onProfileTap() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ProfileView(
//           cafe: widget.cafe,
//         ),
//       ),
//     );
//   }

//   void onLogoutTap() {
//     signInCubit.signOut();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final title = widget.title;
//     final socialMedia = widget.socialMedia;
//     return AppBar(
//       automaticallyImplyLeading: false,
//       foregroundColor: const Color.fromRGBO(255, 255, 255, 1),
//       title: Row(
//         children: [
//           const SizedBox(width: 8),
//           if (socialMedia == null)
//             BlocListener<AppManagerCubit, AppManagerState>(
//               listener: (context, state) {
//                 if (state is CartItemsCountChanged) {
//                   setState(() {});
//                 }
//               },
//               child: InkWell(
//                 onTap: onCartTap,
//                 child: Badge(
//                   backgroundColor: AppColors.white,
//                   textColor: AppColors.black,
//                   padding: AppConstants.padding2,
//                   label: Padding(
//                     padding: const EdgeInsets.only(bottom: 2),
//                     child: Text(
//                       cartCubit.cartItems.length.toString(),
//                     ),
//                   ),
//                   child: const Icon(
//                     size: 30,
//                     Icons.add_shopping_cart,
//                     color: AppColors.white,
//                   ),
//                 ),
//               ),
//             ),
//           if (socialMedia == null) const SizedBox(width: 12),
//           if (socialMedia == null)
//             PopupMenuButton(
//               offset: const Offset(0, 50),
//               constraints: const BoxConstraints(
//                 maxWidth: 60,
//               ),
//               shape: ContinuousRectangleBorder(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               color: Utils.stringToColor(widget.cafe.color)?.withOpacity(0.9),
//               itemBuilder: (context) {
//                 return SupportedLocales.languages.map(
//                   (language) {
//                     return PopupMenuItem(
//                       onTap: () => changeLanguage(language),
//                       child: Center(
//                         child: Container(
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: AppColors.white.withOpacity(0.9),
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           child: Text(
//                             language.code,
//                             style: const TextStyle(
//                               color: AppColors.black,
//                             ),
//                             textScaler: const TextScaler.linear(0.8),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ).toList();
//               },
//               child: const Icon(
//                 size: 30,
//                 Icons.language,
//                 color: AppColors.white,
//               ),
//             ),
//           if (socialMedia != null) socialMedia,
//           const Spacer(),
//           if (title != null) title,
//           const Spacer(),
//         ],
//       ),
//       centerTitle: widget.centerTitle,
//       actions: [
//         ...?widget.actions,
//         if (socialMedia == null)
//           PopupMenuButton(
//             offset: const Offset(0, 50),
//             color: AppColors.white,
//             elevation: 10,
//             shape: ContinuousRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             itemBuilder: (context) {
//               return [
//                 PopupMenuItem(
//                   height: 20,
//                   onTap: onProfileTap,
//                   child: Text(
//                     "profile".tr(),
//                     style: const TextStyle(
//                       color: AppColors.black,
//                     ),
//                   ),
//                 ),
//                 PopupMenuItem(
//                   height: 20,
//                   onTap: onLogoutTap,
//                   child: BlocBuilder<SignInCubit, GeneralSignInState>(
//                     buildWhen: (previous, current) => current is SignInState,
//                     builder: (context, state) {
//                       if (state is SignInLoading) {
//                         return const LoadingIndicator(color: AppColors.red);
//                       } else {
//                         return Text(
//                           "logout".tr(),
//                           style: const TextStyle(
//                             color: AppColors.black,
//                           ),
//                         );
//                       }
//                     },
//                   ),
//                 ),
//               ];
//             },
//             child: DecoratedBox(
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black38,
//                     offset: Offset(0, 4),
//                     blurRadius: 4,
//                   ),
//                 ],
//               ),
//               child: CircleAvatar(
//                 backgroundColor: Utils.stringToColor(widget.cafe.color),
//                 child: Image.asset(
//                   "assets/images/person.png",
//                   scale: 0.8,
//                 ),
//               ),
//             ),
//           ),
//         const SizedBox(width: 16),
//       ],
//       backgroundColor: Utils.stringToColor(widget.cafe.color),
//     );
//   }
// }
