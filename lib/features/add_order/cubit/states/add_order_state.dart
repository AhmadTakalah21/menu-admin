part of '../add_order_cubit.dart';

@immutable
class AddOrderState extends GeneralAddOrderState {}

final class AddOrderInitial extends AddOrderState {}

final class AddOrderLoading extends AddOrderState {}

final class AddOrderSuccess extends AddOrderState {}

final class AddOrderFail extends AddOrderState {
  final String error;

  AddOrderFail(this.error);
}

