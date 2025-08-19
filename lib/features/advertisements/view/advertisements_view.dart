import 'dart:async';
import 'dart:math' as math;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:user_admin/features/advertisements/cubit/advertisements_cubit.dart';
import 'package:user_admin/features/advertisements/model/advertisement_model/advertisement_model.dart';
import 'package:user_admin/features/advertisements/view/widgets/add_advertisement_widget.dart';
import 'package:user_admin/features/app_manager/cubit/app_manager_cubit.dart';
import 'package:user_admin/global/blocs/delete_cubit/cubit/delete_cubit.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/model/role_model/role_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/widgets/insure_delete_widget.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_drawer.dart';
import 'package:user_admin/global/widgets/main_error_widget.dart';

import '../../../global/widgets/main_add_button.dart';
import '../../../global/widgets/main_app_bar.dart';

abstract class AdvertisementsViewCallBacks {
  void onAddTap();
  Future<void> onRefresh();
  void onEditTap(AdvertisementModel advertisement);
  void onDeleteTap(AdvertisementModel advertisement);
  void onSaveDeleteTap(AdvertisementModel advertisement);
  void onTryAgainTap();
}

class AdvertisementsView extends StatelessWidget {
  const AdvertisementsView({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return AdvertisemntsPage(permissions: permissions, restaurant: restaurant);
  }
}

class AdvertisemntsPage extends StatefulWidget {
  const AdvertisemntsPage({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  State<AdvertisemntsPage> createState() => _AdvertisemntsPageState();
}

class _AdvertisemntsPageState extends State<AdvertisemntsPage>
    implements AdvertisementsViewCallBacks {
  late final AdvertisementsCubit advertisementsCubit = context.read();
  late final DeleteCubit deleteCubit = context.read();

  late final StreamSubscription<List<ConnectivityResult>> subscription;

  @override
  void initState() {
    super.initState();
    advertisementsCubit.getAdvertisements(isRefresh: true);
    subscription = Connectivity().onConnectivityChanged.listen((result) {
      if (result.isNotEmpty && !result.contains(ConnectivityResult.none)) {
        advertisementsCubit.getAdvertisements(isRefresh: true);
      } else {
        advertisementsCubit.getAdvertisements(isRefresh: false);
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
      builder: (_) => const AddAdvertisementWidget(isEdit: false),
    );
  }

  @override
  void onEditTap(AdvertisementModel ad) {
    showDialog(
      context: context,
      builder: (_) => AddAdvertisementWidget(advertisement: ad, isEdit: true),
    );
  }

  @override
  void onDeleteTap(AdvertisementModel ad) {
    showDialog(
      context: context,
      builder: (_) => InsureDeleteWidget(
        isDelete: true,
        item: ad,
        onSaveTap: onSaveDeleteTap,
      ),
    );
  }

  @override
  void onSaveDeleteTap(AdvertisementModel ad) {
    deleteCubit.deleteItem<AdvertisementModel>(ad);
  }

  @override
  Future<void> onRefresh() async {
    advertisementsCubit.getAdvertisements(isRefresh: true);
  }

  @override
  void onTryAgainTap() {
    advertisementsCubit.getAdvertisements(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final canAdd =
    widget.permissions.any((p) => p.name == "advertisement.add");
    final canEdit =
    widget.permissions.any((p) => p.name == "advertisement.update");
    final canDelete =
    widget.permissions.any((p) => p.name == "advertisement.delete");

    final Color brand = widget.restaurant.color ?? const Color(0xFF2E4D2F);

    return BlocListener<AppManagerCubit, AppManagerState>(
      listener: (_, state) {
        if (state is DeletedState) {
          advertisementsCubit.getAdvertisements(isRefresh: true);
        }
      },
      child: Scaffold(
        drawer: MainDrawer(
          permissions: widget.permissions,
          restaurant: widget.restaurant,
        ),
        appBar:
        MainAppBar(restaurant: widget.restaurant, title: "advertisements".tr()),

        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: canAdd
            ? MainAddButton(
          onTap: onAddTap,
          color: widget.restaurant.color ?? const Color(0xFFE3170A),
          heroTag: 'fab-add-advertisement',
          tooltip: 'add_advertisement',
        )
            : null,
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: BlocBuilder<AdvertisementsCubit, GeneralAdvertisementsState>(
              buildWhen: (_, s) => s is AdvertisementsState,
              builder: (context, state) {
                if (state is AdvertisementsLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 60),
                      child: LoadingIndicator(color: AppColors.black),
                    ),
                  );
                } else if (state is AdvertisementsSuccess) {
                  final data = state.advertisements;
                  if (data.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: MainErrorWidget(error: "no_data".tr()),
                      ),
                    );
                  }

                  const cols = 2;
                  const gap = 14.0;
                  return LayoutBuilder(
                    builder: (context, cons) {
                      final itemH = math.max(
                        220.0,
                        (cons.maxWidth - (cols - 1) * gap) / cols * 0.9 + 60,
                      );

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: cols,
                          crossAxisSpacing: gap,
                          mainAxisSpacing: gap,
                          mainAxisExtent: 260,
                        ),
                        itemCount: data.length,
                        itemBuilder: (_, i) {
                          final ad = data[i];
                          return _AdCard(
                            ad: ad,
                            brand: brand,
                            canEdit: canEdit,
                            canDelete: canDelete,
                            onEdit: canEdit ? () => onEditTap(ad) : null,
                            onDelete: canDelete ? () => onDeleteTap(ad) : null,
                          );
                        },
                      );
                    },
                  );
                } else if (state is AdvertisementsEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: MainErrorWidget(error: state.message),
                    ),
                  );
                } else if (state is AdvertisementsFail) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: MainErrorWidget(
                        error: state.error,
                        onTryAgainTap: onTryAgainTap,
                      ),
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
            child: Icon(
              Icons.add_rounded,
              size: 26,
              color: brand,
            ),
          ),
        ),
      ),
    );
  }
}

