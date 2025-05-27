part of '../advertisements_cubit.dart';

@immutable
class AdvertisementsState extends GeneralAdvertisementsState {}

class AdvertisementsInitial extends AdvertisementsState {}

class AdvertisementsLoading extends AdvertisementsState {}

class AdvertisementsSuccess extends AdvertisementsState {
  final List<AdvertisementModel> advertisements;

  AdvertisementsSuccess(this.advertisements);
}

class AdvertisementsEmpty extends AdvertisementsState {
  final String message;

  AdvertisementsEmpty(this.message);
}

class AdvertisementsFail extends AdvertisementsState {
  final String error;

  AdvertisementsFail(this.error);
}
