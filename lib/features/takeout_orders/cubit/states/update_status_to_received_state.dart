part of '../takeout_orders_cubit.dart';

@immutable
class UpdateStatusToReceivedState extends GeneralTakeoutOrdersState {}

final class UpdateStatusToReceivedInitial extends UpdateStatusToReceivedState {}

final class UpdateStatusToReceivedLoading extends UpdateStatusToReceivedState {
  final int index;

  UpdateStatusToReceivedLoading(this.index);
}

final class UpdateStatusToReceivedSuccess extends UpdateStatusToReceivedState {
  final String message;
  final int index;
  UpdateStatusToReceivedSuccess(this.message, this.index);
}

final class UpdateStatusToReceivedFail extends UpdateStatusToReceivedState {
  final String error;
  final int index;
  UpdateStatusToReceivedFail(this.error, this.index);
}
