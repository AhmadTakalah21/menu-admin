import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/drivers/cubit/drivers_cubit.dart';
import 'package:user_admin/features/drivers/model/driver_model/driver_model.dart';
import 'package:user_admin/features/drivers/model/drvier_invoice_model/drvier_invoice_model.dart';
import 'package:user_admin/features/takeout_orders/cubit/takeout_orders_cubit.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import '../../../../global/widgets/main_status_drop_down_widget.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';

abstract class EditDriverOfOrderCallBacks {
  void onDriverSelected(DriverModel? driver);
  void onStatusSelected(String? status);
  void onSaveTap();
  void onIgnoreTap();
}

class EditDriverOfOrder extends StatefulWidget {
  const EditDriverOfOrder({
    super.key,
    required this.invoice,
  });
  final DrvierInvoiceModel invoice;

  @override
  State<EditDriverOfOrder> createState() => _EditDriverOfOrderState();
}

class _EditDriverOfOrderState extends State<EditDriverOfOrder>
    implements EditDriverOfOrderCallBacks {
  late final DriversCubit driversCubit = context.read();
  late final TakeoutOrdersCubit takeoutOrdersCubit = context.read();

  final driversFocusNode = FocusNode();
  final statusFocusNode = FocusNode();

  String? selectedStatus;
  DriverModel? selectedDriver;

  final List<String> statusOptions = [
    'Processing',
    'Approved',
    'Rejected'
  ];

  @override
  void initState() {
    super.initState();
    driversCubit.getDrivers(isActive: true, isRefresh: false);
    driversFocusNode.requestFocus();
    selectedStatus = widget.invoice.status;
  }

  @override
  void dispose() {
    driversFocusNode.dispose();
    statusFocusNode.dispose();
    super.dispose();
  }

  @override
  void onIgnoreTap() {
    Navigator.pop(context);
  }

  @override
  void onDriverSelected(DriverModel? driver) {
    setState(() {
      selectedDriver = driver;
    });
    takeoutOrdersCubit.setDeliveryId(driver);
    driversFocusNode.unfocus();
  }

  @override
  void onStatusSelected(String? status) {
    setState(() => selectedStatus = status);
    statusFocusNode.unfocus();
  }

  @override
  @override
  void onSaveTap() {
    if (selectedDriver != null) {
      takeoutOrdersCubit.changeDriverOfOrder(widget.invoice.id);
    }

    if (selectedStatus != null && selectedStatus != widget.invoice.status) {
      takeoutOrdersCubit.updateTakeoutOrderStatus(
        widget.invoice.id,
        selectedStatus!,
      );
    }
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
            Text(
              "edit_driver".tr(),
              style: const TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            const Divider(height: 30),
            const SizedBox(height: 5),
            BlocBuilder<DriversCubit, GeneralDriversState>(
              buildWhen: (previous, current) => current is DriversState,
              builder: (context, state) {
                if (state is DriversLoading) {
                  return const LoadingIndicator(color: AppColors.black);
                } else if (state is DriversSuccess) {
                  return MainDropDownWidget<DriverModel>(
                    label: "driver".tr(),
                    items: state.drivers.data,
                    text: "driver".tr(),
                    expandedHeight: 250,
                    onChanged: onDriverSelected,
                    focusNode: driversFocusNode,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 20),
            MainStatusDropDownWidget(
              statusOptions: statusOptions,
              selectedStatus: selectedStatus ?? "select_status".tr(),
              onChanged: onStatusSelected,
              focusNode: statusFocusNode,
            ),
            const Divider(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                BlocConsumer<TakeoutOrdersCubit, GeneralTakeoutOrdersState>(
                  listener: (context, state) {
                    if (state is ChangeDriverOfOrderSuccess) {
                      takeoutOrdersCubit.getTakeoutOrders(1);
                      onIgnoreTap();
                      MainSnackBar.showSuccessMessage(context, state.message);
                    } else if (state is ChangeDriverOfOrderFail) {
                      MainSnackBar.showErrorMessage(context, state.error);
                    } else if (state is UpdateTakeoutOrderStatusSuccess) {
                      takeoutOrdersCubit.getTakeoutOrders(1);
                      onIgnoreTap();
                      MainSnackBar.showSuccessMessage(context, state.message);
                    } else if (state is UpdateTakeoutOrderStatusFail) {
                      MainSnackBar.showErrorMessage(context, state.error);
                    }
                  },
                  builder: (context, state) {
                    var onTap = onSaveTap;
                    Widget? child;
                    if (state is ChangeDriverOfOrderLoading ||
                        state is UpdateTakeoutOrderStatusLoading) {
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
