part of '../app_manager_cubit.dart';

@immutable
abstract class AppManagerState {}

final class AppManagerInitial extends AppManagerState {
  final locale = SupportedLocales.arabic;
}

final class UnauthorizedState extends AppManagerState {}

final class LanguageChangedInitial extends AppManagerState {}

final class LanguageChangedState extends AppManagerState {
}

final class DeletedState<T extends DeleteModel> extends AppManagerState {
  final T item;

  DeletedState(this.item);
}
