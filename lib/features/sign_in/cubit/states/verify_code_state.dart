part of '../sign_in_cubit.dart';

@immutable
class VerifyCodeState extends GeneralSignInState {}

class VerifyCodeInitial extends VerifyCodeState {}

class VerifyCodeLoading extends VerifyCodeState {}

class VerifyCodeSuccess extends VerifyCodeState {}

class VerifyCodeFail extends VerifyCodeState {
  final String error;

  VerifyCodeFail(this.error);
}
