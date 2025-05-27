part of '../tables_cubit.dart';

@immutable
class EditOrderInTableState extends GeneralTablesState {}

class EditOrderInTableInitial extends EditOrderInTableState {}

class EditOrderInTableLoading extends EditOrderInTableState {}

class EditOrderInTableSuccess extends EditOrderInTableState {
  final String message;

  EditOrderInTableSuccess(this.message);
}

class EditOrderInTableFail extends EditOrderInTableState {
  final String error;

  EditOrderInTableFail(this.error);
}
