part of '../drivers_cubit.dart';

@immutable
class AddDriverState extends GeneralDriversState {}

final class AddDriverInitial extends AddDriverState {}

final class AddDriverLoading extends AddDriverState {}

final class AddDriverSuccess extends AddDriverState {
  final String message;

  AddDriverSuccess(this.message);
}

final class AddDriverFail extends AddDriverState {
  final String error;

  AddDriverFail(this.error);
}
