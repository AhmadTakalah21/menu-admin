part of '../tables_cubit.dart';

@immutable
class EditTableState extends GeneralTablesState {}

class EditTableInitial extends EditTableState {}

class EditTableLoading extends EditTableState {}

class EditTableSuccess extends EditTableState {
  final TableModel tableModel;
  final String message;

  EditTableSuccess(this.tableModel, this.message);
}

class EditTableFail extends EditTableState {
  final String error;

  EditTableFail(this.error);
}
