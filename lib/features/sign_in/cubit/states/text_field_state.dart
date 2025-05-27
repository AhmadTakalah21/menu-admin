part of '../sign_in_cubit.dart';

@immutable
class TextFieldState extends GeneralSignInState {
  TextFieldState(this.type, {this.error});

  final TextFieldType type;
  final String? error;
}

enum TextFieldType {
  name,
  username,
  password,
  phoneNumber,
  address,
  email,
  question,
  answer;
}
