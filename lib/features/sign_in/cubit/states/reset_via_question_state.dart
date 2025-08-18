part of '../sign_in_cubit.dart';

@immutable
class ResetViaQuestionState extends GeneralSignInState {}

class ResetViaQuestionInitial extends ResetViaQuestionState {}

class ResetViaQuestionLoading extends ResetViaQuestionState {}

class ResetViaQuestionSuccess extends ResetViaQuestionState {}

class ResetViaQuestionFail extends ResetViaQuestionState {
  final String error;

  ResetViaQuestionFail(this.error);
}
