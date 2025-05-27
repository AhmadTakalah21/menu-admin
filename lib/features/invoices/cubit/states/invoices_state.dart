part of '../invoices_cubit.dart';

@immutable
class InvoicesState extends GeneralInvoicesState {}

final class InvoicesInitial extends InvoicesState {}

final class InvoicesLoading extends InvoicesState {}

final class InvoicesSuccess extends InvoicesState {
  final PaginatedModel<DrvierInvoiceModel>paginatedModel;

  InvoicesSuccess(this.paginatedModel);
}

final class InvoicesEmpty extends InvoicesState {
  final String message;

  InvoicesEmpty(this.message);
}

final class InvoicesFail extends InvoicesState {
  final String error;

  InvoicesFail(this.error);
}
