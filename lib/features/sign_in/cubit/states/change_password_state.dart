part of '../sign_in_cubit.dart';

@immutable
class ChangePasswordState extends GeneralSignInState {}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordLoading extends ChangePasswordState {}

class ChangePasswordSuccess extends ChangePasswordState {
  final String message = "Change Password Successfully";
}

class ChangePasswordFail extends ChangePasswordState {
  final String error;

  ChangePasswordFail(this.error);
}
