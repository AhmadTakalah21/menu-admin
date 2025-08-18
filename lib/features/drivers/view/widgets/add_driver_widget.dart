import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/drivers/cubit/drivers_cubit.dart';
import 'package:user_admin/features/drivers/model/add_driver_model/add_driver_model.dart';
import 'package:user_admin/features/drivers/model/driver_model/driver_model.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/model/role_model/role_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/utils/utils.dart';
import 'package:user_admin/global/widgets/app_image_widget.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';
import 'package:user_admin/global/widgets/main_text_field.dart';

abstract class AddDriverWidgetCallBacks {
  void onNameChanged(String name);
  void onNameSubmitted(String name);
  void onUsernameChanged(String username);
  void onUsernameSubmitted(String username);
  void onPasswordChanged(String password);
  void onPasswordSubmitted(String password);
  void onPhoneNumberChanged(String phoneNumber);
  void onPhoneNumberSubmitted(String phoneNumber);
  Future<void> onBirthdaySelected();
  void onImageTap();
  void onSaveTap();
  void onIgnoreTap();
}

class AddDriverWidget extends StatefulWidget {
  const AddDriverWidget({
    super.key,
    this.driver,
    required this.isEdit,
    required this.permissions,
    required this.restaurant,
  });
  final List<RoleModel> permissions;
  final RestaurantModel restaurant;
  final DriverModel? driver;
  final bool isEdit;

  @override
  State<AddDriverWidget> createState() => _AddDriverWidgetState();
}

class _AddDriverWidgetState extends State<AddDriverWidget>
    implements AddDriverWidgetCallBacks {
  late final DriversCubit driversCubit = context.read();

  final birthdayController = TextEditingController();

  DateTime selectedBirthday = DateTime.now();
  String selectedMonth = "mm";
  String selectedDay = "dd";
  String selectedYear = "yyyy";

  final nameFocusNode = FocusNode();
  final usernameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final phoneNumberFocusNode = FocusNode();

  @override
  void initState() {
    final driver = widget.driver;
    super.initState();
    if (driver != null && widget.isEdit) {
      final birthday = driver.birthday;
      if (birthday != null) {
        birthdayController.text = Utils.convertDateFormat(birthday);
        driversCubit.setBirthday(birthday);
      } else {
        birthdayController.text = "_";
      }
      driversCubit.setName(driver.name);
      driversCubit.setUsername(driver.username);
      driversCubit.setPhone(driver.phone);
    }
  }

  @override
  Future<void> onBirthdaySelected() async {
    final dateTime = await showDatePicker(
      context: context,
      initialDate: selectedBirthday,
      firstDate: DateTime(1900),
      lastDate: DateTime(3000),
    );
    if (dateTime != null) {
      setState(() {
        selectedBirthday = dateTime;
        selectedMonth = dateTime.month.toString();
        selectedDay = dateTime.day.toString();
        selectedYear = dateTime.year.toString();
        birthdayController.text = "$selectedMonth/$selectedDay/$selectedYear";
      });
      driversCubit.setBirthday(
        Utils.convertToIsoFormat(birthdayController.text),
      );
    }
  }

  @override
  void onIgnoreTap() {
    Navigator.pop(context);
  }

  @override
  void onImageTap() {
    driversCubit.setImage();
  }

  @override
  void onNameChanged(String name) {
    driversCubit.setName(name);
  }

  @override
  void onNameSubmitted(String name) {
    usernameFocusNode.requestFocus();
  }

  @override
  void onPasswordChanged(String password) {
    driversCubit.setPassword(password);
  }

  @override
  void onPasswordSubmitted(String password) {
    phoneNumberFocusNode.requestFocus();
  }

  @override
  void onPhoneNumberChanged(String phoneNumber) {
    driversCubit.setPhone(phoneNumber);
  }

  @override
  void onPhoneNumberSubmitted(String phoneNumber) {
    phoneNumberFocusNode.unfocus();
  }

  @override
  void onSaveTap() {
    driversCubit.addDriver(
      widget.restaurant.id,
      isEdit: widget.isEdit,
      driverId: widget.driver?.id,
    );
  }

  @override
  void onUsernameChanged(String username) {
    driversCubit.setUsername(username);
  }

  @override
  void onUsernameSubmitted(String username) {
    passwordFocusNode.requestFocus();
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    usernameFocusNode.dispose();
    passwordFocusNode.dispose();
    phoneNumberFocusNode.dispose();
    birthdayController.dispose();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        driversCubit.addDriverModel = const AddDriverModel();
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final driver = widget.driver;
    return AlertDialog(
      insetPadding: AppConstants.padding16,
      contentPadding: AppConstants.padding16,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.isEdit ? "edit_driver".tr() : "add_driver".tr(),
              style: const TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            const Divider(height: 30),
            InkWell(
              onTap: onImageTap,
              child: driver != null
                  ? AppImageWidget(
                      width: 200,
                      fit: BoxFit.contain,
                      url: driver.image,
                      errorWidget: Image.asset(
                        "assets/images/upload_image.png",
                        scale: 1.5,
                      ),
                    )
                  : Image.asset("assets/images/upload_image.png", scale: 1.5),
            ),
            const SizedBox(height: 10),
            MainTextField(
              initialText: driver?.name,
              onChanged: onNameChanged,
              onSubmitted: onNameSubmitted,
              focusNode: nameFocusNode,
              labelText: "name".tr(),
            ),
            const SizedBox(height: 10),
            MainTextField(
              initialText: driver?.username,
              onChanged: onUsernameChanged,
              onSubmitted: onUsernameSubmitted,
              focusNode: usernameFocusNode,
              labelText: "username".tr(),
            ),
            const SizedBox(height: 10),
            MainTextField(
              onChanged: onPasswordChanged,
              onSubmitted: onPasswordSubmitted,
              focusNode: passwordFocusNode,
              labelText: "password".tr(),
            ),
            const SizedBox(height: 10),
            MainTextField(
              initialText: driver?.phone,
              onChanged: onPhoneNumberChanged,
              onSubmitted: onPhoneNumberSubmitted,
              focusNode: phoneNumberFocusNode,
              labelText: "phone_number".tr(),
            ),
            const SizedBox(height: 10),
            MainTextField(
              controller: birthdayController,
              labelText: "birthday".tr(),
              readOnly: true,
              onTap: onBirthdaySelected,
              onClearTap: () {
                driversCubit.setBirthday(null);
                setState(() {
                  birthdayController.text = "mm/dd/yyyy";
                });
              },
              showCloseIcon: birthdayController.text != "mm/dd/yyyy",
              suffixIcon: IconButton(
                onPressed: onBirthdaySelected,
                icon: const Icon(Icons.calendar_today),
              ),
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
                BlocConsumer<DriversCubit, GeneralDriversState>(
                  listener: (context, state) {
                    if (state is AddDriverSuccess) {
                      driversCubit.getDrivers(isActive: false, isRefresh: true);
                      onIgnoreTap();
                      MainSnackBar.showSuccessMessage(context, state.message);
                    } else if (state is AddDriverFail) {
                      MainSnackBar.showErrorMessage(context, state.error);
                    }
                  },
                  builder: (context, state) {
                    var onTap = onSaveTap;
                    Widget? child;
                    if (state is AddDriverLoading) {
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
