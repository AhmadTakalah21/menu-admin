part of '../users_cubit.dart';

@immutable
class UsersState extends GeneralUsersState {}

final class UsersInitial extends UsersState {}

final class UsersLoading extends UsersState {}

final class UsersSuccess extends UsersState {
  final PaginatedModel<UserModel> paginatedModel;

  UsersSuccess(this.paginatedModel);
}

final class UsersEmpty extends UsersState {
  final String message;

  UsersEmpty(this.message);
}

final class UsersFail extends UsersState {
  final String error;

  UsersFail(this.error);
}

