import 'package:flutter/material.dart';
import '../model/restaurant_model/restaurant_model.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({
    super.key,
    required this.restaurant,
    this.automaticallyImplyLeading = true,
    this.onNotificationsTap,
    this.actions,
  });

  final RestaurantModel restaurant;
  final bool automaticallyImplyLeading;
  final VoidCallback? onNotificationsTap;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(75);

  @override
  Widget build(BuildContext context) {
    final bg = restaurant.color?.withOpacity(0.95);

    return Material(
      color: Colors.transparent,
      elevation: 8,
      shadowColor: Colors.black.withOpacity(.12),
      child: Container(
        height: preferredSize.height + MediaQuery.of(context).padding.top,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                if (automaticallyImplyLeading && Navigator.of(context).canPop())
                  _BackButton(color: Colors.white)
                else
                  _RestaurantBrand(restaurant: restaurant),

                const Spacer(),

                if (actions != null) ...actions!,

                IconButton(
                  onPressed: onNotificationsTap,
                  icon: const Icon(Icons.notifications_none),
                  color: Colors.white,
                  iconSize: 26,
                  tooltip: 'Notifications',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).maybePop(),
      icon: const Icon(Icons.arrow_back),
      color: color,
      tooltip: 'Back',
    );
  }
}

class _RestaurantBrand extends StatelessWidget {
  const _RestaurantBrand({required this.restaurant});
  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    final logoUrl = restaurant.logoHomePage;
    final titleStyle = TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      fontFamily: restaurant.font,
      overflow: TextOverflow.ellipsis,
    );

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 44,
            height: 44,
            child: (logoUrl != null && logoUrl.isNotEmpty)
                ? Image.network(
              logoUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.restaurant, color: Colors.white, size: 36),
            )
                : const Icon(Icons.restaurant, color: Colors.white, size: 36),
          ),
        ),
        const SizedBox(width: 12),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * .45,
          ),
          child: Text(restaurant.name ?? "", style: titleStyle),
        ),
      ],
    );
  }
}
