import 'package:flutter/material.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/widgets/app_image_widget.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.child,
    required this.restaurant,
  });
  final Widget child;
  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: restaurant.backgroundColor,
      body: Stack(
        children: [
          if (restaurant.backgroundImageHomePage != null)
            Positioned.fill(
              child: AppImageWidget(
                url: restaurant.backgroundImageHomePage!,
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
                    child: SingleChildScrollView(child: child),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
