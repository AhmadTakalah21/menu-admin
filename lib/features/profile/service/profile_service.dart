import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:user_admin/features/profile/model/profile_model/profile_model.dart';
import 'package:user_admin/features/profile/model/update_profile_model/update_profile_model.dart';
import 'package:user_admin/global/dio/dio_client.dart';

part "profile_service_imp.dart";

abstract class ProfileService {
  Future<ProfileModel> getProfile();

  Future<void> updateProfile(UpdateProfileModel updateProfileModel);
}
