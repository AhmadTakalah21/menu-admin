part of '../invoices_cubit.dart';

@immutable
class AddInvoiceToTableState extends GeneralInvoicesState {}

final class AddInvoiceToTableInitial extends AddInvoiceToTableState {}

final class AddInvoiceToTableLoading extends AddInvoiceToTableState {}

final class AddInvoiceToTableSuccess extends AddInvoiceToTableState {
  final String message;

  AddInvoiceToTableSuccess(this.message);
}

final class AddInvoiceToTableFail extends AddInvoiceToTableState {
  final String error;

  AddInvoiceToTableFail(this.error);
}