// ================== Card ==================

class _AdCard extends StatelessWidget {
  const _AdCard({
    required this.ad,
    required this.brand,
    required this.canEdit,
    required this.canDelete,
    this.onEdit,
    this.onDelete,
  });

  final AdvertisementModel ad;
  final Color brand;
  final bool canEdit;
  final bool canDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  String _fmtDate(String? s) => (s == null || s.isEmpty) ? '—' : s;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: brand.withOpacity(.35), // إطار بنفس لون المطعم
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: brand.withOpacity(.10), // ظل خفيف بنفس اللون
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.white,
          child: InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  // الشريط العلوي (أيقونات + عنوان) مطابق للصورة
                  Row(
                    children: [
                      if (canEdit)
                        _SmallRoundIcon(
                          icon: Icons.edit,
                          color: brand,
                          onTap: onEdit,
                        ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          (ad.title?.isNotEmpty ?? false) ? ad.title! : "إعلان 01",
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13.5,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (canDelete)
                        _SmallRoundIcon(
                          icon: Icons.delete_outline,
                          color: brand,
                          onTap: onDelete,
                        ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // سطر التواريخ كما في الصورة
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'من: ${_fmtDate(ad.fromDate)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11.5, color: Colors.black87),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'إلى: ${_fmtDate(ad.toDate)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11.5, color: Colors.black87),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // مساحة المعاينة/الصورة بنفس الدرجة الخضراء الظاهرة
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        width: double.infinity,
                        color: const Color(0xFFC7D86B),
                        child: (ad.image != null && ad.image!.isNotEmpty)
                            ? Image.network(
                          ad.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.image_not_supported_outlined,
                            size: 36,
                            color: Colors.black38,
                          ),
                        )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SmallRoundIcon extends StatelessWidget {
  const _SmallRoundIcon({
    required this.icon,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkResponse(
        onTap: onTap,
        radius: 20,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color.withOpacity(.08),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 1.6),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }
}

