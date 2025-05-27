part of '../tables_cubit.dart';

@immutable
class AddServiceToOrderState extends GeneralTablesState {}

class AddServiceToOrderInitial extends AddServiceToOrderState {}

class AddServiceToOrderLoading extends AddServiceToOrderState {}

class AddServiceToOrderSuccess extends AddServiceToOrderState {
  final String message;

  AddServiceToOrderSuccess(this.message);
}

class AddServiceToOrderFail extends AddServiceToOrderState {
  final String error;

  AddServiceToOrderFail(this.error);
}
