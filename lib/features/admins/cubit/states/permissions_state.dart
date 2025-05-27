part of '../admins_cubit.dart';

@immutable
class PermissionsState extends GeneralAdminsState {}

final class PermissionsInitial extends PermissionsState {}

final class PermissionsLoading extends PermissionsState {}

final class PermissionsSuccess extends PermissionsState {
  final List<PermissionModel> permissions;

  PermissionsSuccess(this.permissions);
}

final class PermissionsEmpty extends PermissionsState {
  final String message;

  PermissionsEmpty(this.message);
}

final class PermissionsFail extends PermissionsState {
  final String error;

  PermissionsFail(this.error);
}
