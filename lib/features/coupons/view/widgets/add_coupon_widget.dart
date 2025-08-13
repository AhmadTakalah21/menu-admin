import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/coupons/cubit/coupons_cubit.dart';
import 'package:user_admin/features/coupons/model/add_coupon_model/add_coupon_model.dart';
import 'package:user_admin/features/coupons/model/coupon_model/coupon_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/utils/utils.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';
import 'package:user_admin/global/widgets/main_text_field.dart';

abstract class AddCouponWidgetCallBack {
  void onCodeChanged(String code);

  void onCodeSubmitted(String code);

  void onPercentChanged(String percent);

  void onPercentSubmitted(String percent);

  Future<void> onFromDateSelected();

  Future<void> onToDateSelected();

  void onSaveTap();

  void onIgnoreTap();
}

class AddCouponWidget extends StatefulWidget {
  const AddCouponWidget({
    super.key,
    required this.isEdit,
    this.coupon,
    required this.selectedPage,
  });

  final CouponModel? coupon;
  final bool isEdit;
  final int selectedPage;

  @override
  State<AddCouponWidget> createState() => _AddCouponWidgetState();
}

class _AddCouponWidgetState extends State<AddCouponWidget>
    implements AddCouponWidgetCallBack {
  late final CouponsCubit couponsCubit = context.read();

  final codeFocusNode = FocusNode();
  final percentFocusNode = FocusNode();

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
    super.initState();
    codeFocusNode.requestFocus();
    final coupon = widget.coupon;
    if (coupon != null) {
      couponsCubit.setPercent(coupon.percent.toString());
      couponsCubit.setFromDate(coupon.fromDate);
      couponsCubit.setToDate(coupon.toDate);

      fromDateController.text = Utils.convertDateFormat(coupon.fromDate);
      toDateController.text = Utils.convertDateFormat(coupon.toDate);
    } else {
      fromDateController.text =
          "$selectedFromMonth/$selectedFromDay/$selectedFromYear";
      toDateController.text = "$selectedToMonth/$selectedToDay/$selectedToYear";
    }
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
      couponsCubit.setFromDate(
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
      couponsCubit.setToDate(Utils.convertToIsoFormat(toDateController.text));
    }
  }

  @override
  void onCodeChanged(String code) {
    couponsCubit.setCode(code);
  }

  @override
  void onCodeSubmitted(String code) {
    percentFocusNode.requestFocus();
  }

  @override
  void onPercentChanged(String percent) {
    couponsCubit.setPercent(percent);
  }

  @override
  void onPercentSubmitted(String percent) {
    percentFocusNode.unfocus();
  }

  @override
  void onSaveTap() {
    try {
      couponsCubit.addCouponModel.validateFields(); // ✅ تحقق يدوي من الحقول المطلوبة
      couponsCubit.addCoupon(
        isEdit: widget.isEdit,
        couponId: widget.coupon?.id,
      );
    } catch (e) {
      MainSnackBar.showErrorMessage(context, e.toString());
    }
  }


  @override
  void onIgnoreTap() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    fromDateController.dispose();
    toDateController.dispose();
    codeFocusNode.dispose();
    percentFocusNode.dispose();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        couponsCubit.addCouponModel = const AddCouponModel();
      }
    });

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
                  widget.isEdit ? "edit_coupon".tr() : "add_coupon".tr(),
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
            if (!widget.isEdit)
              MainTextField(
                onChanged: onCodeChanged,
                onSubmitted: onCodeSubmitted,
                focusNode: codeFocusNode,
                labelText: "code".tr(),
              ),
            if (!widget.isEdit) const SizedBox(height: 20),
            MainTextField(
              initialText: widget.coupon?.percent.toString(),
              onChanged: onPercentChanged,
              onSubmitted: onPercentSubmitted,
              focusNode: percentFocusNode,
              labelText: "discount".tr(),
            ),
            const SizedBox(height: 20),
            MainTextField(
              controller: fromDateController,
              labelText: "from_date".tr(),
              readOnly: true,
              onTap: onFromDateSelected,
              onClearTap: () {
                couponsCubit.setFromDate(null);
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
                couponsCubit.setToDate(null);
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
                BlocConsumer<CouponsCubit, GeneralCouponsState>(
                  listener: (context, state) {
                    if (state is AddCouponSuccess) {
                      couponsCubit.getCoupons(page: widget.selectedPage);
                      onIgnoreTap();
                      MainSnackBar.showSuccessMessage(context, state.message);
                    } else if (state is AddCouponFail) {
                      MainSnackBar.showErrorMessage(context, state.error);
                    }
                  },
                  builder: (context, state) {
                    var onTap = onSaveTap;
                    Widget? child;
                    if (state is AddCouponLoading) {
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
