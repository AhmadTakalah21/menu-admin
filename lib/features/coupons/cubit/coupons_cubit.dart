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

  void setCouponId(int id) {
    addCouponModel = addCouponModel.copyWith(id: id);
  }

  void setCode(String code) {
    addCouponModel = addCouponModel.copyWith(code: code);
  }

  void setFromDate(String? fromDate) {
    addCouponModel =
        addCouponModel.copyWith(fromDate: fromDate);
  }

  void setToDate(String? toDate) {
    addCouponModel =
        addCouponModel.copyWith(toDate: toDate);
  }

  void setPercent(String percent) {
    addCouponModel = addCouponModel.copyWith(percent: percent);
  }

  Future<void> getCoupons({int? page}) async {
    emit(CouponsLoading());
    try {
      final services = await couponService.getCoupons(page: page);
      if (services.data.isEmpty) {
        emit(CouponsEmpty("no_coupons".tr()));
      } else {
        emit(CouponsSuccess(services));
      }
    } catch (e) {
      emit(CouponsFail(e.toString()));
    }
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
}
