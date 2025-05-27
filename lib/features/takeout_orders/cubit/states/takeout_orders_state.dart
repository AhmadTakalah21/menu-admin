part of '../takeout_orders_cubit.dart';

@immutable
class TakeoutOrdersState extends GeneralTakeoutOrdersState {}

final class TakeoutOrdersInitial extends TakeoutOrdersState {}

final class TakeoutOrdersLoading extends TakeoutOrdersState {}

final class TakeoutOrdersSuccess extends TakeoutOrdersState {
  final PaginatedModel<DrvierInvoiceModel> paginatedModel;

  TakeoutOrdersSuccess(this.paginatedModel);
}

final class TakeoutOrdersEmpty extends TakeoutOrdersState {
  final String message;

  TakeoutOrdersEmpty(this.message);
}

final class TakeoutOrdersFail extends TakeoutOrdersState {
  final String error;

  TakeoutOrdersFail(this.error);
}
