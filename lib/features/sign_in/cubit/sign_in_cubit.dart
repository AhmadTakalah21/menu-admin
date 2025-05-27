import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_admin/features/app_manager/cubit/app_manager_cubit.dart';
import 'package:user_admin/features/sign_in/model/sign_in_model/sign_in_model.dart';
import 'package:user_admin/features/sign_in/model/sign_in_post_model/sign_in_post_model.dart';
import 'package:user_admin/features/sign_in/service/sign_in_service.dart';
import 'package:user_admin/global/di/di.dart';

part 'states/sign_in_state.dart';

part 'states/text_field_state.dart';

part 'states/general_sign_in_state.dart';

@injectable
class SignInCubit extends Cubit<GeneralSignInState> {
  SignInCubit(this.signInService) : super(GeneralSignInInitial());
  final SignInService signInService;

  SignInPostModel signInPostModel = const SignInPostModel();

  void setUserName(String username) {
    signInPostModel = signInPostModel.copyWith(username: username);
    emit(TextFieldState(TextFieldType.username));
  }

  void setPassword(String password) {
    signInPostModel = signInPostModel.copyWith(password: password);
    emit(TextFieldState(TextFieldType.password));
  }

  Future<void> signIn() async {
    final prefs = await SharedPreferences.getInstance();
    final fcmToken = prefs.getString("fcm_token");
    signInPostModel = signInPostModel.copyWith(fcmToken: fcmToken);

    bool shouldReturn = false;

    String? userNameError = signInPostModel.validateUserName();
    if (userNameError != null) {
      emit(TextFieldState(TextFieldType.username, error: userNameError));
      shouldReturn = true;
    } else {
      emit(TextFieldState(TextFieldType.username));
    }

    String? passwordError = signInPostModel.validatePassword();
    if (passwordError != null) {
      emit(TextFieldState(TextFieldType.password, error: passwordError));
      shouldReturn = true;
    } else {
      emit(TextFieldState(TextFieldType.password));
    }

    if (shouldReturn) return;

    emit(SignInLoading());
    try {
      final user = await signInService.signIn(signInPostModel);
      emit(SignInSuccess(user));
      prefs.setString("admin_data", user.toString());
      prefs.setBool("is_login", true);
    } catch (e) {
      if (e.toString().contains("the request contains bad syntax")) {
        emit(SignInFail("username_password_incorrect".tr()));
      } else {
        emit(SignInFail(e.toString()));
      }
    }
  }

  Future<void> signOut() async {
    emit(SignInLoading());

    try {
      await signInService.signOut();
      emit(SignOutSuccess("Logout Successfully"));
      get<AppManagerCubit>().emitUnauthorizedState();
    } catch (e) {
      emit(SignInFail(e.toString()));
    }
  }
}
