part of '../tables_cubit.dart';

@immutable
class TableOrdersState extends GeneralTablesState {}

class TableOrdersInitial extends TableOrdersState {}

class TableOrdersLoading extends TableOrdersState {}

class TableOrdersSuccess extends TableOrdersState {
  final PaginatedModel<OrderDetailsModel> tableOrders;

  TableOrdersSuccess(this.tableOrders);
}

class TableOrdersEmpty extends TableOrdersState {
  final String message;

  TableOrdersEmpty(this.message);
}

class TableOrdersFail extends TableOrdersState {
  final String error;

  TableOrdersFail(this.error);
}
