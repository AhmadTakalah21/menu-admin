import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:user_admin/features/profile/model/profile_model/profile_model.dart';
import 'package:user_admin/features/profile/model/update_profile_model/update_profile_model.dart';
import 'package:user_admin/features/profile/service/profile_service.dart';

part 'states/profile_state.dart';

part 'states/update_profile_state.dart';

part 'states/general_profile_state.dart';

@injectable
class ProfileCubit extends Cubit<GeneralProfileState> {
  ProfileCubit(this.profileService) : super(GeneralProfileInitial());
  final ProfileService profileService;
  UpdateProfileModel updateProfileModel = const UpdateProfileModel();

  void setName(String name) {
    updateProfileModel = updateProfileModel.copyWith(name: name);
  }

  void setUsername(String username) {
    updateProfileModel = updateProfileModel.copyWith(username: username);
  }

  void setPassword(String password) {
    updateProfileModel = updateProfileModel.copyWith(password: password);
  }

  Future<void> getProfile() async {
    emit(ProfileLoading());
    try {
      final profile = await profileService.getProfile();
      emit(ProfileSuccess(profile));
    } catch (e) {
      emit(ProfileFail(e.toString()));
    }
  }

  Future<void> updateProfile() async {
    emit(UpdateProfileLoading());
    try {
      await profileService.updateProfile(updateProfileModel);
      emit(UpdateProfileSuccess("profile_updated".tr()));
      
      setPassword("");
    } catch (e) {
      emit(UpdateProfileFail(e.toString()));
    }
  }
}
