part of '../admins_cubit.dart';

@immutable
class UserTypesState extends GeneralAdminsState {}

final class UserTypesInitial extends UserTypesState {}

final class UserTypesLoading extends UserTypesState {}

final class UserTypesSuccess extends UserTypesState {
  final List<UserTypeModel> userTypes;

  UserTypesSuccess(this.userTypes);
}

final class UserTypesFail extends UserTypesState {
  final String error;

  UserTypesFail(this.error);
}
