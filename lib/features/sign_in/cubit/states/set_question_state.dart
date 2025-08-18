part of '../sign_in_cubit.dart';

@immutable
class SetQuestionState extends GeneralSignInState {
  final QuestionModel question;

  SetQuestionState(this.question);
}
