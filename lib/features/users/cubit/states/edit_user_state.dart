part of '../users_cubit.dart';

@immutable
class EditUserState extends GeneralUsersState {}

final class EditUserInitial extends EditUserState {}

final class EditUserLoading extends EditUserState {}

final class EditUserSuccess extends EditUserState {
  final String message;

  EditUserSuccess(this.message);
}

final class EditUserFail extends EditUserState {
  final String error;

  EditUserFail(this.error);
}
