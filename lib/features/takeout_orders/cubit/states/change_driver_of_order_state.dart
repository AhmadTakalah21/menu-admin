part of '../takeout_orders_cubit.dart';

@immutable
class ChangeDriverOfOrderState extends GeneralTakeoutOrdersState {}

final class ChangeDriverOfOrderInitial extends ChangeDriverOfOrderState {}

final class ChangeDriverOfOrderLoading extends ChangeDriverOfOrderState {}

final class ChangeDriverOfOrderSuccess extends ChangeDriverOfOrderState {
  final String message;

  ChangeDriverOfOrderSuccess(this.message);
}

final class ChangeDriverOfOrderFail extends ChangeDriverOfOrderState {
  final String error;

  ChangeDriverOfOrderFail(this.error);
}
