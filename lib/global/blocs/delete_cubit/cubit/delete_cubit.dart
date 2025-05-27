import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:user_admin/features/home/model/category_model/category_model.dart';
import 'package:user_admin/global/services/delete_service/delete_service.dart';
import 'package:user_admin/global/widgets/insure_delete_widget.dart';

part 'delete_state.dart';

@injectable
class DeleteCubit extends Cubit<DeleteState> {
  DeleteCubit(this.deleteService) : super(DeleteInitial());
  final DeleteService deleteService;

  Future<void> deleteItem<T extends DeleteModel>(T item) async {
    emit(DeleteLoading());
    try {
      await deleteService.deleteItem(item);
      emit(DeleteSuccess("item_delete_success".tr()));
    } catch (e) {
      if (item is CategoryModel &&
          e.toString().contains("the request contains bad syntax")) {
        emit(DeleteFail("deactivate_first".tr()));
      } else {
        emit(DeleteFail(e.toString()));
      }
    }
  }

  Future<void> deactivateItem<T extends DeleteModel>(T item) async {
    emit(DeleteLoading());
    try {
      await deleteService.deactivateItem(item);
      final message = item.isActive
          ? "item_deactivate_success".tr()
          : "item_activate_success".tr();
      emit(ActivateSuccess(message));
    } catch (e) {
      emit(ActivateFail(e.toString()));
    }
  }
}
