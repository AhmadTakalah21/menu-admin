import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:user_admin/features/coupons/model/add_coupon_model/add_coupon_model.dart';
import 'package:user_admin/features/coupons/model/coupon_model/coupon_model.dart';
import 'package:user_admin/features/coupons/service/coupon_service.dart';
import 'package:user_admin/global/model/paginated_model/paginated_model.dart';

part 'states/coupons_state.dart';
part 'states/general_coupons_state.dart';
part 'states/add_coupon_state.dart';

@injectable
class CouponsCubit extends Cubit<GeneralCouponsState> {
  CouponsCubit(this.couponService) : super(GeneralCouponsInitial());

  final CouponService couponService;
  AddCouponModel addCouponModel = const AddCouponModel();

  // ---- بحث + ديباونس ----
  String _searchQuery = '';
  Timer? _debounce;
  int _lastPage = 1;

  /// تستدعى من شريط البحث
  void searchByName(String q) {
    _searchQuery = q.trim();
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      getCoupons(page: _lastPage); // نجلب ثم نفلتر محلياً
    });
  }

  /// لمسح البحث عند إغلاق الشريط
  void clearSearch() {
    if (_searchQuery.isEmpty) return;
    _searchQuery = '';
    _lastPage = 1;
    getCoupons(page: _lastPage);
  }
  // ------------------------

  void setCouponId(int id) {
    addCouponModel = addCouponModel.copyWith(id: id);
  }

  void setCode(String code) {
    addCouponModel = addCouponModel.copyWith(code: code);
  }

  void setFromDate(String? fromDate) {
    addCouponModel = addCouponModel.copyWith(fromDate: fromDate);
  }

  void setToDate(String? toDate) {
    addCouponModel = addCouponModel.copyWith(toDate: toDate);
  }

  void setPercent(String percent) {
    addCouponModel = addCouponModel.copyWith(percent: percent);
  }

  Future<void> getCoupons({int? page}) async {
    _lastPage = page ?? 1;

    emit(CouponsLoading());
    try {
      final coupons = await couponService.getCoupons(page: page);
      _emitWithFilter(coupons);
    } catch (e) {
      emit(CouponsFail(e.toString()));
    }
  }

  void _emitWithFilter(PaginatedModel<CouponModel> src) {
    if (_searchQuery.isEmpty) {
      if (src.data.isEmpty) {
        emit(CouponsEmpty("no_coupons".tr()));
      } else {
        emit(CouponsSuccess(src));
      }
      return;
    }

    final q = _searchQuery.toLowerCase();
    final filtered = src.data.where((c) {
      final code = (c.code ?? '').toLowerCase();
      final percent = (c.percent?.toString() ?? '').toLowerCase();
      final from = (c.fromDate ?? '').toLowerCase();
      final to = (c.toDate ?? '').toLowerCase();
      return code.contains(q) || percent.contains(q) || from.contains(q) || to.contains(q);
    }).toList();

    if (filtered.isEmpty) {
      emit(CouponsEmpty("no_coupons".tr()));
      return;
    }

    // إعادة بناء PaginatedModel بنفس الـ meta لكن ببيانات مفلترة
    final map = json.decode(src.toString()) as Map<String, dynamic>;
    map['data'] = filtered.map((e) => e.toJson()).toList();
    final rebuilt = PaginatedModel.fromString(
      json.encode(map),
          (json) => CouponModel.fromJson(json as Map<String, dynamic>),
    );

    emit(CouponsSuccess(rebuilt));
  }

  Future<void> addCoupon({required bool isEdit, int? couponId}) async {
    if (isEdit && couponId != null) {
      addCouponModel = addCouponModel.copyWith(id: couponId);
    } else {
      if (!addCouponModel.validateCode()) {
        emit(AddCouponFail("code_empty".tr()));
        return;
      }
    }
    emit(AddCouponLoading());
    try {
      await couponService.addCoupon(
        addCouponModel,
        isEdit: isEdit,
      );
      final successMessage =
      isEdit ? "edit_coupon_success".tr() : "add_coupon_success".tr();
      emit(AddCouponSuccess(successMessage));
    } catch (e) {
      emit(AddCouponFail(e.toString()));
    }
  }


  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
