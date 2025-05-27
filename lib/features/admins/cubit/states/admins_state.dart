part of '../admins_cubit.dart';

@immutable
class AdminsState extends GeneralAdminsState {}

final class AdminsInitial extends AdminsState {}

final class AdminsLoading extends AdminsState {}

final class AdminsSuccess extends AdminsState {
  final PaginatedModel<AdminModel> paginatedModel;

  AdminsSuccess(this.paginatedModel);
}

final class AdminsEmpty extends AdminsState {
  final String message;

  AdminsEmpty(this.message);
}

final class AdminsFail extends AdminsState {
  final String error;

  AdminsFail(this.error);
}
