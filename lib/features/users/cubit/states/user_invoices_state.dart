part of '../users_cubit.dart';

@immutable
class UserInvoicesState extends GeneralUsersState {}

final class UserInvoicesInitial extends UserInvoicesState {}

final class UserInvoicesLoading extends UserInvoicesState {}

final class UserInvoicesSuccess extends UserInvoicesState {
  final PaginatedModel<DrvierInvoiceModel> paginatedModel;

  UserInvoicesSuccess(this.paginatedModel);
}

final class UserInvoicesEmpty extends UserInvoicesState {
  final String message;

  UserInvoicesEmpty(this.message);
}

final class UserInvoicesFail extends UserInvoicesState {
  final String error;

  UserInvoicesFail(this.error);
}

