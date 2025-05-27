part of '../items_cubit.dart';

@immutable
class EditItemState extends GeneralItemsState {}

class EditItemInitial extends EditItemState {}

class EditItemLoading extends EditItemState {}

class EditItemSuccess extends EditItemState {
  final ItemModel items;
  final String message;

  EditItemSuccess(this.items, this.message);
}

class EditItemFail extends EditItemState {
  final String error;

  EditItemFail(this.error);
}
