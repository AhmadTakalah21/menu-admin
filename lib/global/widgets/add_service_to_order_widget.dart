import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/customer_service/cubit/customer_service_cubit.dart';
import 'package:user_admin/features/customer_service/model/service_model/service_model.dart';
import 'package:user_admin/features/tables/cubit/tables_cubit.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';
import 'package:user_admin/global/widgets/main_text_field.dart';

abstract class AddServiceToOrderWidgetCallBack {
  void onCountChanged(String count);

  void onCountSubmitted(String count);

  void onServiceSelected(ServiceModel? service);

  void onSaveTap();

  void onIgnoreTap();
}

class AddServiceToOrderWidget extends StatefulWidget {
  const AddServiceToOrderWidget({
    super.key,
    required this.id,
    required this.onSuccess,
    required this.isTable,
  });

  final bool isTable;
  final int id;
  final VoidCallback onSuccess;

  @override
  State<AddServiceToOrderWidget> createState() =>
      _AddServiceToOrderWidgetState();
}

class _AddServiceToOrderWidgetState extends State<AddServiceToOrderWidget>
    implements AddServiceToOrderWidgetCallBack {
  late final TablesCubit tablesCubit = context.read();

  final countFocusNode = FocusNode();
  final serviceFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.isTable) {
      tablesCubit.setTableIdOfService(widget.id);
    } else {
      tablesCubit.setInvoiceIdOfService(widget.id);
    }
    serviceFocusNode.requestFocus();
  }

  @override
  void onCountChanged(String count) {
    tablesCubit.setCountOfService(count);
  }

  @override
  void onCountSubmitted(String count) {
    countFocusNode.unfocus();
  }

  @override
  void onSaveTap() {
    tablesCubit.addService();
  }

  @override
  void onServiceSelected(ServiceModel? service) {
    tablesCubit.setServiceId(service);
    countFocusNode.requestFocus();
  }

  @override
  void onIgnoreTap() {
    Navigator.pop(context);
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
                  "add_service".tr(),
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
            BlocBuilder<CustomerServiceCubit, GeneralCustomerService>(
              builder: (context, state) {
                if (state is CustomerServiceLoading) {
                  return const LoadingIndicator(color: AppColors.black);
                } else if (state is CustomerServiceSuccess) {
                  return MainDropDownWidget<ServiceModel>(
                    items: state.services.data,
                    text: "service".tr(),
                    onChanged: onServiceSelected,
                    focusNode: serviceFocusNode,
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            const SizedBox(height: 20),
            MainTextField(
              onChanged: onCountChanged,
              onSubmitted: onCountSubmitted,
              focusNode: countFocusNode,
              labelText: "quantity".tr(),
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
                BlocConsumer<TablesCubit, GeneralTablesState>(
                  listener: (context, state) {
                    if (state is AddServiceToOrderSuccess) {
                      widget.onSuccess();
                      onIgnoreTap();
                      MainSnackBar.showSuccessMessage(context, state.message);
                    } else if (state is AddServiceToOrderFail) {
                      MainSnackBar.showErrorMessage(context, state.error);
                    }
                  },
                  builder: (context, state) {
                    var onTap = onSaveTap;
                    Widget? child;
                    if (state is AddServiceToOrderLoading) {
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
