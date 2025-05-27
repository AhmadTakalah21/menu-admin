part of '../invoices_cubit.dart';

@immutable
class WaitersState extends GeneralInvoicesState {}

final class WaitersInitial extends WaitersState {}

final class WaitersLoading extends WaitersState {}

final class WaitersSuccess extends WaitersState {
  final List<AdminModel> waiters;

  WaitersSuccess(this.waiters);
}

final class WaitersEmpty extends WaitersState {
  final String message;

  WaitersEmpty(this.message);
}

final class WaitersFail extends WaitersState {
  final String error;

  WaitersFail(this.error);
}
