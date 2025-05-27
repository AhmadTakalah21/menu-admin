part of '../home_cubit.dart';


@immutable
abstract class ImageState extends GeneralHomeState {}

class ImageInitial extends ImageState {}

class ImageLoading extends ImageState {}

class ImageUpdated extends ImageState {
  final XFile image;

   ImageUpdated(this.image);
}

class ImageError extends ImageState {
  final String error;

   ImageError(this.error);
}