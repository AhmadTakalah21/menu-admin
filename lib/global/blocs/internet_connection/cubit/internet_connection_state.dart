part of 'internet_connection_cubit.dart';

@immutable
sealed class InternetConnectionState {}

final class InternetConnectionInitial extends InternetConnectionState {}

final class CheckInternetState extends InternetConnectionState {}

final class CheckInternetLoading extends InternetConnectionState {}

final class InternetConnectedState extends InternetConnectionState {}

final class InternetDisconnectedState extends InternetConnectionState {}

final class CheckInternetFail extends InternetConnectionState {
  final String error;

  CheckInternetFail(this.error);
}
