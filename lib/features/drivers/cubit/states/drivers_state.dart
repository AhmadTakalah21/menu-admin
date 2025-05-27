part of '../drivers_cubit.dart';

@immutable
class DriversState extends GeneralDriversState {}

final class DriversInitial extends DriversState {}

final class DriversLoading extends DriversState {}

final class DriversSuccess extends DriversState {
  final PaginatedModel<DriverModel> drivers;

  DriversSuccess(this.drivers);
}

final class DriversEmpty extends DriversState {
  final String message;

  DriversEmpty(this.message);
}

final class DriversFail extends DriversState {
  final String error;

  DriversFail(this.error);
}
