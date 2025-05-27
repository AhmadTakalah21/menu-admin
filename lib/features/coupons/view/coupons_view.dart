import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/app_manager/cubit/app_manager_cubit.dart';
import 'package:user_admin/features/coupons/cubit/coupons_cubit.dart';
import 'package:user_admin/features/coupons/model/coupon_model/coupon_model.dart';
import 'package:user_admin/features/coupons/view/widgets/add_coupon_widget.dart';
import 'package:user_admin/features/sign_in/model/sign_in_model/sign_in_model.dart';
import 'package:user_admin/global/blocs/delete_cubit/cubit/delete_cubit.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/insure_delete_widget.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_back_button.dart';
import 'package:user_admin/global/widgets/main_data_table.dart';
import 'package:user_admin/global/widgets/main_drawer.dart';
import 'package:user_admin/global/widgets/main_error_widget.dart';
import 'package:user_admin/global/widgets/select_page_tile.dart';

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
  const CouponsView({super.key, required this.signInModel});

  final SignInModel signInModel;

  @override
  Widget build(BuildContext context) {
    return CouponsPage(signInModel: signInModel);
  }
}

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key, required this.signInModel});

  final SignInModel signInModel;

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage>
    implements CouponsViewCallBacks {
  late final CouponsCubit couponsCubit = context.read();
  late final DeleteCubit deleteCubit = context.read();

  late final bool canAdd;
  late final bool canEdit;
  late final bool canDelete;
  late final bool canActivate;

  int selectedPage = 1;

  @override
  void initState() {
    super.initState();
    _loadPermissions();
    couponsCubit.getCoupons(page: selectedPage);
  }

  void _loadPermissions() {
    final permissions =
        widget.signInModel.permissions.map((e) => e.name).toSet();
    canAdd = permissions.contains("coupon.add");
    canEdit = permissions.contains("coupon.update");
    canDelete = permissions.contains("coupon.delete");
    canActivate = permissions.contains("coupon.active");
  }

  @override
  void onAddTap() {
    showDialog(
      context: context,
      builder: (context) => AddCouponWidget(
        isEdit: false,
        selectedPage: selectedPage,
      ),
    );
  }

  @override
  void onDeleteTap(CouponModel coupon) {
    showDialog(
      context: context,
      builder: (context) {
        return InsureDeleteWidget(
          isDelete: true,
          item: coupon,
          onSaveTap: onSaveDeleteTap,
        );
      },
    );
  }

  @override
  void onSaveDeleteTap(CouponModel coupon) {
    deleteCubit.deleteItem<CouponModel>(coupon);
  }

  @override
  void onActivateTap(CouponModel coupon) {
    showDialog(
      context: context,
      builder: (context) {
        return InsureDeleteWidget(
          isDelete: false,
          item: coupon,
          onSaveTap: onSaveActivateTap,
        );
      },
    );
  }

  @override
  void onSaveActivateTap(CouponModel coupon) {
    deleteCubit.deactivateItem(coupon);
  }

  @override
  void onEditTap(CouponModel coupon) {
    showDialog(
      context: context,
      builder: (context) => AddCouponWidget(
        isEdit: true,
        coupon: coupon,
        selectedPage: selectedPage,
      ),
    );
  }

  @override
  void onSelectPageTap(int page) {
    if (selectedPage != page) {
      setState(() {
        selectedPage = page;
      });
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
    final List<String> titles = [
      "code".tr(),
      "discount".tr(),
      "from".tr(),
      "to".tr(),
      "status".tr(),
    ];

    if (canEdit || canDelete || canActivate) {
      titles.add("event".tr());
    }

    final restColor = widget.signInModel.restaurant.color;

    return BlocListener<AppManagerCubit, AppManagerState>(
      listener: (context, state) {
        if (state is DeletedState) {
          couponsCubit.getCoupons(page: selectedPage);
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        drawer: MainDrawer(signInModel: widget.signInModel),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            child: Padding(
              padding: AppConstants.padding16,
              child: Column(
                children: [
                  MainBackButton(color: restColor ?? AppColors.black),
                  const SizedBox(height: 20),
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildCouponsTable(titles),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          "coupons".tr(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        MainActionButton(
          padding: AppConstants.padding10,
          onPressed: onRefresh,
          text: "",
          child: const Icon(Icons.refresh, color: AppColors.white),
        ),
        if (canAdd) const SizedBox(width: 10),
        if (canAdd)
          MainActionButton(
            padding: AppConstants.padding10,
            onPressed: onAddTap,
            text: "add_order".tr(),
            child: const Icon(Icons.add_circle, color: AppColors.white),
          ),
      ],
    );
  }

  Widget _buildCouponsTable(List<String> titles) {
    return BlocBuilder<CouponsCubit, GeneralCouponsState>(
      buildWhen: (previous, current) => current is CouponsState,
      builder: (context, state) {
        if (state is CouponsLoading) {
          return const LoadingIndicator(color: AppColors.black);
        } else if (state is CouponsSuccess) {
          final rows = state.coupons.data
              .map((coupon) => _buildDataRow(coupon))
              .toList();
          return Column(
            children: [
              MainDataTable(titles: titles, rows: rows),
              SelectPageTile(
                length: state.coupons.meta.totalPages,
                selectedPage: selectedPage,
                onSelectPageTap: onSelectPageTap,
              ),
            ],
          );
        } else if (state is CouponsEmpty) {
          return Text(state.message);
        } else if (state is CouponsFail) {
          return MainErrorWidget(
            error: state.error,
            onTryAgainTap: onTryAgainTap,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  DataRow _buildDataRow(CouponModel coupon) {
    final values = [
      Text(coupon.code),
      Text(coupon.percent.toString()),
      Text(coupon.fromDate),
      Text(coupon.toDate),
      MainActionButton(
        padding: AppConstants.padding6,
        onPressed: () {},
        text: coupon.isActive ? "active".tr() : "inactive".tr(),
        buttonColor: coupon.isActive ? AppColors.greenShade : AppColors.red,
      ),
      if (canEdit || canDelete || canActivate)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (canDelete)
              InkWell(
                  onTap: () => onDeleteTap(coupon),
                  child: const Icon(Icons.delete)),
            if (canDelete) const SizedBox(width: 10),
            if (canEdit)
              InkWell(
                  onTap: () => onEditTap(coupon),
                  child: const Icon(Icons.edit_outlined)),
            if (canEdit) const SizedBox(width: 10),
            if (canActivate)
              InkWell(
                onTap: () => onActivateTap(coupon),
                child: Icon(
                  coupon.isActive ? Icons.block : Icons.check_circle,
                  size: 30,
                ),
              ),
          ],
        )
    ];
    return DataRow(
      cells: values.map((val) => DataCell(Center(child: val))).toList(),
    );
  }
}
