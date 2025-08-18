import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_admin/features/app_manager/cubit/app_manager_cubit.dart';
import 'package:user_admin/features/sign_in/model/change_password_model/change_password_model.dart';
import 'package:user_admin/features/sign_in/model/forget_pass_email_model/forget_pass_email_model.dart';
import 'package:user_admin/features/sign_in/model/forget_pass_quest_model/forget_pass_quest_model.dart';
import 'package:user_admin/features/sign_in/model/question_model/question_model.dart';
import 'package:user_admin/features/sign_in/model/reset_password_model/reset_password_model.dart';
import 'package:user_admin/features/sign_in/model/sign_in_model/sign_in_model.dart';
import 'package:user_admin/features/sign_in/model/sign_in_post_model/sign_in_post_model.dart';
import 'package:user_admin/features/sign_in/service/sign_in_service.dart';
import 'package:user_admin/global/di/di.dart';

part 'states/sign_in_state.dart';
part 'states/text_field_state.dart';
part 'states/general_sign_in_state.dart';

part 'states/reset_password_state.dart';
part 'states/reset_via_email_state.dart';
part 'states/reset_via_question_state.dart';
part 'states/verify_code_state.dart';
part 'states/change_password_state.dart';
part 'states/set_question_state.dart';

@injectable
class SignInCubit extends Cubit<GeneralSignInState> {
  SignInCubit(this.signInService) : super(GeneralSignInInitial());
  final SignInService signInService;

  SignInPostModel signInPostModel = const SignInPostModel();

  ForgetPassEmailModel forgetPassEmailModel = const ForgetPassEmailModel();
  ForgetPassQuestModel forgetPassQuestModel = const ForgetPassQuestModel();
  ResetPasswordModel resetPasswordModel = const ResetPasswordModel();
  ChangePasswordModel changePasswordModel = const ChangePasswordModel();
  String? code;

  void setEmail(String email) {
    forgetPassEmailModel = forgetPassEmailModel.copyWith(email: email);
  }

  void setUsername(String username) {
    forgetPassQuestModel = forgetPassQuestModel.copyWith(username: username);
  }

  void setQuestion(QuestionModel? question) {
    if (question == null) {
      return;
    }
    forgetPassQuestModel = forgetPassQuestModel.copyWith(question: question.id);
    emit(SetQuestionState(question));
  }

  void setAnswer(String answer) {
    forgetPassQuestModel = forgetPassQuestModel.copyWith(answer: answer);
  }

  void setPassword(String password) {
    resetPasswordModel = resetPasswordModel.copyWith(password: password);
  }

  void setRepeatPassword(String repeatPassword) {
    resetPasswordModel =
        resetPasswordModel.copyWith(repeatPassword: repeatPassword);
  }

  void setCode(String code) {
    this.code = code;
  }

  void setCurrentPassword(String currentPassword) {
    changePasswordModel =
        changePasswordModel.copyWith(currentPassword: currentPassword);
  }

  void setNewPassword(String newPassword) {
    changePasswordModel =
        changePasswordModel.copyWith(newPassword: newPassword);
  }

  void setConfirmPassword(String confirmPassword) {
    changePasswordModel =
        changePasswordModel.copyWith(confirmPassword: confirmPassword);
  }

  void setUsernameSignIn(String username) {
    signInPostModel = signInPostModel.copyWith(username: username);
    emit(TextFieldState(TextFieldType.username));
  }

  void setPasswordSignIn(String password) {
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

  Future<void> resetViaEmail() async {
    final emailError = forgetPassEmailModel.validateEmail();
    if (emailError != null) {
      emit(ResetViaEmailFail(emailError));
      return;
    }

    emit(ResetViaEmailLoading());
    try {
      await signInService.resetViaEmail(forgetPassEmailModel);
      emit(ResetViaEmailSuccess());
    } catch (e) {
      if (e.toString().contains("the request contains bad syntax")) {
        emit(ResetViaEmailFail("Email is incorrect"));
      } else {
        emit(ResetViaEmailFail(e.toString()));
      }
    }
  }

  Future<void> resetViaQuestion() async {
    emit(ResetViaQuestionLoading());
    try {
      await signInService.resetViaQuestion(forgetPassQuestModel);
      emit(ResetViaQuestionSuccess());
    } catch (e) {
      if (e.toString().contains("the request contains bad syntax")) {
        emit(ResetViaQuestionFail("Incorrect inputs"));
      } else {
        emit(ResetViaQuestionFail(e.toString()));
      }
    }
  }

  Future<void> verifyCode() async {
    final code = this.code;
    if (code == null || code.isEmpty) {
      emit(VerifyCodeFail("Code can't be empty"));
      return;
    }

    emit(VerifyCodeLoading());
    try {
      await signInService.verifyCode(code);
      emit(VerifyCodeSuccess());
    } catch (e) {
      emit(VerifyCodeFail(e.toString()));
    }
  }

  Future<void> resetPassword() async {
    emit(ResetPasswordLoading());

    final passwordError = resetPasswordModel.verifyPassword();
    if (passwordError != null) {
      emit(ResetPasswordFail(passwordError));
      return;
    }

    try {
      await signInService.resetPassword(resetPasswordModel);
      emit(ResetPasswordSuccess());
    } catch (e) {
      emit(ResetPasswordFail(e.toString()));
    }
  }

  Future<void> changePassword() async {
    emit(ChangePasswordLoading());

    final passwordError = changePasswordModel.verifyPassword();
    if (passwordError != null) {
      emit(ChangePasswordFail(passwordError));
      return;
    }

    try {
      await signInService.changePassword(changePasswordModel);
      emit(ChangePasswordSuccess());
    } catch (e) {
      if (e.toString().contains("the request contains bad syntax")) {
        emit(ChangePasswordFail("Current password is incorrect"));
      } else {
        emit(ChangePasswordFail(e.toString()));
      }
    }
  }
}
