import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/advertisements/cubit/advertisements_cubit.dart';
import 'package:user_admin/features/advertisements/model/add_advertisement_model/add_advertisement_model.dart';
import 'package:user_admin/features/advertisements/model/advertisement_model/advertisement_model.dart';
import 'package:user_admin/features/items/model/is_panorama_enum.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/utils/utils.dart';
import 'package:user_admin/global/widgets/app_image_widget.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';
import 'package:user_admin/global/widgets/main_text_field.dart';

abstract class AddAdvertisementWidgetCallBacks {
  void onNameChanged(String name);

  void onNameSubmitted(String name);

  Future<void> onFromDateSelected();

  Future<void> onToDateSelected();

  void selectIsPanorama(IsPanoramaEnum? isPanorama);

  void selectHideDate(IsPanoramaEnum? hideDate);

  void onImageTap();

  void onSaveTap();

  void onIgnoreTap();
}

class AddAdvertisementWidget extends StatefulWidget {
  const AddAdvertisementWidget({
    super.key,
    this.advertisement,
    required this.isEdit,
  });
  final AdvertisementModel? advertisement;
  final bool isEdit;

  @override
  State<AddAdvertisementWidget> createState() => _AddAdvertisementWidgetState();
}

class _AddAdvertisementWidgetState extends State<AddAdvertisementWidget>
    implements AddAdvertisementWidgetCallBacks {
  late final AdvertisementsCubit advertisementsCubit = context.read();

  final nameFocusNode = FocusNode();
  final panoramaFocusNode = FocusNode();
  final hideDateFocusNode = FocusNode();

  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();

  DateTime selectedFromDate = DateTime.now();
  String selectedFromMonth = "mm";
  String selectedFromDay = "dd";
  String selectedFromYear = "yyyy";

  DateTime selectedToDate = DateTime.now();
  String selectedToMonth = "mm";
  String selectedToDay = "dd";
  String selectedToYear = "yyyy";

  @override
  void initState() {
    final advertisement = widget.advertisement;
    super.initState();
    nameFocusNode.requestFocus();
    if (advertisement != null && widget.isEdit) {
      final hideDate = IsPanoramaEnum.isPanoramaEnum(advertisement.hideDate);
      final isPanorama =
          IsPanoramaEnum.isPanoramaEnum(advertisement.isPanorama);

      advertisementsCubit.setName(advertisement.title);
      advertisementsCubit.setFromDate(advertisement.fromDate);
      advertisementsCubit.setToDate(advertisement.toDate);
      advertisementsCubit.setHideDate(hideDate);
      advertisementsCubit.setIsPanorama(isPanorama);

      fromDateController.text = Utils.convertDateFormat(advertisement.fromDate);
      toDateController.text = Utils.convertDateFormat(advertisement.toDate);
    } else {
      fromDateController.text =
          "$selectedFromMonth/$selectedFromDay/$selectedFromYear";
      toDateController.text = "$selectedToMonth/$selectedToDay/$selectedToYear";
    }
  }

  @override
  void onImageTap() {
    advertisementsCubit.setImage();
  }

  @override
  void onNameChanged(String name) {
    advertisementsCubit.setName(name);
  }

  @override
  void onNameSubmitted(String name) {
    nameFocusNode.unfocus();
  }

  @override
  Future<void> onFromDateSelected() async {
    final dateTime = await showDatePicker(
      context: context,
      initialDate: selectedFromDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(3000),
    );
    if (dateTime != null) {
      setState(() {
        selectedFromDate = dateTime;
        selectedFromMonth = dateTime.month.toString();
        selectedFromDay = dateTime.day.toString();
        selectedFromYear = dateTime.year.toString();
        fromDateController.text =
            "$selectedFromMonth/$selectedFromDay/$selectedFromYear";
      });
      advertisementsCubit.setFromDate(
        Utils.convertToIsoFormat(fromDateController.text),
      );
    }
  }

  @override
  Future<void> onToDateSelected() async {
    final dateTime = await showDatePicker(
      context: context,
      initialDate: selectedToDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(3000),
    );
    if (dateTime != null) {
      setState(() {
        selectedToDate = dateTime;
        selectedToMonth = dateTime.month.toString();
        selectedToDay = dateTime.day.toString();
        selectedToYear = dateTime.year.toString();
        toDateController.text =
            "$selectedToMonth/$selectedToDay/$selectedToYear";
      });
      advertisementsCubit.setToDate(
        Utils.convertToIsoFormat(toDateController.text),
      );
    }
  }

  @override
  void selectHideDate(IsPanoramaEnum? hideDate) {
    advertisementsCubit.setHideDate(hideDate);
  }

  @override
  void selectIsPanorama(IsPanoramaEnum? isPanorama) {
    advertisementsCubit.setIsPanorama(isPanorama);
  }

  @override
  void onIgnoreTap() {
    Navigator.pop(context);
  }

  @override
  void onSaveTap() {
    advertisementsCubit.addAdvertisement(
      isEdit: widget.isEdit,
      advertisementId: widget.advertisement?.id,
    );
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    panoramaFocusNode.dispose();
    hideDateFocusNode.dispose();
    fromDateController.dispose();
    toDateController.dispose();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        advertisementsCubit.addAdvertisementModel =
            const AddAdvertisementModel();
      }
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final advertisement = widget.advertisement;
    IsPanoramaEnum? initialHideDate = IsPanoramaEnum.no;
    IsPanoramaEnum? initialIsPanorama = IsPanoramaEnum.no;
    if (advertisement != null) {
      initialHideDate = IsPanoramaEnum.isPanoramaEnum(advertisement.hideDate);
      initialIsPanorama =
          IsPanoramaEnum.isPanoramaEnum(advertisement.isPanorama);
    }

    return AlertDialog(
      insetPadding: AppConstants.padding16,
      contentPadding: AppConstants.padding16,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.isEdit
                  ? "edit_advertisement".tr()
                  : "edit_advertisement".tr(),
              style: const TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            const Divider(height: 30),
            InkWell(
              onTap: onImageTap,
              child: advertisement != null
                  ? AppImageWidget(
                      width: 200,
                      fit: BoxFit.contain,
                      url: advertisement.image,
                      errorWidget: SizedBox(
                        height: 200,
                        child: Center(
                          child: Text(
                            "${"no_image".tr()} \n ${"click_to_edit".tr()}",
                            style: const TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  : Image.asset("assets/images/upload_image.png", scale: 1.5),
            ),
            const SizedBox(height: 20),
            MainTextField(
              initialText: widget.advertisement?.title,
              onChanged: onNameChanged,
              onSubmitted: onNameSubmitted,
              focusNode: nameFocusNode,
              labelText: "name".tr(),
            ),
            const SizedBox(height: 20),
            MainTextField(
              controller: fromDateController,
              labelText: "from_date".tr(),
              readOnly: true,
              onTap: onFromDateSelected,
              onClearTap: () {
                advertisementsCubit.setFromDate(null);
                setState(() {
                  fromDateController.text = "mm/dd/yyyy";
                });
              },
              showCloseIcon: fromDateController.text != "mm/dd/yyyy",
              suffixIcon: IconButton(
                onPressed: onFromDateSelected,
                icon: const Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 20),
            MainTextField(
              controller: toDateController,
              labelText: "to_date".tr(),
              readOnly: true,
              onTap: onToDateSelected,
              onClearTap: () {
                advertisementsCubit.setToDate(null);
                setState(() {
                  toDateController.text = "mm/dd/yyyy";
                });
              },
              showCloseIcon: toDateController.text != "mm/dd/yyyy",
              suffixIcon: IconButton(
                onPressed: onToDateSelected,
                icon: const Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 10),
            MainDropDownWidget<IsPanoramaEnum>(
              label: "panorama".tr(),
              items: IsPanoramaEnum.values,
              text: "panorama".tr(),
              onChanged: selectHideDate,
              focusNode: panoramaFocusNode,
              selectedValue: initialIsPanorama,
            ),
            const SizedBox(height: 10),
            MainDropDownWidget<IsPanoramaEnum>(
              label: "hide_date".tr(),
              items: IsPanoramaEnum.values,
              text: "hide_date".tr(),
              onChanged: selectHideDate,
              focusNode: hideDateFocusNode,
              selectedValue: initialHideDate,
            ),
            const Divider(height: 40),
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
                BlocConsumer<AdvertisementsCubit, GeneralAdvertisementsState>(
                  listener: (context, state) {
                    if (state is AddAdvertisementSuccess) {
                      advertisementsCubit.getAdvertisements(isRefresh: true);
                      onIgnoreTap();
                      MainSnackBar.showSuccessMessage(context, state.message);
                    } else if (state is AddAdvertisementFail) {
                      MainSnackBar.showErrorMessage(context, state.error);
                    }
                  },
                  builder: (context, state) {
                    var onTap = onSaveTap;
                    Widget? child;
                    if (state is AddAdvertisementLoading) {
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
    );
  }
}
