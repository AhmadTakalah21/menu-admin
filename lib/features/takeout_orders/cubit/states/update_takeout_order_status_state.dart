part of '../takeout_orders_cubit.dart';

@immutable
class UpdateTakeoutOrderStatusState extends GeneralTakeoutOrdersState {}

final class UpdateTakeoutOrderStatusInitial extends UpdateTakeoutOrderStatusState {}

final class UpdateTakeoutOrderStatusLoading extends UpdateTakeoutOrderStatusState {

   UpdateTakeoutOrderStatusLoading();
}

final class UpdateTakeoutOrderStatusSuccess extends UpdateTakeoutOrderStatusState {
  final String message;
   UpdateTakeoutOrderStatusSuccess(this.message);
}

final class UpdateTakeoutOrderStatusFail extends UpdateTakeoutOrderStatusState {
  final String error;
   UpdateTakeoutOrderStatusFail(this.error);
}