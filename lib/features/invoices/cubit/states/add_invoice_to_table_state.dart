part of '../invoices_cubit.dart';

@immutable
class AddInvoiceToTableState extends GeneralInvoicesState {}

final class AddInvoiceToTableInitial extends AddInvoiceToTableState {}

final class AddInvoiceToTableLoading extends AddInvoiceToTableState {}

final class AddInvoiceToTableSuccess extends AddInvoiceToTableState {
  final String message;
  final DrvierInvoiceModel invoice;
  AddInvoiceToTableSuccess(this.invoice, this.message);
}

final class AddInvoiceToTableFail extends AddInvoiceToTableState {
  final String error;
  AddInvoiceToTableFail(this.error);
}

class ApplyCouponLoading extends GeneralInvoicesState {}
class ApplyCouponSuccess extends GeneralInvoicesState {
  final DrvierInvoiceModel invoice;
  ApplyCouponSuccess(this.invoice);
}
class ApplyCouponFail extends GeneralInvoicesState {
  final String error;
  ApplyCouponFail(this.error);
}