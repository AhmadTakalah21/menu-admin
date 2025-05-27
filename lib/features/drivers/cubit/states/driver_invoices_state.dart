part of '../drivers_cubit.dart';

@immutable
class DriverInvoicesState extends GeneralDriversState {}

final class DriverInvoicesInitial extends DriverInvoicesState {}

final class DriverInvoicesLoading extends DriverInvoicesState {}

final class DriverInvoicesSuccess extends DriverInvoicesState {
  final PaginatedModel<DrvierInvoiceModel> invoices;

  DriverInvoicesSuccess(this.invoices);
}

final class DriverInvoicesEmpty extends DriverInvoicesState {
  final String message;

  DriverInvoicesEmpty(this.message);
}

final class DriverInvoicesFail extends DriverInvoicesState {
  final String error;

  DriverInvoicesFail(this.error);
}
