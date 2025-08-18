import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:user_admin/features/restaurant/cubit/restaurant_cubit.dart';
import 'package:user_admin/features/tables/view/widgets/table_details_widget.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/model/role_model/role_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/app_image_widget.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_back_button.dart';
import 'package:user_admin/global/widgets/main_drawer.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';
import 'package:user_admin/global/widgets/main_text_field.dart';

abstract class RestaurantViewCallbacks {
  Future<void> onRefresh();

  void onTryAgainTap();

  void onIgnoreTap();

  void onSaveTap();

  void onNameArChanged(String nameAr);

  void onNameEnChanged(String nameEn);

  void onUrlNameChanged(String urlName);

  void onFacebookChanged(String facebook);

  void onInstagramChanged(String instagram);

  void onWhatsappChanged(String whatsapp);

  void onNoteArChanged(String noteAr);

  void onNoteEnChanged(String noteEn);

  void onMessageBadChanged(String messageBad);

  void onMessageGoodChanged(String messageGood);

  void onMessagePerfectChanged(String messagePerfect);

  void onConsumerSpendingChanged(String consumerSpending);

  void onLocalAdministrationChanged(String localAdministration);

  void onReconstructionChanged(String reconstruction);

  void onPriceKmChanged(String priceKm);

  void onColorSelected(Color color);
  void onBackgroundColorSelected(Color color);
  void onQrOfflineTap(String qrCode);
  void onQrTakeoutTap(String qrCode);
  void onSetLogo();
  void onSetCover();
}

