import 'dart:async';
import 'dart:ui' as ui;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:user_admin/features/app_manager/cubit/app_manager_cubit.dart';
import 'package:user_admin/features/coupons/cubit/coupons_cubit.dart';
import 'package:user_admin/features/coupons/model/coupon_model/coupon_model.dart';
import 'package:user_admin/features/coupons/view/widgets/add_coupon_widget.dart';
import 'package:user_admin/global/blocs/delete_cubit/cubit/delete_cubit.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/model/role_model/role_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/insure_delete_widget.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_drawer.dart';
import 'package:user_admin/global/widgets/main_error_widget.dart';
import 'package:user_admin/global/widgets/select_page_tile.dart';
import '../../../global/widgets/main_add_button.dart';
import '../../../global/widgets/main_app_bar.dart';

abstract class CouponsViewCallBacks {
  void onAddTap();
  void onEditTap(CouponModel coupon);
  void onDeleteTap(CouponModel coupon);
  void onSaveDeleteTap(CouponModel coupon);
  void onSaveActivateTap(CouponModel coupon);
  void onActivateTap(CouponModel coupon);
  void onSelectPageTap(int page);
  Future<void> onRefresh();
  void onTryAgainTap();
}

class CouponsView extends StatelessWidget {
  const CouponsView({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return CouponsPage(permissions: permissions, restaurant: restaurant);
  }
}

class CouponsPage extends StatefulWidget {
  const CouponsPage({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage>
    implements CouponsViewCallBacks {
  late final CouponsCubit couponsCubit = context.read();
  late final DeleteCubit deleteCubit = context.read();
  late final StreamSubscription<List<ConnectivityResult>> subscription;

  late final bool canAdd;
  late final bool canEdit;
  late final bool canDelete;
  late final bool canActivate;

  int selectedPage = 1;

  @override
  void initState() {
    super.initState();
    final p = widget.permissions.map((e) => e.name).toSet();
    canAdd = p.contains("coupon.add");
    canEdit = p.contains("coupon.update");
    canDelete = p.contains("coupon.delete");
    canActivate = p.contains("coupon.active");

    couponsCubit.getCoupons(page: selectedPage);
    subscription = Connectivity().onConnectivityChanged.listen((result) {
      if (result.isNotEmpty && !result.contains(ConnectivityResult.none)) {
        couponsCubit.getCoupons(page: selectedPage);
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  // ===== Callbacks =====
  @override
  void onAddTap() {
    showDialog(
      context: context,
      builder: (_) => AddCouponWidget(
        isEdit: false,
        selectedPage: selectedPage,
      ),
    );
  }

  @override
  void onEditTap(CouponModel c) {
    showDialog(
      context: context,
      builder: (_) => AddCouponWidget(
        isEdit: true,
        coupon: c,
        selectedPage: selectedPage,
      ),
    );
  }

  @override
  void onDeleteTap(CouponModel c) {
    showDialog(
      context: context,
      builder: (_) => InsureDeleteWidget(
        isDelete: true,
        item: c,
        onSaveTap: onSaveDeleteTap,
      ),
    );
  }

  @override
  void onSaveDeleteTap(CouponModel c) {
    deleteCubit.deleteItem<CouponModel>(c);
  }

  @override
  void onActivateTap(CouponModel c) {
    showDialog(
      context: context,
      builder: (_) => InsureDeleteWidget(
        isDelete: false,
        item: c,
        onSaveTap: onSaveActivateTap,
      ),
    );
  }

  @override
  void onSaveActivateTap(CouponModel c) {
    deleteCubit.deactivateItem(c);
  }

  @override
  void onSelectPageTap(int page) {
    if (selectedPage != page) {
      setState(() => selectedPage = page);
      couponsCubit.getCoupons(page: page);
    }
  }

  @override
  Future<void> onRefresh() async {
    couponsCubit.getCoupons(page: selectedPage);
  }

  @override
  void onTryAgainTap() {
    couponsCubit.getCoupons(page: selectedPage);
  }

  @override
  Widget build(BuildContext context) {
    final Color brand = widget.restaurant.color ?? const Color(0xFF2E4D2F);

    return BlocListener<AppManagerCubit, AppManagerState>(
      listener: (_, state) {
        if (state is DeletedState) {
          couponsCubit.getCoupons(page: selectedPage);
        }
      },
      child: Scaffold(
        drawer: MainDrawer(
          permissions: widget.permissions,
          restaurant: widget.restaurant,
        ),
        appBar: MainAppBar(
            restaurant: widget.restaurant,
            title: "coupons".tr(),
      onSearchChanged: (q) => couponsCubit.searchByName(q),
      onSearchSubmitted: (q) => couponsCubit.searchByName(q),
      onSearchClosed: () => couponsCubit.searchByName(''),
      onLanguageToggle: (loc) {
      },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: canAdd
            ? MainAddButton(
          onTap: onAddTap,
          color: widget.restaurant.color ?? const Color(0xFFE3170A),
          // heroTag: 'fab-add-coupons',
          // tooltip: 'add_coupon',
        )
            : null,

        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: BlocBuilder<CouponsCubit, GeneralCouponsState>(
                buildWhen: (_, s) => s is CouponsState,
                builder: (context, state) {
                  if (state is CouponsLoading) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: LoadingIndicator(color: AppColors.black),
                    );
                  } else if (state is CouponsSuccess) {
                    final data = state.coupons.data;
                    if (data.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: MainErrorWidget(error: "no_data".tr()),
                      );
                    }

                    return Column(
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          itemCount: data.length,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio:
                            0.85,
                          ),
                          itemBuilder: (_, i) {
                            final c = data[i];
                            return _CouponCard(
                              coupon: c,
                              brand: brand,
                              onEdit: canEdit ? () => onEditTap(c) : null,
                              onDelete: canDelete ? () => onDeleteTap(c) : null,
                              onToggleActive:
                              canActivate ? () => onActivateTap(c) : null,
                            );
                          },
                        ),
                        if (state.coupons.meta.totalPages > 1) ...[
                          const SizedBox(height: 12),
                          SelectPageTile(
                            length: state.coupons.meta.totalPages,
                            selectedPage: selectedPage,
                            onSelectPageTap: onSelectPageTap,
                          ),
                        ],
                      ],
                    );
                  } else if (state is CouponsEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: MainErrorWidget(error: state.message),
                    );
                  } else if (state is CouponsFail) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: MainErrorWidget(
                        error: state.error,
                        onTryAgainTap: onTryAgainTap,
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class _AddFab extends StatelessWidget {
  const _AddFab({required this.brand, required this.onTap, this.heroTag});
  final Color brand;
  final VoidCallback onTap;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 4, bottom: 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: brand.withOpacity(.25), width: 1.4),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.add_rounded, size: 26, color: brand),
          ),
        ),
      ),
    );
  }
}


class _CouponCard extends StatelessWidget {
  const _CouponCard({
    required this.coupon,
    required this.brand,
    this.onEdit,
    this.onDelete,
    this.onToggleActive,
  });

