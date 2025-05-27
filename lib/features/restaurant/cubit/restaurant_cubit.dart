import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:user_admin/features/restaurant/model/update_restaurant_model/update_restaurant_model.dart';
import 'package:user_admin/features/restaurant/service/restaurant_service.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';

part 'states/restaurant_state.dart';

part 'states/update_restaurant_state.dart';

part 'states/general_restaurant_state.dart';

@injectable
class RestaurantCubit extends Cubit<GeneralRestaurantState> {
  RestaurantCubit(this.restaurantService) : super(GeneralRestaurantInitail());
  final RestaurantService restaurantService;
  UpdateRestaurantModel updateRestaurantModel = const UpdateRestaurantModel();
  XFile? cover;
  XFile? logo;

  Future<void> setCover() async {
    final ImagePicker picker = ImagePicker();
    final cover = await picker.pickImage(source: ImageSource.gallery);
    this.cover = cover;
  }

  Future<void> setLogo() async {
    final ImagePicker picker = ImagePicker();
    final logo = await picker.pickImage(source: ImageSource.gallery);
    this.logo = logo;
  }

  void setNameEn(String nameEn) {
    updateRestaurantModel = updateRestaurantModel.copyWith(nameEn: nameEn);
  }

  void setNameAr(String nameAr) {
    updateRestaurantModel = updateRestaurantModel.copyWith(nameAr: nameAr);
  }

  void setNameUrl(String nameUrl) {
    updateRestaurantModel = updateRestaurantModel.copyWith(nameUrl: nameUrl);
  }

  void setFacebookUrl(String facebookUrl) {
    updateRestaurantModel =
        updateRestaurantModel.copyWith(facebookUrl: facebookUrl);
  }

  void setInstagramUrl(String instagramUrl) {
    updateRestaurantModel =
        updateRestaurantModel.copyWith(instagramUrl: instagramUrl);
  }

  void setWhatsappPhone(String whatsappPhone) {
    updateRestaurantModel =
        updateRestaurantModel.copyWith(whatsappPhone: whatsappPhone);
  }

  void setNoteEn(String noteEn) {
    updateRestaurantModel = updateRestaurantModel.copyWith(noteEn: noteEn);
  }

  void setNoteAr(String noteAr) {
    updateRestaurantModel = updateRestaurantModel.copyWith(noteAr: noteAr);
  }

  void setMessageBad(String messageBad) {
    updateRestaurantModel =
        updateRestaurantModel.copyWith(messageBad: messageBad);
  }

  void setMessageGood(String messageGood) {
    updateRestaurantModel =
        updateRestaurantModel.copyWith(messageGood: messageGood);
  }

  void setMessagePerfect(String messagePerfect) {
    updateRestaurantModel =
        updateRestaurantModel.copyWith(messagePerfect: messagePerfect);
  }

  void setConsumerSpending(String consumerSpending) {
    updateRestaurantModel =
        updateRestaurantModel.copyWith(consumerSpending: consumerSpending);
  }

  void setLocalAdministration(String localAdministration) {
    updateRestaurantModel = updateRestaurantModel.copyWith(
        localAdministration: localAdministration);
  }

  void setReconstruction(String reconstruction) {
    updateRestaurantModel =
        updateRestaurantModel.copyWith(reconstruction: reconstruction);
  }

  void setPriceKm(String priceKm) {
    updateRestaurantModel = updateRestaurantModel.copyWith(priceKm: priceKm);
  }

  void setBackgroundColor(String backgroundColor) {
    updateRestaurantModel =
        updateRestaurantModel.copyWith(backgroundColor: backgroundColor);
  }

  void setColor(String color) {
    updateRestaurantModel = updateRestaurantModel.copyWith(color: color);
  }

  Future<void> getRestaurant() async {
    emit(RestaurantLoading());
    try {
      final restaurant = await restaurantService.getRestaurant();
      emit(RestaurantSuccess(restaurant));
    } catch (e) {
      emit(RestaurantFail(e.toString()));
    }
  }

  Future<void> updateRestaurant() async {
    emit(UpdateRestaurantLoading());
    try {
      await restaurantService.updateRestaurant(
        updateRestaurantModel,
        cover: cover,
        logo: logo,
      );
      emit(UpdateRestaurantSuccess("restaurant_updated".tr()));
    } catch (e) {
      emit(UpdateRestaurantFail(e.toString()));
    }
  }
}
