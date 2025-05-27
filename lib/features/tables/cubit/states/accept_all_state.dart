part of '../tables_cubit.dart';

@immutable
class AcceptAllState extends GeneralTablesState {}

class AcceptAllInitial extends AcceptAllState {}

class AcceptAllLoading extends AcceptAllState {}

class AcceptAllSuccess extends AcceptAllState {
  final String message;

  AcceptAllSuccess(this.message);
}

class AcceptAllFail extends AcceptAllState {
  final String error;

  AcceptAllFail(this.error);
}