  final CouponModel coupon;
  final Color brand;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleActive;

  String _fmtDate(String s) => s.isEmpty ? '—' : s;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.black.withOpacity(.08), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.grey.shade200,
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _BarcodeTicket(
                              code: coupon.code,
                              width: 110,
                              height: 36,
                            ),
                            const SizedBox(height: 6),
                            Expanded(
                              child: Directionality(
                                textDirection: ui.TextDirection.rtl,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    _oneLine('رمز الكوبون : ${coupon.code}'),
                                    _oneLine('من : ${_fmtDate(coupon.fromDate)}'),
                                    _oneLine('إلى : ${_fmtDate(coupon.toDate)}'),
                                    _oneLine('الحالة : ${coupon.isActive ? "فعال" : "غير فعال"}'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        Positioned.fill(
                          child: IgnorePointer(
                            child: CustomPaint(
                              painter: _RopePainter(
                                startAlign: const Alignment(-0.78, -0.55),
                                endAlign: const Alignment(-1.12, 0.96),
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          left: -22,
                          bottom: -12,
                          child: _DiscountTag(percent: coupon.percent),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  height: 46,
                  color: brand,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _BarCircleIcon(
                        icon: coupon.isActive ? Icons.block : Icons.check_circle,
                        onTap: onToggleActive,
                      ),
                      _BarCircleIcon(icon: Icons.edit, onTap: onEdit),
                      _BarCircleIcon(icon: Icons.delete_outline, onTap: onDelete),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _BarcodeTicket extends StatelessWidget {
  const _BarcodeTicket({
    required this.code,
    this.width = 98,
    this.height = 46,
  });

  final String code;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // جسم التذكرة
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF4B4B4B),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),

          // "أسنان" صغيرة أعلى التذكرة
          Positioned(
            top: -3,
            left: 6,
            right: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                8,
                    (_) => Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),

          // شرائط الباركود
          Positioned.fill(
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(13, (i) {
                  final double w = switch (i % 5) {
                    0 => 3.2,
                    1 => 2.4,
                    2 => 1.8,
                    3 => 2.8,
                    _ => 1.4,
                  };
                  final double h = 16 + (i % 4 == 0 ? 4 : 0);
                  return Container(
                    width: w,
                    height: h,
                    margin: const EdgeInsets.symmetric(horizontal: 1.4),
                    color: Colors.white,
                  );
                }),
              ),
            ),
          ),

          // الكود أعلى/داخل التذكرة
          Positioned(
            top: 4,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                code,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _RopePainter extends CustomPainter {
  _RopePainter({required this.startAlign, required this.endAlign});

  final Alignment startAlign;
  final Alignment endAlign;

  @override
  void paint(Canvas canvas, Size size) {
    final start = Offset(
      size.width  * (startAlign.x * 0.5 + 0.5),
      size.height * (startAlign.y * 0.5 + 0.5),
    );
    final end = Offset(
      size.width  * (endAlign.x * 0.5 + 0.5),
      size.height * (endAlign.y * 0.5 + 0.5),
    );

    final ctrl1 = Offset(start.dx - 18, start.dy + 12);
    final ctrl2 = Offset(end.dx + 14,   end.dy - 10);

    final ropePaint = Paint()
      ..color = const Color(0xFF444444)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.35
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(ctrl1.dx, ctrl1.dy, ctrl2.dx, ctrl2.dy, end.dx, end.dy);

    // حلقة عند بداية الخيط
    final ringPaint = Paint()
      ..color = const Color(0xFF444444)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    canvas.drawCircle(start, 3.6, ringPaint);

    // الخيط
    canvas.drawPath(path, ropePaint);

    // عقدة صغيرة عند النهاية
    final tipPaint = Paint()..color = const Color(0xFF444444);
    canvas.drawCircle(end, 2.2, tipPaint);
  }

  @override
  bool shouldRepaint(covariant _RopePainter old) =>
      old.startAlign != startAlign || old.endAlign != endAlign;
}


class _DiscountTag extends StatelessWidget {
  const _DiscountTag({this.percent});
  final int? percent;

  @override
  Widget build(BuildContext context) {
    final p = percent ?? 0;
    return Transform.rotate(
      angle: -0.20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFFC7D86B),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.10),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "الخصم",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w700,
                fontSize: 10.5,
              ),
            ),
            Text(
              '$p%',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _BarCircleIcon extends StatelessWidget {
  const _BarCircleIcon({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return Opacity(
      opacity: disabled ? .55 : 1,
      child: InkResponse(
        onTap: disabled ? null : onTap,
        radius: 26,
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1.6),
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: Colors.white, size: 16.5),
        ),
      ),
    );
  }
}


Widget _oneLine(String text) => Text(
  text,
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
  style: const TextStyle(fontSize: 11.5, height: 1.05),
);







