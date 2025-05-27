part of '../coupons_cubit.dart';

@immutable
class AddCouponState extends GeneralCouponsState {}

final class AddCouponInitial extends AddCouponState {}

final class AddCouponLoading extends AddCouponState {}

final class AddCouponSuccess extends AddCouponState {
  final String message;

  AddCouponSuccess(this.message);
}

final class AddCouponFail extends AddCouponState {
  final String error;

  AddCouponFail(this.error);
}
