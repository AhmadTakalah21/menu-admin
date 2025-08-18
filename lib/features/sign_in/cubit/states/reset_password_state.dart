part of '../sign_in_cubit.dart';

@immutable
class ResetPasswordState extends GeneralSignInState {}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {}

class ResetPasswordFail extends ResetPasswordState {
  final String error;

  ResetPasswordFail(this.error);
}
