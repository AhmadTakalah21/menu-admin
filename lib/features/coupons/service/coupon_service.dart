import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:user_admin/features/coupons/model/add_coupon_model/add_coupon_model.dart';
import 'package:user_admin/features/coupons/model/coupon_model/coupon_model.dart';
import 'package:user_admin/global/dio/dio_client.dart';
import 'package:user_admin/global/model/paginated_model/paginated_model.dart';

part "coupon_service_imp.dart";

abstract class CouponService {
  Future<PaginatedModel<CouponModel>> getCoupons({int? page});

  Future<void> addCoupon(
    AddCouponModel addCouponModel, {
    required bool isEdit,
  });
}
