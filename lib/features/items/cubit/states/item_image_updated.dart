part of '../items_cubit.dart';

@immutable
abstract class ItemImageState extends GeneralItemsState {}

class ItemImageInitial extends ItemImageState {}

class ItemImageLoading extends ItemImageState {}

class ItemImageUpdated extends ItemImageState {
  final XFile? selectedImage;
  final XFile? selectedImage2;

  ItemImageUpdated({
    this.selectedImage,
    this.selectedImage2,
  });
}


class ItemImageError extends ItemImageState {
  final String error;

  ItemImageError(this.error);
}