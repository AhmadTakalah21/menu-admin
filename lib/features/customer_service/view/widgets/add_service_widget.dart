import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/customer_service/cubit/customer_service_cubit.dart';
import 'package:user_admin/features/customer_service/model/service_model/service_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';
import 'package:user_admin/global/widgets/main_text_field.dart';

abstract class AddServiceWidgetCallBack {
  void onNameEnChanged(String nameEn);

  void onNameEnSubmitted(String nameEn);

  void onNameArChanged(String nameAr);

  void onNameArSubmitted(String nameAr);

  void onPriceChanged(String price);

  void onPriceSubmitted(String price);

  void onSaveTap();

  void onIgnoreTap();
}

class AddServiceWidget extends StatefulWidget {
  const AddServiceWidget({
    super.key,
    required this.isEdit,
    this.service,
    required this.selectedPage,
  });

  final ServiceModel? service;
  final bool isEdit;
  final int selectedPage;

  @override
  State<AddServiceWidget> createState() => _AddServiceWidgetState();
}

class _AddServiceWidgetState extends State<AddServiceWidget>
    implements AddServiceWidgetCallBack {
  late final CustomerServiceCubit customerServiceCubit;

  final nameEnFocusNode = FocusNode();
  final nameArFocusNode = FocusNode();
  final priceFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    customerServiceCubit = context.read<CustomerServiceCubit>();
    nameArFocusNode.requestFocus();
    final service = widget.service;
    if (service != null) {
      customerServiceCubit.setNameAr(service.nameAr);
      customerServiceCubit.setNameEn(service.nameEn);
      customerServiceCubit.setPrice(service.price.toString());
    }
  }

  @override
  void onNameArChanged(String nameAr) {
    customerServiceCubit.setNameAr(nameAr);
  }

  @override
  void onNameArSubmitted(String nameAr) {
    nameEnFocusNode.requestFocus();
  }

  @override
  void onNameEnChanged(String nameEn) {
    customerServiceCubit.setNameEn(nameEn);
  }

  @override
  void onNameEnSubmitted(String nameEn) {
    priceFocusNode.requestFocus();
  }

  @override
  void onPriceChanged(String price) {
    customerServiceCubit.setPrice(price);
  }

  @override
  void onPriceSubmitted(String price) {
    priceFocusNode.unfocus();
  }

  @override
  void onSaveTap() {
    customerServiceCubit.addService(
      isEdit: widget.isEdit,
      serviceId: widget.service?.id,
    );
  }

  @override
  void onIgnoreTap() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    customerServiceCubit.resetModel();
    nameEnFocusNode.dispose();
    nameArFocusNode.dispose();
    priceFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: AppConstants.padding16,
      contentPadding: AppConstants.padding16,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 20),
                const Spacer(),
                Text(
                  widget.isEdit ? "edit_service".tr() : "add_service".tr(),
                  style: const TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: onIgnoreTap,
                  child: const Icon(
                    Icons.close,
                    color: AppColors.greyShade,
                  ),
                ),
              ],
            ),
            const Divider(height: 30),
            MainTextField(
              initialText: widget.service?.nameAr.toString(),
              onChanged: onNameArChanged,
              onSubmitted: onNameArSubmitted,
              focusNode: nameArFocusNode,
              labelText: "name_ar".tr(),
            ),
            const SizedBox(height: 20),
            MainTextField(
              initialText: widget.service?.nameEn.toString(),
              onChanged: onNameEnChanged,
              onSubmitted: onNameEnSubmitted,
              focusNode: nameEnFocusNode,
              labelText: "name_en".tr(),
            ),
            const SizedBox(height: 20),
            MainTextField(
              initialText: widget.service?.price.toString(),
              onChanged: onPriceChanged,
              onSubmitted: onPriceSubmitted,
              focusNode: priceFocusNode,
              labelText: "price".tr(),
            ),
            const Divider(height: 30),
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
                BlocConsumer<CustomerServiceCubit, GeneralCustomerService>(
                  listener: (context, state) {
                    if (state is AddrServiceSuccess) {
                      customerServiceCubit.getServices(
                        page: widget.selectedPage,
                      );
                      onIgnoreTap();
                      MainSnackBar.showSuccessMessage(context, state.message);
                    } else if (state is AddrServiceFail) {
                      MainSnackBar.showErrorMessage(context, state.error);
                    }
                  },
                  builder: (context, state) {
                    var onTap = onSaveTap;
                    Widget? child;
                    if (state is AddrServiceLoading) {
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
