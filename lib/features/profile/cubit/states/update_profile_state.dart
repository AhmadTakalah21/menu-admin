part of '../profile_cubit.dart';

@immutable
class UpdateProfileState extends GeneralProfileState{}

final class UpdateProfileInitial extends UpdateProfileState {}

final class UpdateProfileLoading extends UpdateProfileState {}

final class UpdateProfileSuccess extends UpdateProfileState {
  final String message;

  UpdateProfileSuccess(this.message);
}

final class UpdateProfileFail extends UpdateProfileState {
  final String error;

  UpdateProfileFail(this.error);
}
