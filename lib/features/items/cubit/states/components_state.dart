part of '../items_cubit.dart';


@immutable
class ComponentsState extends GeneralItemsState{}

class ComponentsInitial extends ComponentsState {}

class ComponentsLoading extends ComponentsState {}

class ComponentsSuccess extends ComponentsState {
  final List<AddComponentItemModel> components;

  ComponentsSuccess(this.components);
}

class  ComponentsFail extends ComponentsState {
  final String error;

  ComponentsFail(this.error);
}

