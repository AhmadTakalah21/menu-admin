import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_admin/features/advertisements/model/add_advertisement_model/add_advertisement_model.dart';
import 'package:user_admin/features/advertisements/model/advertisement_model/advertisement_model.dart';
import 'package:user_admin/features/advertisements/service/advertisements_service.dart';
import 'package:user_admin/features/items/model/is_panorama_enum.dart';

part 'states/advertisements_state.dart';

part 'states/add_advertisement_state.dart';

part 'states/general_advertisements_state.dart';

@injectable
class AdvertisementsCubit extends Cubit<GeneralAdvertisementsState> {
  AdvertisementsCubit(this.advertisementsService)
      : super(GeneralAdvertisementsInitial());

  final AdvertisementsService advertisementsService;
  AddAdvertisementModel addAdvertisementModel = const AddAdvertisementModel();
  XFile? image;

  void setName(String? name) {
    addAdvertisementModel = addAdvertisementModel.copyWith(title: name);
  }

  void setFromDate(String? fromDate) {
    addAdvertisementModel = addAdvertisementModel.copyWith(
      fromDate: fromDate,
    );
  }

  void setToDate(String? toDate) {
    addAdvertisementModel = addAdvertisementModel.copyWith(
      toDate: toDate,
    );
  }

  void setIsPanorama(IsPanoramaEnum? isPanorama) {
    addAdvertisementModel = addAdvertisementModel.copyWith(
      isPanorama: isPanorama?.id,
    );
  }

  void setHideDate(IsPanoramaEnum? hideDate) {
    addAdvertisementModel = addAdvertisementModel.copyWith(
      hideDate: hideDate?.id,
    );
  }

  Future<void> setImage() async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    this.image = image;
  }

  void setId(int id) {
    addAdvertisementModel = addAdvertisementModel.copyWith(id: id);
  }

  Future<void> getAdvertisements({required bool isRefresh}) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList("advertisements");

    if (data != null && !isRefresh) {
      List<AdvertisementModel> adverts;
      adverts = List.generate(
        data.length,
        (index) => AdvertisementModel.fromString(data[index]),
      );
      if (adverts.isEmpty) {
        emit(AdvertisementsEmpty("There is no advertisements"));
      } else {
        emit(AdvertisementsSuccess(adverts));
      }
      return;
    } else {
      emit(AdvertisementsLoading());
      try {
        final advertisements = await advertisementsService.getAdvertisements();

        List<String> advertisementsString;
        advertisementsString = List.generate(
          advertisements.length,
          (index) => advertisements[index].toString(),
        );
        prefs.setStringList("advertisements", advertisementsString);

        if (advertisements.isEmpty) {
          emit(AdvertisementsEmpty("There is no advertisements"));
        } else {
          emit(AdvertisementsSuccess(advertisements));
        }
      } catch (e) {
        emit(AdvertisementsFail(e.toString()));
      }
    }
  }

  Future<void> addAdvertisement({
    required bool isEdit,
    int? advertisementId,
  }) async {
    final image = this.image;
    if (advertisementId != null && isEdit) {
      setId(advertisementId);
    }
    if (image == null && !isEdit) {
      emit(AddAdvertisementFail("image_required".tr()));
      return;
    }
    emit(AddAdvertisementLoading());
    try {
      await advertisementsService.addAdvertisement(
        addAdvertisementModel,
        image: image,
        isEdit: isEdit,
      );

      final successMessage =
          isEdit ? "edit_adv_success".tr() : "add_adv_success".tr();
      emit(AddAdvertisementSuccess(successMessage));

    } catch (e) {
      emit(AddAdvertisementFail(e.toString()));
    }
  }
}
