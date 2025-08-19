import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// عنصر واحد في الشريط
class CurvedNavItem {
  final IconData icon;
  final String i18nKey; // مثال: 'tables', 'services', 'add_order'...
  final String? semantics;
  const CurvedNavItem({
    required this.icon,
    required this.i18nKey,
    this.semantics,
  });
}

/// شريط تنقّل سفلي بيضاوي بكامل العرض مع فقاعة متحركة تحيط بالأيقونة
class CurvedBottomNav extends StatelessWidget {
  const CurvedBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    required this.brandColor,
    this.backgroundColor = Colors.white,
    this.height = 64,
    this.iconSize = 26,
    this.bubbleDiameter = 50,
    this.padding = const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
    this.showBubbleAbove = true,
  }) : assert(items.length >= 3);

  final List<CurvedNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  final Color brandColor;
  final Color backgroundColor;
  final double height;
  final double iconSize;
  final double bubbleDiameter;
  final EdgeInsets padding;
  final bool showBubbleAbove;

  @override
  Widget build(BuildContext context) {
    final bool isRtl = Directionality.of(context) == ui.TextDirection.rtl;

    final double extraTop = showBubbleAbove ? bubbleDiameter * 0.55 : 0.0;
    final double containerHeight = height + extraTop;

    return SizedBox(
      height: containerHeight,
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, cons) {
          final double fullW = cons.maxWidth;

          final double iconsLeft = padding.left;
          final double iconsRight = fullW - padding.right;
          final double iconsWidth = iconsRight - iconsLeft;

          final int n = items.length;
          final double step = (n == 1) ? 0 : (iconsWidth / (n - 1));

          double centerX(int i) {
            final int visualIndex = isRtl ? (n - 1 - i) : i;
            return iconsLeft + visualIndex * step;
          }

          final double bubbleLeft =
              centerX(currentIndex) - (bubbleDiameter / 2);
          final double bubbleBottom =
              (height - bubbleDiameter) / 2 + (showBubbleAbove ? bubbleDiameter * 0.18 : 0.0);

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(height * 0.55),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.08),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                ),
              ),

              AnimatedPositioned(
                duration: const Duration(milliseconds: 420),
                curve: Curves.easeOutQuint,
                left: bubbleLeft.clamp(0.0, fullW - bubbleDiameter),
                bottom: bubbleBottom,
                width: bubbleDiameter,
                height: bubbleDiameter,
                child: _ActiveBubble(brand: brandColor, diameter: bubbleDiameter),
              ),

              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.only(bottom: (height - 48) / 2),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: List.generate(n, (i) {
                      final double cx = centerX(i);
                      final bool selected = i == currentIndex;

                      const double tapSize = 48;
                      final double tapLeft = (cx - tapSize / 2).clamp(0.0, fullW - tapSize);
                      final double tapBottom = (height - tapSize) / 2;

                      return Positioned(
                        left: tapLeft,
                        bottom: tapBottom,
                        width: tapSize,
                        height: tapSize,
                        child: _NavIconButton(
                          tooltip: items[i].semantics ?? items[i].i18nKey.tr(),
                          selected: selected,
                          color: selected ? Colors.white : brandColor,
                          icon: items[i].icon,
                          size: iconSize,
                          onTap: () {
                            Feedback.forTap(context);
                            onTap(i);
                          },
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ActiveBubble extends StatelessWidget {
  const _ActiveBubble({required this.brand, required this.diameter});

  final Color brand;
  final double diameter;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: 1.0,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
      child: Container(
        width: diameter,
        height: diameter,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // تدرّج بسيط يعطي لمعان خفيف
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [brand.withOpacity(.96), brand],
          ),
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.18),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavIconButton extends StatelessWidget {
  const _NavIconButton({
    required this.icon,
    required this.color,
    required this.size,
    required this.onTap,
    required this.tooltip,
    required this.selected,
  });

  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback onTap;
  final String tooltip;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkResponse(
          onTap: onTap,
          radius: 28,
          highlightShape: BoxShape.circle,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOut,
            offset: selected ? const Offset(0, -0.10) : Offset.zero,
            child: AnimatedScale(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              scale: selected ? 1.15 : 1.0,
              child: Icon(icon, size: size, color: color),
            ),
          ),
        ),
      ),
    );
  }
}
