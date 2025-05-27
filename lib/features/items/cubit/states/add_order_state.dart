part of '../items_cubit.dart';

@immutable
class AddOrderState extends GeneralItemsState {}

class AddOrderInitial extends AddOrderState {}

class AddOrderLoading extends AddOrderState {}

class AddOrderSuccess extends AddOrderState {
  final String message;

  AddOrderSuccess(this.message);
}

class AddOrderFail extends AddOrderState {
  final String error;

  AddOrderFail(this.error);
}
