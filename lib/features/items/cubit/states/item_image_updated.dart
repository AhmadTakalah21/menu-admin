part of '../items_cubit.dart';

@immutable
abstract class ItemImageState extends GeneralItemsState {}

class ItemImageInitial extends ItemImageState {}

class ItemImageLoading extends ItemImageState {}

class ItemImageUpdated extends ItemImageState {
  final XFile? selectedImage;
  final XFile? selectedImage2;
  final Map<int, XFile?>? extraImages;
  final Map<int, XFile?>? sizeImages;

  ItemImageUpdated({
    this.selectedImage,
    this.selectedImage2,
    this.extraImages,
    this.sizeImages,
  });
}



class ItemImageError extends ItemImageState {
  final String error;

  ItemImageError(this.error);
}