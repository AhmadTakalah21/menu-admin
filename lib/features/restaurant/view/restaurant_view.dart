import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
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

import '../../../global/widgets/main_app_bar.dart';

/// —————————————————————————————————————————————————
/// Callbacks كما هي
/// —————————————————————————————————————————————————
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

/// تبويب الواجهة
enum _Section { basic, extra }

class _RestaurantPageState extends State<RestaurantPage>
    implements RestaurantViewCallbacks {
  late final RestaurantCubit restaurantCubit = context.read();

  Color? pickerColor;
  Color? pickerBackgroundColor;

  final nameArController = TextEditingController();
  final nameEnController = TextEditingController();
  final nameUrlController = TextEditingController();
  final facebookUrlController = TextEditingController();
  final instagramUrlController = TextEditingController();
  final whatsappPhoneController = TextEditingController();
  final noteEnController = TextEditingController();
  final noteArController = TextEditingController();
  final messageBadController = TextEditingController();
  final messageGoodController = TextEditingController();
  final messagePerfectController = TextEditingController();
  final consumerSpendingController = TextEditingController();
  final localAdminController = TextEditingController();
  final reconstructionController = TextEditingController();
  final priceKmController = TextEditingController();

  _Section _section = _Section.basic;

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
    restaurantCubit.setConsumerSpending(widget.restaurant.consumerSpending.toString());
    restaurantCubit.setLocalAdministration(widget.restaurant.localAdmin.toString());
    restaurantCubit.setReconstruction(widget.restaurant.reconstruction.toString());
    restaurantCubit.setPriceKm(widget.restaurant.priceKm.toString());
    restaurantCubit.setColor(widget.restaurant.color.toString());
    restaurantCubit.setBackgroundColor(widget.restaurant.backgroundColor.toString());
  }

  // ——————— Callbacks (بدون تغيير المنطق) ———————
  @override
  void onIgnoreTap() => Navigator.pop(context);

  void changeColor(Color color) => setState(() => pickerColor = color);
  void changeBackgroundColor(Color color) => setState(() => pickerBackgroundColor = color);

  @override
  void onBackgroundColorSelected(Color color) {
    pickerBackgroundColor = color;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(pickerColor: pickerBackgroundColor!, onColorChanged: changeBackgroundColor),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() => restaurantCubit.setBackgroundColor(pickerBackgroundColor.toString()));
              Navigator.pop(context);
            },
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  void onColorSelected(Color color) {
    pickerColor = color;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(pickerColor: pickerColor!, onColorChanged: changeColor),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() => restaurantCubit.setColor(pickerColor.toString()));
              Navigator.pop(context);
            },
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  void onConsumerSpendingChanged(String v) => restaurantCubit.setConsumerSpending(v);
  @override
  void onFacebookChanged(String v) => restaurantCubit.setFacebookUrl(v);
  @override
  void onInstagramChanged(String v) => restaurantCubit.setInstagramUrl(v);
  @override
  void onLocalAdministrationChanged(String v) => restaurantCubit.setLocalAdministration(v);
  @override
  void onMessageBadChanged(String v) => restaurantCubit.setMessageBad(v);
  @override
  void onMessageGoodChanged(String v) => restaurantCubit.setMessageGood(v);
  @override
  void onMessagePerfectChanged(String v) => restaurantCubit.setMessagePerfect(v);
  @override
  void onNameArChanged(String v) => restaurantCubit.setNameAr(v);
  @override
  void onNameEnChanged(String v) => restaurantCubit.setNameEn(v);
  @override
  void onNoteArChanged(String v) => restaurantCubit.setNoteAr(v);
  @override
  void onNoteEnChanged(String v) => restaurantCubit.setNoteEn(v);
  @override
  void onPriceKmChanged(String v) => restaurantCubit.setPriceKm(v);
  @override
  void onReconstructionChanged(String v) => restaurantCubit.setReconstruction(v);
  @override
  void onSetCover() => restaurantCubit.setCover();
  @override
  void onSetLogo() => restaurantCubit.setLogo();
  @override
  void onUrlNameChanged(String v) => restaurantCubit.setNameUrl(v);
  @override
  void onWhatsappChanged(String v) => restaurantCubit.setWhatsappPhone(v);
  @override
  void onSaveTap() => restaurantCubit.updateRestaurant();
  @override
  void onQrOfflineTap(String qr) => showDialog(context: context, builder: (_) => TableDetailsWidget(qrCode: qr, title: "qr_offline".tr()));
  @override
  void onQrTakeoutTap(String qr) => showDialog(context: context, builder: (_) => TableDetailsWidget(qrCode: qr, title: "qr_takeout".tr()));
  @override
  Future<void> onRefresh() async => restaurantCubit.getRestaurant();
  @override
  void onTryAgainTap() => restaurantCubit.getRestaurant();

  // ——————— UI Helpers ———————

  Widget _segmentedTabs(Color brand) {
    final isBasic = _section == _Section.basic;

    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.85),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 12, offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: () => setState(() => _section = _Section.extra),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: !isBasic ? const Color(0xFFEAD25D) : Colors.transparent,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Text(
                  "extra_details".tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    fontSize: 14.5,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: () => setState(() => _section = _Section.basic),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isBasic ? const Color(0xFFEAD25D) : Colors.transparent,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Text(
                  "basic_info".tr(),
                  style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black87, fontSize: 14.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerCard({
    required String? coverUrl,
    required String? logoUrl,
    required VoidCallback onCoverTap,
    required VoidCallback onLogoTap,
    required Color brand,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: onCoverTap,
          child: Container(
            height: 190,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(18),
              image: coverUrl == null
                  ? null
                  : DecorationImage(image: NetworkImage(coverUrl), fit: BoxFit.cover),
            ),
          ),
        ),

        Positioned(
          left: 10,
          bottom: -18,
          child: _colorButton(
            onTap: () => onBackgroundColorSelected(
              pickerBackgroundColor ?? widget.restaurant.backgroundColor ?? AppColors.black,
            ),
          ),
        ),

        Positioned(
          right: 10,
          bottom: -18,
          child: _colorButton(
            onTap: () => onColorSelected(
              pickerColor ?? widget.restaurant.color ?? AppColors.black,
            ),
          ),
        ),

        Positioned(
          bottom: -45,
          left: 0,
          right: 0,
          child: Center(
            child: InkWell(
              onTap: onLogoTap,
              borderRadius: BorderRadius.circular(70),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(.25), blurRadius: 10, offset: const Offset(0, 6))],
                  image: logoUrl == null ? null : DecorationImage(image: NetworkImage(logoUrl), fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _colorButton({required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(.18), blurRadius: 12, offset: const Offset(0, 6))],
            gradient: const SweepGradient(colors: [
              Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.cyan, Colors.blue, Colors.purple, Colors.red
            ]),
          ),
          child: const Icon(Icons.color_lens, color: Colors.white, size: 18),
        ),
      ),
    );
  }

  Widget _roundedField({
    required String hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    TextInputType? type,
  }) {
    return Container(
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: type,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            hintText: hint,
          ),
        ),
      ),
    );
  }

  Widget _basicSection({
    required String? welcomeLabel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 36.0, bottom: 8),
          child: Text(
            welcomeLabel ?? 'Welcome Massage',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
        ),
        _roundedField(hint: "facebook_link".tr(), controller: facebookUrlController, onChanged: onFacebookChanged),
        const SizedBox(height: 10),
        _roundedField(hint: "instagram_link".tr(), controller: instagramUrlController, onChanged: onInstagramChanged),
        const SizedBox(height: 10),
        _roundedField(hint: "whatsapp_number".tr(), controller: whatsappPhoneController, onChanged: onWhatsappChanged),
        const SizedBox(height: 14),

        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFBFD166),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
          child: Column(
            children: [
              _roundedField(hint: "الاسم باللغة الأساسية", controller: nameArController, onChanged: onNameArChanged),
              const SizedBox(height: 10),
              _roundedField(hint: "الاسم باللغة الثانوية", controller: nameEnController, onChanged: onNameEnChanged),
              const SizedBox(height: 10),
              _roundedField(hint: "اسم الرابط", controller: nameUrlController, onChanged: onUrlNameChanged),
            ],
          ),
        ),
      ],
    );
  }

  Widget _extraSection(Color brand, String? qrOffline, String? qrTakeout, Color? color, Color? bg) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 32.0, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text("offline".tr()),
                  const SizedBox(height: 6),
                  InkWell(onTap: () => onQrOfflineTap(qrOffline ?? ''), child: const Icon(Icons.qr_code, size: 40)),
                ],
              ),
              Column(
                children: [
                  Text("takeout".tr()),
                  const SizedBox(height: 6),
                  InkWell(onTap: () => onQrTakeoutTap(qrTakeout ?? ''), child: const Icon(Icons.qr_code, size: 40)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        _roundedField(hint: "consumer_spending".tr(), controller: consumerSpendingController, onChanged: onConsumerSpendingChanged, type: TextInputType.number),
        const SizedBox(height: 10),
        _roundedField(hint: "local_administration".tr(), controller: localAdminController, onChanged: onLocalAdministrationChanged, type: TextInputType.number),
        const SizedBox(height: 10),
        _roundedField(hint: "reconstruction".tr(), controller: reconstructionController, onChanged: onReconstructionChanged, type: TextInputType.number),
        const SizedBox(height: 10),
        _roundedField(hint: "price_km".tr(), controller: priceKmController, onChanged: onPriceKmChanged, type: TextInputType.number),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: AppConstants.paddingH8,
                    child: Text("color".tr(), style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 6),
                  MainActionButton(
                    onPressed: () => onColorSelected(pickerColor ?? color ?? AppColors.black),
                    text: "",
                    buttonColor: pickerColor ?? color ?? widget.restaurant.color,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: AppConstants.paddingH8,
                    child: Text("background_color".tr(), style: const TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 6),
                  MainActionButton(
                    onPressed: () => onBackgroundColorSelected(pickerBackgroundColor ?? bg ?? AppColors.black),
                    text: "",
                    buttonColor: pickerBackgroundColor ?? bg ?? widget.restaurant.backgroundColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final restColor = widget.restaurant.color ?? AppColors.mainColor;

    return Scaffold(
      appBar: MainAppBar(restaurant: widget.restaurant, title: "restaurant".tr()),
      drawer: MainDrawer(permissions: widget.permissions, restaurant: widget.restaurant),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          child: Padding(
            padding: AppConstants.padding16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // MainBackButton(color: restColor),
                BlocConsumer<RestaurantCubit, GeneralRestaurantState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    Widget? indicator;
                    String? coverUrl;
                    String? logoUrl;
                    String? qrOffline;
                    String? qrTakeout;
                    Color? color;
                    Color? backgroundColor;

                    if (state is RestaurantLoading) {
                      indicator = const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(child: LoadingIndicator(color: AppColors.black)),
                      );
                    } else if (state is RestaurantSuccess) {
                      final r = state.restaurant;
                      coverUrl = r.cover;
                      logoUrl = r.logo;
                      qrOffline = r.qrOffline;
                      qrTakeout = r.qrTakeout;

                      nameArController.text = r.nameAr ?? "";
                      nameEnController.text = r.nameEn ?? "";
                      nameUrlController.text = r.nameUrl ?? "";
                      facebookUrlController.text = r.facebookUrl ?? "";
                      instagramUrlController.text = r.instagramUrl ?? "";
                      whatsappPhoneController.text = r.whatsappPhone ?? "";
                      noteEnController.text = r.noteEn ?? "";
                      noteArController.text = r.noteAr ?? "";
                      messageBadController.text = r.messageBad ?? "";
                      messageGoodController.text = r.messageGood ?? "";
                      messagePerfectController.text = r.messagePerfect ?? "";
                      consumerSpendingController.text = r.consumerSpending.toString();
                      localAdminController.text = r.localAdmin.toString();
                      reconstructionController.text = r.reconstruction.toString();
                      priceKmController.text = r.priceKm != null ? r.priceKm.toString() : "";

                      color = r.color;
                      backgroundColor = r.backgroundColor;
                    }

                    return Column(
                      children: [
                        if (indicator != null) indicator,

                        _headerCard(
                          coverUrl: coverUrl,
                          logoUrl: logoUrl,
                          onCoverTap: onSetCover,
                          onLogoTap: onSetLogo,
                          brand: restColor,
                        ),
                        const SizedBox(height: 60),

                        _segmentedTabs(restColor),
                        const SizedBox(height: 14),

                        if (_section == _Section.basic)
                          _basicSection(welcomeLabel: "Welcome to resturant")
                        else
                          _extraSection(restColor, qrOffline, qrTakeout, color, backgroundColor),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: MainActionButton(
                        padding: AppConstants.padding14,
                        onPressed: onIgnoreTap,
                        borderRadius: BorderRadius.circular(28),
                        // buttonColor: const Color(0xFFE53935),
                        text: "cancel".tr(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: BlocConsumer<RestaurantCubit, GeneralRestaurantState>(
                        listener: (context, state) {
                          if (state is UpdateRestaurantSuccess) {
                            restaurantCubit.getRestaurant();
                            MainSnackBar.showSuccessMessage(context, state.message);
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
                            borderRadius: BorderRadius.circular(28),
                            // buttonColor: const Color(0xFFE3170A),
                            text: "save".tr(),
                            child: child,
                          );
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
