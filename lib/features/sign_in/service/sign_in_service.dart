import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_admin/features/sign_in/model/sign_in_model/sign_in_model.dart';
import 'package:user_admin/features/sign_in/model/sign_in_post_model/sign_in_post_model.dart';
import 'package:user_admin/global/dio/dio_client.dart';

part 'sign_in_service_imp.dart';

abstract class SignInService {
  Future<SignInModel> signIn(SignInPostModel signInPostModel);

  Future<void> signOut();
}
