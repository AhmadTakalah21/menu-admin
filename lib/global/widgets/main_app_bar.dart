import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import '../model/restaurant_model/restaurant_model.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({
    super.key,
    required this.restaurant,
    this.actions,
    this.sectionTitleKey = 'tables',
    this.onAddOrderTap,
    this.onTabSelected,
    this.selectedTabIndex = 1,
    this.onMenuTap,
  });

  final RestaurantModel restaurant;
  final List<Widget>? actions;
  final String sectionTitleKey;
  final VoidCallback? onAddOrderTap;
  final ValueChanged<int>? onTabSelected;
  final int selectedTabIndex;
  final VoidCallback? onMenuTap;

  @override
  Size get preferredSize => const Size.fromHeight(110);

  @override
  Widget build(BuildContext context) {
    final base = restaurant.color ?? const Color(0xFF2E4D2F);
    final primary = base.withValues(alpha: 0.98);
    final lightBar = _lighten(base, 0.55);
    final top = MediaQuery.of(context).padding.top;

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Material(
        color: Colors.transparent,
        elevation: 12,
        shadowColor: Colors.black.withValues(alpha: 0.2),
        child: Stack(
          clipBehavior: Clip.none,
          children: [

            Container(
              height: 78 + top,
              padding: EdgeInsets.only(top: top, left: 12, right: 12),
              decoration: BoxDecoration(
                color: primary,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(22),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.16),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          const SizedBox(width: 6),
                          _NavItem(
                            label: 'tables'.tr(),
                            selected: selectedTabIndex == 1,
                            onTap: () => onTabSelected?.call(1),
                          ),
                          _NavSep(),
                          _NavItem(
                            label: 'invoices'.tr(),
                            selected: selectedTabIndex == 2,
                            onTap: () => onTabSelected?.call(2),
                          ),
                          _NavSep(),
                          _NavItem(
                            label: 'drivers_tracking'.tr(),
                            selected: selectedTabIndex == 3,
                            onTap: () => onTabSelected?.call(3),
                          ),
                          _NavSep(),
                          _NavItem(
                            label: 'services'.tr(),
                            selected: selectedTabIndex == 4,
                            onTap: () => onTabSelected?.call(4),
                          ),
                          _NavSep(),
                          _NavItem(
                            label: 'coupons'.tr(),
                            selected: selectedTabIndex == 5,
                            onTap: () => onTabSelected?.call(5),
                          ),
                          _NavItem(
                            label: 'add_order'.tr(),
                            selected: selectedTabIndex == 6,
                            onTap: () => onTabSelected?.call(6),
                          ),
                          const SizedBox(width: 12),
                        ],
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      _BrandLogo(restaurant: restaurant),
                      if (onMenuTap != null) ...[
                        const SizedBox(width: 12),
                        _IconCircleButton(
                          icon: Icons.menu,
                          onTap: onMenuTap,
                          tooltip: 'menu'.tr(),
                        ),
                      ],
                      if (actions != null) ...[
                        const SizedBox(width: 6),
                        ...actions!,
                      ],
                    ],
                  ),
                ],
              ),
            ),

            Positioned(
              left: 16,
              right: 16,
              bottom: -22,
              child: Container(
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: lightBar,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Text(
                  sectionTitleKey.tr(),
                  style: const TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _lighten(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final l = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(l).toColor();
  }
}

class _BrandLogo extends StatelessWidget {
  const _BrandLogo({required this.restaurant});
  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    final logoUrl = (restaurant.logoHomePage?.isNotEmpty ?? false)
        ? restaurant.logoHomePage
        : restaurant.logo;

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      clipBehavior: Clip.antiAlias,
      child: (logoUrl != null && logoUrl.isNotEmpty)
          ? Image.network(
        logoUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const _LogoFallback(),
      )
          : const _LogoFallback(),
    );
  }
}

class _LogoFallback extends StatelessWidget {
  const _LogoFallback();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(Icons.restaurant, color: Colors.white, size: 24),
    );
  }
}



class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      color: Colors.white.withValues(alpha: selected ? 1 : 0.92),
      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
      fontSize: 15,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Text(label, style: style),
      ),
    );
  }
}

class _NavSep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      alignment: Alignment.center,
      child: Opacity(
        opacity: 0.25,
        child: Container(width: 1.2, height: 16, color: Colors.white),
      ),
    );
  }
}

class _IconCircleButton extends StatelessWidget {
  const _IconCircleButton({
    required this.icon,
    this.onTap,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.16),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Tooltip(
            message: tooltip ?? '',
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }
}


//class _AddOrderChip extends StatelessWidget {
//   const _AddOrderChip({this.onTap, required this.label});
//   final VoidCallback? onTap;
//   final String label;
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(22),
//       child: Container(
//         padding: const EdgeInsetsDirectional.only(start: 12, end: 10),
//         height: 36,
//         decoration: BoxDecoration(
//           color: const Color(0xFFE53935),
//           borderRadius: BorderRadius.circular(22),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: 0.15),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Text(
//               label,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w800,
//                 fontSize: 14.5,
//               ),
//             ),
//             const SizedBox(width: 8),
//             Container(
//               width: 22,
//               height: 22,
//               alignment: Alignment.center,
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(Icons.add, size: 16, color: Color(0xFFE53935)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }