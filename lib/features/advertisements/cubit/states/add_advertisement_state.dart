part of '../advertisements_cubit.dart';

@immutable
class AddAdvertisementState extends GeneralAdvertisementsState {}

class AddAdvertisementInitial extends AddAdvertisementState {}

class AddAdvertisementLoading extends AddAdvertisementState {}

class AddAdvertisementSuccess extends AddAdvertisementState {
  final String message;

  AddAdvertisementSuccess(this.message);
}

class AddAdvertisementFail extends AddAdvertisementState {
  final String error;

  AddAdvertisementFail(this.error);
}
