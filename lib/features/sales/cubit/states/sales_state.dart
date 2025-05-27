part of '../sales_cubit.dart';

@immutable
class SalesState extends GeneralSalesState {}

final class SalesInitial extends SalesState {}

final class SalesLoading extends SalesState {}

final class SalesSuccess extends SalesState {
  final PaginatedModel<OrderDetailsModel> paginatedModel;

  SalesSuccess(this.paginatedModel);
}

final class SalesEmpty extends SalesState {
  final String message;

  SalesEmpty(this.message);
}

final class SalesFail extends SalesState {
  final String error;

  SalesFail(this.error);
}
