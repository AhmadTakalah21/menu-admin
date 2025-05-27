part of '../sign_in_cubit.dart';

@immutable
class SignInState extends GeneralSignInState {}

final class SignInInitial extends SignInState {}

final class SignInLoading extends SignInState {}

final class SignInSuccess extends SignInState {
  final SignInModel signInModel;

  SignInSuccess(this.signInModel);
}

final class SignInFail extends SignInState {
  final String error;

  SignInFail(this.error);
}

final class SignOutSuccess extends SignInState {
  final String message;

  SignOutSuccess(this.message);
}
