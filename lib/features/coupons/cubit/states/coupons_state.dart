part of '../coupons_cubit.dart';

@immutable
class CouponsState extends GeneralCouponsState {}

final class CouponsInitial extends CouponsState {}

final class CouponsLoading extends CouponsState {}

final class CouponsSuccess extends CouponsState {
  final PaginatedModel<CouponModel> coupons;

  CouponsSuccess(this.coupons);
}

final class CouponsEmpty extends CouponsState {
  final String message;

  CouponsEmpty(this.message);
}

final class CouponsFail extends CouponsState {
  final String error;

  CouponsFail(this.error);
}