class RestaurantView extends StatelessWidget {
  const RestaurantView({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return RestaurantPage(permissions: permissions, restaurant: restaurant);
  }
}

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  State<RestaurantPage> createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage>
    implements RestaurantViewCallbacks {
  late final RestaurantCubit restaurantCubit = context.read();

  Color? pickerColor;
  Color? pickerBackgroundColor;

  TextEditingController nameArController = TextEditingController();
  TextEditingController nameEnController = TextEditingController();
  TextEditingController nameUrlController = TextEditingController();
  TextEditingController facebookUrlController = TextEditingController();
  TextEditingController instagramUrlController = TextEditingController();
  TextEditingController whatsappPhoneController = TextEditingController();
  TextEditingController noteEnController = TextEditingController();
  TextEditingController noteArController = TextEditingController();
  TextEditingController messageBadController = TextEditingController();
  TextEditingController messageGoodController = TextEditingController();
  TextEditingController messagePerfectController = TextEditingController();
  TextEditingController consumerSpendingController = TextEditingController();
  TextEditingController localAdminController = TextEditingController();
  TextEditingController reconstructionController = TextEditingController();
  TextEditingController priceKmController = TextEditingController();

  @override
  void initState() {
    super.initState();
    restaurantCubit.getRestaurant();
    restaurantCubit.setNameAr(widget.restaurant.nameAr ?? "");
    restaurantCubit.setNameEn(widget.restaurant.nameEn ?? "");
    restaurantCubit.setNoteAr(widget.restaurant.noteAr ?? "");
    restaurantCubit.setNoteEn(widget.restaurant.noteAr ?? "");
    restaurantCubit.setNameUrl(widget.restaurant.nameUrl ?? "");
    restaurantCubit.setFacebookUrl(widget.restaurant.facebookUrl ?? "");
    restaurantCubit.setWhatsappPhone(widget.restaurant.whatsappPhone ?? "");
    restaurantCubit.setInstagramUrl(widget.restaurant.instagramUrl ?? "");
    restaurantCubit.setMessageBad(widget.restaurant.messageBad ?? "");
    restaurantCubit.setMessageGood(widget.restaurant.messageGood ?? "");
    restaurantCubit.setMessagePerfect(widget.restaurant.messagePerfect ?? "");
    restaurantCubit
        .setConsumerSpending(widget.restaurant.consumerSpending.toString());
    restaurantCubit
        .setLocalAdministration(widget.restaurant.localAdmin.toString());
    restaurantCubit
        .setReconstruction(widget.restaurant.reconstruction.toString());
    restaurantCubit.setPriceKm(widget.restaurant.priceKm.toString());

    restaurantCubit.setColor(widget.restaurant.color.toString());
    restaurantCubit
        .setBackgroundColor(widget.restaurant.backgroundColor.toString());
  }

  @override
  void onIgnoreTap() {
    Navigator.pop(context);
  }

  void changeColor(Color color) {
    setState(() {
      pickerColor = color;
    });
  }

  void changeBackgroundColor(Color color) {
    setState(() {
      pickerBackgroundColor = color;
    });
  }

  @override
  void onBackgroundColorSelected(Color color) {
    pickerBackgroundColor = color;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerBackgroundColor!,
              onColorChanged: changeBackgroundColor,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                setState(() {
                  restaurantCubit
                      .setBackgroundColor(pickerBackgroundColor.toString());
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void onColorSelected(Color color) {
    pickerColor = color;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor!,
              onColorChanged: changeColor,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                setState(() {
                  restaurantCubit.setColor(pickerColor.toString());
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void onConsumerSpendingChanged(String consumerSpending) {
    restaurantCubit.setConsumerSpending(consumerSpending);
  }

  @override
  void onFacebookChanged(String facebook) {
    restaurantCubit.setFacebookUrl(facebook);
  }

  @override
  void onInstagramChanged(String instagram) {
    restaurantCubit.setInstagramUrl(instagram);
  }

  @override
  void onLocalAdministrationChanged(String localAdministration) {
    restaurantCubit.setLocalAdministration(localAdministration);
  }

  @override
  void onMessageBadChanged(String messageBad) {
    restaurantCubit.setMessageBad(messageBad);
  }

  @override
  void onMessageGoodChanged(String messageGood) {
    restaurantCubit.setMessageGood(messageGood);
  }

  @override
  void onMessagePerfectChanged(String messagePerfect) {
    restaurantCubit.setMessagePerfect(messagePerfect);
  }

  @override
  void onNameArChanged(String nameAr) {
    restaurantCubit.setNameAr(nameAr);
  }

  @override
  void onNameEnChanged(String nameEn) {
    restaurantCubit.setNameEn(nameEn);
  }

  @override
  void onNoteArChanged(String noteAr) {
    restaurantCubit.setNoteAr(noteAr);
  }

  @override
  void onNoteEnChanged(String noteEn) {
    restaurantCubit.setNoteEn(noteEn);
  }

  @override
  void onPriceKmChanged(String priceKm) {
    restaurantCubit.setPriceKm(priceKm);
  }

  @override
  void onReconstructionChanged(String reconstruction) {
    restaurantCubit.setReconstruction(reconstruction);
  }

  @override
  void onSetCover() {
    restaurantCubit.setCover();
  }

  @override
  void onSetLogo() {
    restaurantCubit.setLogo();
  }

  @override
  void onUrlNameChanged(String urlName) {
    restaurantCubit.setNameUrl(urlName);
  }

  @override
  void onWhatsappChanged(String whatsapp) {
    restaurantCubit.setWhatsappPhone(whatsapp);
  }

  @override
  void onSaveTap() {
    restaurantCubit.updateRestaurant();
  }

  @override
  void onQrOfflineTap(String qrCode) {
    showDialog(
      context: context,
      builder: (context) {
        return TableDetailsWidget(
          qrCode: qrCode,
          title: "qr_offline".tr(),
        );
      },
    );
  }

  @override
  void onQrTakeoutTap(String qrCode) {
    showDialog(
      context: context,
      builder: (context) {
        return TableDetailsWidget(qrCode: qrCode, title: "qr_takeout".tr());
      },
    );
  }

  @override
  Future<void> onRefresh() async {
    restaurantCubit.getRestaurant();
  }

  @override
  void onTryAgainTap() {
    restaurantCubit.getRestaurant();
  }

  @override
  Widget build(BuildContext context) {
    final restColor = widget.restaurant.color;
    return Scaffold(
      appBar: AppBar(),
      drawer: MainDrawer(
        permissions: widget.permissions,
        restaurant: widget.restaurant,
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          child: Padding(
            padding: AppConstants.padding16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainBackButton(color: restColor!),
                const SizedBox(height: 20),
                Text(
                  "restaurant".tr(),
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 40),
                BlocConsumer<RestaurantCubit, GeneralRestaurantState>(
                  listener: (context, state) {
                    if (state is RestaurantSuccess) {
                      // profileCubit.setName(state.profile.name);
                      // profileCubit.setUsername(state.profile.username);
                    }
                  },
                  builder: (context, state) {
                    Widget? indicator;
                    String? coverUrl;
                    String? logoUrl;
                    String? qrOffline;
                    String? qrTakeout;
                    Color? color;
                    Color? backgroundColor;
                    if (state is RestaurantLoading) {
                      indicator = const Center(
                        child: LoadingIndicator(color: AppColors.black),
                      );
                    } else if (state is RestaurantSuccess) {
                      final restaurant = state.restaurant;

                      coverUrl = restaurant.cover;
                      logoUrl = restaurant.logo;
                      qrOffline = restaurant.qrOffline;
                      qrTakeout = restaurant.qrTakeout;
                      nameArController.text = restaurant.nameAr ?? "";
                      nameEnController.text = restaurant.nameEn ?? "";
                      nameUrlController.text = restaurant.nameUrl ?? "";
                      facebookUrlController.text = restaurant.facebookUrl ?? "";
                      instagramUrlController.text =
                          restaurant.instagramUrl ?? "";
                      whatsappPhoneController.text =
                          restaurant.whatsappPhone ?? "";
                      noteEnController.text = restaurant.noteEn ?? "";
                      noteArController.text = restaurant.noteAr ?? "";
                      messageBadController.text = restaurant.messageBad ?? "";
                      messageGoodController.text = restaurant.messageGood ?? "";
                      messagePerfectController.text =
                          restaurant.messagePerfect ?? "";
                      consumerSpendingController.text =
                          restaurant.consumerSpending.toString();
                      localAdminController.text =
                          restaurant.localAdmin.toString();
                      reconstructionController.text =
                          restaurant.reconstruction.toString();
                      priceKmController.text = restaurant.priceKm != null
                          ? restaurant.priceKm.toString()
                          : "";
                      color = restaurant.color;
                      backgroundColor = restaurant.backgroundColor;
                    }
                    return Column(
                      children: [
                        if (indicator != null) indicator,
                        if (indicator != null) const SizedBox(height: 20),
                        Stack(
                          children: [
                            if (coverUrl != null)
                              InkWell(
                                onTap: onSetCover,
                                child: AppImageWidget(
                                  url: coverUrl,
                                  borderRadius: AppConstants.borderRadius20,
                                ),
                              ),
                            if (logoUrl != null)
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 220, left: 50),
                                child: InkWell(
                                  onTap: onSetLogo,
                                  child: AppImageWidget(
                                    width: 100,
                                    height: 100,
                                    url: logoUrl,
                                    shadows: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 4,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                    borderRadius:
                                        AppConstants.borderRadiusCircle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              children: [
                                Text("offline".tr()),
                                const SizedBox(height: 5),
                                InkWell(
                                  onTap: () => onQrOfflineTap(qrOffline ?? ""),
                                  child: const Icon(Icons.qr_code, size: 40),
                                ),
                              ],
                            ),
                            const SizedBox(width: 40),
                            Column(
                              children: [
                                Text("takeout".tr()),
                                const SizedBox(height: 5),
                                InkWell(
                                  onTap: () => onQrTakeoutTap(qrTakeout ?? ""),
                                  child: const Icon(Icons.qr_code, size: 40),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        MainTextField(
                          controller: nameArController,
                          onChanged: onNameArChanged,
                          labelText: "name_ar".tr(),
                        ),
                        const SizedBox(height: 20),
                        MainTextField(
                          controller: nameEnController,
                          onChanged: onNameEnChanged,
                          labelText: "name_en".tr(),
                        ),
                        const SizedBox(height: 20),
                        MainTextField(
                          controller: nameUrlController,
                          onChanged: onUrlNameChanged,
                          labelText: "url_name".tr(),
                        ),
                        const SizedBox(height: 20),
                        MainTextField(
                          controller: facebookUrlController,
                          onChanged: onFacebookChanged,
                          labelText: "facebook".tr(),
                        ),
                        const SizedBox(height: 20),
                        MainTextField(
                          controller: instagramUrlController,
                          onChanged: onInstagramChanged,
                          labelText: "instagram".tr(),
                        ),
                        const SizedBox(height: 20),
                        MainTextField(
                          controller: whatsappPhoneController,
                          onChanged: onWhatsappChanged,
                          labelText: "whatsapp".tr(),
                        ),
                        const SizedBox(height: 20),
                        MainTextField(
                          controller: noteArController,
                          onChanged: onNoteArChanged,
                          labelText: "note_ar".tr(),
                        ),
                        const SizedBox(height: 20),
                        MainTextField(
                          controller: noteEnController,
                          onChanged: onNoteEnChanged,
                          labelText: "note_en".tr(),
                        ),
                        const SizedBox(height: 20),
                        MainTextField(
                          controller: messageBadController,
                          onChanged: onMessageBadChanged,
                          labelText: "message_bad".tr(),
                        ),
                        const SizedBox(height: 20),
                        MainTextField(
                          controller: messageGoodController,
                          onChanged: onMessageGoodChanged,
                          labelText: "message_good".tr(),
                        ),
                        const SizedBox(height: 20),
                        MainTextField(
                          controller: messagePerfectController,
                          onChanged: onMessagePerfectChanged,
                          labelText: "message_perfect".tr(),
                        ),
                        const SizedBox(height: 20),
                        MainTextField(
                          controller: consumerSpendingController,
                          onChanged: onConsumerSpendingChanged,
                          labelText: "consumer_spending".tr(),
                        ),
                        const SizedBox(height: 20),
                        MainTextField(
                          controller: localAdminController,
                          onChanged: onLocalAdministrationChanged,
                          labelText: "local_administration".tr(),
                        ),
                        const SizedBox(height: 20),
                        MainTextField(
                          controller: reconstructionController,
                          onChanged: onReconstructionChanged,
                          labelText: "reconstruction".tr(),
                        ),
                        const SizedBox(height: 20),
                        MainTextField(
                          controller: priceKmController,
                          onChanged: onPriceKmChanged,
                          labelText: "price_km".tr(),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: AppConstants.paddingH8,
                                    child: Text(
                                      "color".tr(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: MainActionButton(
                                          onPressed: () => onColorSelected(
                                            pickerColor ??
                                                color ??
                                                AppColors.black,
                                          ),
                                          text: "",
                                          buttonColor: pickerColor ??
                                              color ??
                                              widget.restaurant.color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: AppConstants.paddingH8,
                                    child: Text(
                                      "background_color".tr(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: MainActionButton(
                                          onPressed: () =>
                                              onBackgroundColorSelected(
                                            pickerBackgroundColor ??
                                                backgroundColor ??
                                                AppColors.black,
                                          ),
                                          text: "",
                                          buttonColor: pickerBackgroundColor ??
                                              backgroundColor ??
                                              widget.restaurant.backgroundColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MainActionButton(
                      padding: AppConstants.padding14,
                      onPressed: onIgnoreTap,
                      borderRadius: AppConstants.borderRadius5,
                      buttonColor: AppColors.blueShade3,
                      text: "ignore".tr(),
                      shadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    BlocConsumer<RestaurantCubit, GeneralRestaurantState>(
                      listener: (context, state) {
                        if (state is UpdateRestaurantSuccess) {
                          restaurantCubit.getRestaurant();
                          MainSnackBar.showSuccessMessage(
                              context, state.message);
                        } else if (state is UpdateRestaurantFail) {
                          MainSnackBar.showErrorMessage(context, state.error);
                        }
                      },
                      builder: (context, state) {
                        var onTap = onSaveTap;
                        Widget? child;
                        if (state is UpdateRestaurantLoading) {
                          onTap = () {};
                          child = const LoadingIndicator(size: 20);
                        }
                        return MainActionButton(
                          padding: AppConstants.padding14,
                          onPressed: onTap,
                          borderRadius: AppConstants.borderRadius5,
                          buttonColor: AppColors.blueShade3,
                          text: "save".tr(),
                          shadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          child: child,
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
