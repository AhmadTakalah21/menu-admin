part of '../items_cubit.dart';

@immutable
class TablesState extends GeneralItemsState {}

class TablesInitial extends TablesState {}

class TablesLoading extends TablesState {}

class TablesSuccess extends TablesState {
  final PaginatedModel<TableModel> tables;

  TablesSuccess(this.tables);
}

class TablesEmpty extends TablesState {
  final String message;

  TablesEmpty(this.message);
}

class TablesFail extends TablesState {
  final String error;

  TablesFail(this.error);
}
