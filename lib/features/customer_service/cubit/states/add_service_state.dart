part of '../customer_service_cubit.dart';

@immutable
class AddServiceState extends GeneralCustomerService {}

final class AddrServiceInitial extends AddServiceState {}

final class AddrServiceLoading extends AddServiceState {}

final class AddrServiceSuccess extends AddServiceState {
  final String message;

  AddrServiceSuccess(this.message);
}

final class AddrServiceFail extends AddServiceState {
  final String error;

  AddrServiceFail(this.error);
}
