import 'package:flutter/material.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({
    super.key,
    this.automaticallyImplyLeading = true,
    this.onNotificationsTap,
    this.actions,
    required this.restaurant,
    this.title,
  });

  final bool automaticallyImplyLeading;
  final VoidCallback? onNotificationsTap;
  final List<Widget>? actions;
  final RestaurantModel restaurant;
  final String? title;

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: AppColors.white),
      centerTitle: true,
      backgroundColor: restaurant.color,
      // title: _RestaurantBrand(restaurant: restaurant),
      title: title != null
          ? Text(
              title!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            )
          : null,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
    );
  }
}

// class _BackButton extends StatelessWidget {
//   const _BackButton({required this.color});
//   final Color color;

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       onPressed: () => Navigator.of(context).maybePop(),
//       icon: const Icon(Icons.arrow_back),
//       color: color,
//       tooltip: 'Back',
//     );
//   }
// }

// class _RestaurantBrand extends StatelessWidget {
//   const _RestaurantBrand({required this.restaurant});
//   final RestaurantModel restaurant;

//   @override
//   Widget build(BuildContext context) {
//     final logoUrl = restaurant.logoHomePage;
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(12),
//       child: SizedBox(
//         width: 60,
//         height: 50,
//         child: (logoUrl != null && logoUrl.isNotEmpty)
//             ? Image.network(
//                 logoUrl,
//                 fit: BoxFit.cover,
//                 errorBuilder: (_, __, ___) =>
//                     const Icon(Icons.restaurant, color: Colors.white, size: 36),
//               )
//             : const Icon(Icons.restaurant, color: Colors.white, size: 36),
//       ),
//     );
//   }
// }
