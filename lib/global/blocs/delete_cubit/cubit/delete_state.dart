part of 'delete_cubit.dart';

@immutable
sealed class DeleteState {}

final class DeleteInitial extends DeleteState {}

final class DeleteLoading extends DeleteState {}

final class DeleteSuccess extends DeleteState {
  final String message;

  DeleteSuccess(this.message);
}

final class DeleteFail extends DeleteState {
   final String error;

  DeleteFail(this.error);
}

final class ActivateSuccess extends DeleteState {
  final String message;

  ActivateSuccess(this.message);
}

final class ActivateFail extends DeleteState {
   final String error;

  ActivateFail(this.error);
}
