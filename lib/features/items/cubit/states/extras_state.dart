part of '../items_cubit.dart';

@immutable
 class ExtrasState extends GeneralItemsState{}

class ExtrasInitial extends ExtrasState {}

class ExtrasLoading extends ExtrasState {}

class ExtrasSuccess extends ExtrasState {
  final List<AddExtraItemModel> extras;

  ExtrasSuccess(this.extras);
}

class ExtrasFail extends ExtrasState {
  final String error;

  ExtrasFail(this.error);
}

