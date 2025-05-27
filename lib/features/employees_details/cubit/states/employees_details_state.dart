part of '../employees_details_cubit.dart';

@immutable
class EmployeesDetailsState extends GeneralEmployeesDetailsState {}

final class EmployeesDetailsInitial extends EmployeesDetailsState {}

final class EmployeesDetailsLoading extends EmployeesDetailsState {}

final class EmployeesDetailsSuccess extends EmployeesDetailsState {
  final PaginatedModel<OrderRequestModel> paginatedModel;

  EmployeesDetailsSuccess(this.paginatedModel);
}

final class EmployeesDetailsEmpty extends EmployeesDetailsState {
  final String message;

  EmployeesDetailsEmpty(this.message);
}

final class EmployeesDetailsFail extends EmployeesDetailsState {
  final String error;

  EmployeesDetailsFail(this.error);
}
