import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:user_admin/features/app_manager/cubit/app_manager_cubit.dart';
import 'package:user_admin/features/sign_in/model/sign_in_model/sign_in_model.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';

import '../../navigation_bar/navigation_bar.dart';

import 'package:user_admin/features/tables/view/tables_view.dart';
import 'package:user_admin/features/customer_service/view/customer_service_view.dart';
import 'package:user_admin/features/add_order/view/add_order_view.dart';
import 'package:user_admin/features/drivers/view/drivers_view.dart';
import 'package:user_admin/features/coupons/view/coupons_view.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({
    super.key,
    required this.admin,
    required this.restaurant,
  });

  final SignInModel admin;
  final RestaurantModel restaurant;

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  late final AppManagerCubit appManagerCubit = context.read();

  int _currentIndex = 0;

  late final List<CurvedNavItem> _items = const <CurvedNavItem>[
    CurvedNavItem(icon: Icons.table_restaurant_rounded, i18nKey: 'tables'),
    CurvedNavItem(icon: Icons.miscellaneous_services_rounded, i18nKey: 'services'),
    CurvedNavItem(icon: Icons.add_rounded, i18nKey: 'add_order'),
    CurvedNavItem(icon: Icons.location_on_outlined, i18nKey: 'drivers_track'),
    CurvedNavItem(icon: Icons.confirmation_number_outlined, i18nKey: 'coupons'),
  ];

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // نبني الصفحات مرة واحدة (تحافظ على حالتها داخل IndexedStack)
    final perms = widget.admin.permissions;
    final rest = widget.restaurant;

    _pages = <Widget>[
      TablesView(permissions: perms, restaurant: rest),
      CustomerServiceView(permissions: perms, restaurant: rest),
      AddOrderView(permissions: perms, restaurant: rest),
      DriversView(permissions: perms, restaurant: rest),
      CouponsView(permissions: perms, restaurant: rest),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final brand = widget.restaurant.color ?? AppColors.mainColor;

    return Scaffold(
      // مافيش AppBar هنا — كل شاشة داخلية عندها AppBar/Drawer الخاص بها.
      // نخلي الجسم يتمد تحت الناف (شكلاً أجمل مع فقاعة منحنية)
      extendBody: true,

      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),

      bottomNavigationBar: SafeArea(
        top: false,
        child: CurvedBottomNav(
          items: _items,
          currentIndex: _currentIndex,
          brandColor: brand,
          backgroundColor: Colors.white,
          onTap: (i) {
            setState(() => _currentIndex = i);
          },
          height: 64,
          bubbleDiameter: 50,
          iconSize: 26,
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
          showBubbleAbove: true,
        ),
      ),
    );
  }
}
