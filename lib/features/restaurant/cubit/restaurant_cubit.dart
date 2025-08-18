import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
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

  Color? pickerColor;
  Color? pickerBackgroundColor;

  Color _parseColor(String? colorString) {
    try {
      if (colorString == null || colorString.trim().isEmpty) {
        return Colors.black;
      }

      colorString = colorString.trim();

      if (colorString.startsWith('Color(') && colorString.contains('alpha:')) {
        final regex = RegExp(
          r'alpha:\s*([\d.]+),\s*red:\s*([\d.]+),\s*green:\s*([\d.]+),\s*blue:\s*([\d.]+)',
        );
        final match = regex.firstMatch(colorString);

        if (match != null) {
          final alpha = (double.parse(match.group(1)!) * 255).round();
          final red = (double.parse(match.group(2)!) * 255).round();
          final green = (double.parse(match.group(3)!) * 255).round();
          final blue = (double.parse(match.group(4)!) * 255).round();

          return Color.fromARGB(alpha, red, green, blue);
        }
      }

      if (colorString.startsWith('Color(0x')) {
        final hex = colorString.replaceAll('Color(', '').replaceAll(')', '');
        return Color(int.parse(hex));
      }

      String hex = colorString.replaceAll('#', '');

      if (hex.length == 6) {
        hex = 'FF$hex';
      } else if (hex.length != 8) {
        return Colors.black;
      }

      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      debugPrint('Error parsing color: $e - Input: $colorString');
      return Colors.black;
    }
  }

  String _formatColorForApi(Color color) {
    final hex = color.value.toRadixString(16).padLeft(8, '0');
    return 'Color(0x$hex)';
  }

  void setColor(String? color) {
    if (color == null || color.trim().isEmpty) return;
    final parsedColor = _parseColor(color);
    pickerColor = parsedColor;
    updateRestaurantModel = updateRestaurantModel.copyWith(
      color: _formatColorForApi(parsedColor),
    );
  }

  void setBackgroundColor(String? color) {
    if (color == null || color.trim().isEmpty) return;
    final parsedColor = _parseColor(color);
    pickerBackgroundColor = parsedColor;
    updateRestaurantModel = updateRestaurantModel.copyWith(
      backgroundColor: _formatColorForApi(parsedColor),
    );
  }

  Future<void> setCover() async {
    final picker = ImagePicker();
    cover = await picker.pickImage(source: ImageSource.gallery);
  }

  Future<void> setLogo() async {
    final picker = ImagePicker();
    logo = await picker.pickImage(source: ImageSource.gallery);
  }

  void setNameEn(String nameEn) =>
      updateRestaurantModel = updateRestaurantModel.copyWith(nameEn: nameEn);

  void setNameAr(String nameAr) =>
      updateRestaurantModel = updateRestaurantModel.copyWith(nameAr: nameAr);

  void setNameUrl(String nameUrl) =>
      updateRestaurantModel = updateRestaurantModel.copyWith(nameUrl: nameUrl);

  void setFacebookUrl(String facebookUrl) =>
      updateRestaurantModel = updateRestaurantModel.copyWith(facebookUrl: facebookUrl);

  void setInstagramUrl(String instagramUrl) =>
      updateRestaurantModel = updateRestaurantModel.copyWith(instagramUrl: instagramUrl);

  void setWhatsappPhone(String whatsappPhone) =>
      updateRestaurantModel = updateRestaurantModel.copyWith(whatsappPhone: whatsappPhone);

  void setNoteEn(String noteEn) =>
      updateRestaurantModel = updateRestaurantModel.copyWith(noteEn: noteEn);

  void setNoteAr(String noteAr) =>
      updateRestaurantModel = updateRestaurantModel.copyWith(noteAr: noteAr);

  void setMessageBad(String value) =>
      updateRestaurantModel = updateRestaurantModel.copyWith(messageBad: value);

  void setMessageGood(String value) =>
      updateRestaurantModel = updateRestaurantModel.copyWith(messageGood: value);

  void setMessagePerfect(String value) =>
      updateRestaurantModel = updateRestaurantModel.copyWith(messagePerfect: value);

  void setConsumerSpending(String value) =>
      updateRestaurantModel = updateRestaurantModel.copyWith(consumerSpending: value);

  void setLocalAdministration(String value) =>
      updateRestaurantModel = updateRestaurantModel.copyWith(localAdministration: value);

  void setReconstruction(String value) =>
      updateRestaurantModel = updateRestaurantModel.copyWith(reconstruction: value);

  void setPriceKm(String value) {
    final parsed = double.tryParse(value);
    if (parsed != null) {
      updateRestaurantModel = updateRestaurantModel.copyWith(priceKm: parsed);
    }
  }

  Future<void> getRestaurant() async {
    emit(RestaurantLoading());
    try {
      final restaurant = await restaurantService.getRestaurant();

      updateRestaurantModel = UpdateRestaurantModel(
        nameEn: restaurant.nameEn,
        nameAr: restaurant.nameAr,
        nameUrl: restaurant.nameUrl,
        facebookUrl: restaurant.facebookUrl,
        instagramUrl: restaurant.instagramUrl,
        whatsappPhone: restaurant.whatsappPhone,
        noteEn: restaurant.noteEn,
        noteAr: restaurant.noteAr,
        messageBad: restaurant.messageBad,
        messageGood: restaurant.messageGood,
        messagePerfect: restaurant.messagePerfect,
        consumerSpending: restaurant.consumerSpending.toString(),
        localAdministration: restaurant!.localAdmin.toString(),
        reconstruction: restaurant.reconstruction.toString(),
        priceKm: restaurant.priceKm,
        color: _formatColorForApi(restaurant.color!),
        backgroundColor: _formatColorForApi(restaurant.backgroundColor!),

      );

      pickerColor = restaurant.color;
      pickerBackgroundColor = restaurant.backgroundColor;

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
