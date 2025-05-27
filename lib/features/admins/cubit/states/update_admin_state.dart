part of '../admins_cubit.dart';

@immutable
class UpdateAdminState extends GeneralAdminsState {}

final class UpdateAdminInitial extends UpdateAdminState {}

final class UpdateAdminLoading extends UpdateAdminState {}

final class UpdateAdminSuccess extends UpdateAdminState {
  final String message;

  UpdateAdminSuccess(this.message);
}

final class UpdateAdminFail extends UpdateAdminState {
  final String error;

  UpdateAdminFail(this.error);
}
