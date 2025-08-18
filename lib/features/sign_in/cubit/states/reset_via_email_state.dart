part of '../sign_in_cubit.dart';

@immutable
class ResetViaEmailState extends GeneralSignInState {}

class ResetViaEmailInitial extends ResetViaEmailState {}

class ResetViaEmailLoading extends ResetViaEmailState {}

class ResetViaEmailSuccess extends ResetViaEmailState {}

class ResetViaEmailFail extends ResetViaEmailState {
  final String error;

  ResetViaEmailFail(this.error);
}
