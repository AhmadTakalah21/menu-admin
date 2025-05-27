part of 'show_map_cubit.dart';

@immutable
sealed class ShowMapState {}

final class ShowMapInitial extends ShowMapState {}

final class ShowMapLoading extends ShowMapState {}

final class ShowMapSuccess extends ShowMapState {}

final class ShowMapFail extends ShowMapState {
  final String error;

  ShowMapFail(this.error);
}
