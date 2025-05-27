part of '../invoices_cubit.dart';

@immutable
class UpdateStatusToPaidState extends GeneralInvoicesState {}

final class UpdateStatusToPaidInitial extends UpdateStatusToPaidState {}

final class UpdateStatusToPaidLoading extends UpdateStatusToPaidState {
  final int index;

  UpdateStatusToPaidLoading(this.index);
}

final class UpdateStatusToPaidSuccess extends UpdateStatusToPaidState {
  final String message;
  final int index;

  UpdateStatusToPaidSuccess(this.message, this.index);
}

final class UpdateStatusToPaidFail extends UpdateStatusToPaidState {
  final String error;
  final int index;

  UpdateStatusToPaidFail(this.error, this.index);
}
