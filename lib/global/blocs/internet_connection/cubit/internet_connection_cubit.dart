import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'internet_connection_state.dart';

@injectable
class InternetConnectionCubit extends Cubit<InternetConnectionState> {
  InternetConnectionCubit() : super(InternetConnectionInitial());

  Future<void> checkInternetConnection() async {
    emit(CheckInternetLoading());
    try {
      final List<ConnectivityResult> result =
          await (Connectivity().checkConnectivity());
      if (result.isNotEmpty && !result.contains(ConnectivityResult.none)) {
        emit(InternetConnectedState());
      } else {
        emit(InternetDisconnectedState());
      }
    } catch (e) {
      emit(CheckInternetFail(e.toString()));
    }
  }
}
