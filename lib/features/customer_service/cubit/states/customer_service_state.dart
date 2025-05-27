part of '../customer_service_cubit.dart';

@immutable
class CustomerServiceState extends GeneralCustomerService {}

final class CustomerServiceInitial extends CustomerServiceState {}

final class CustomerServiceLoading extends CustomerServiceState {}

final class CustomerServiceSuccess extends CustomerServiceState {
  final PaginatedModel<ServiceModel> services;

  CustomerServiceSuccess(this.services);
}

final class CustomerServiceEmpty extends CustomerServiceState {
  final String message;

  CustomerServiceEmpty(this.message);
}

final class CustomerServiceFail extends CustomerServiceState {
  final String error;

  CustomerServiceFail(this.error);
}
