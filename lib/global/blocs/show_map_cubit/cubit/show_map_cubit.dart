import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'show_map_state.dart';

@injectable
class ShowMapCubit extends Cubit<ShowMapState> {
  ShowMapCubit() : super(ShowMapInitial());

  Future<void> showMap() async {
    emit(ShowMapLoading());
    try {
      emit(ShowMapSuccess());
    } catch (e) {
      emit(ShowMapFail(e.toString()));
    }
  }
}
