part of '../admins_cubit.dart';

@immutable
class UserRolesState extends GeneralAdminsState {}

final class UserRolesInitial extends UserRolesState {}

final class UserRolesLoading extends UserRolesState {}

final class UserRolesSuccess extends UserRolesState {
  final List<UserTypeModel> userRoles;

  UserRolesSuccess(this.userRoles);
}

final class UserRolesFail extends UserRolesState {
  final String error;

  UserRolesFail(this.error);
}
