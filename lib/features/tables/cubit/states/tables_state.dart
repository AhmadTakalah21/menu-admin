part of '../tables_cubit.dart';



@immutable
class TablesStates extends GeneralTablesState {}

class TablesInitial extends TablesStates {}

class TablesLoading extends TablesStates {}

class TablesSuccess extends TablesStates {
  final PaginatedModel<TableModel> tables;

  TablesSuccess(this.tables);
}

class TablesEmpty extends TablesStates {
  final String message;

  TablesEmpty(this.message);
}

class TablesFail extends TablesStates {
  final String error;

  TablesFail(this.error);
}
