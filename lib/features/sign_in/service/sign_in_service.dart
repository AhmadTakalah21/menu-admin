import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_admin/features/sign_in/model/change_password_model/change_password_model.dart';
import 'package:user_admin/features/sign_in/model/forget_pass_email_model/forget_pass_email_model.dart';
import 'package:user_admin/features/sign_in/model/forget_pass_quest_model/forget_pass_quest_model.dart';
import 'package:user_admin/features/sign_in/model/reset_password_model/reset_password_model.dart';
import 'package:user_admin/features/sign_in/model/sign_in_model/sign_in_model.dart';
import 'package:user_admin/features/sign_in/model/sign_in_post_model/sign_in_post_model.dart';
import 'package:user_admin/global/dio/dio_client.dart';
import 'package:user_admin/global/utils/constants.dart';

part 'sign_in_service_imp.dart';

abstract class SignInService {
  Future<SignInModel> signIn(SignInPostModel signInPostModel);
  Future<void> signOut();
  Future<void> resetViaEmail(ForgetPassEmailModel forgetPassEmailModel);
  Future<void> resetViaQuestion(ForgetPassQuestModel forgetPassQuestModel);
  Future<void> resetPassword(ResetPasswordModel resetPasswordModel);
  Future<void> verifyCode(String code);
  Future<void> changePassword(ChangePasswordModel changePasswordModel);
}
