import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/invoices/cubit/invoices_cubit.dart';
import 'package:user_admin/features/items/cubit/items_cubit.dart';
import 'package:user_admin/global/model/table_model/table_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';
import 'package:user_admin/global/widgets/main_error_widget.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';

abstract class AddInvoiceWidgetCallBack {
  void onTableSelected(TableModel? table);

  void onSaveTap();

  void onIgnoreTap();
}

class AddInvoiceWidget extends StatefulWidget {
  const AddInvoiceWidget({super.key, required this.selectedPage});

  final int selectedPage;

  @override
  State<AddInvoiceWidget> createState() => _AddInvoiceWidgetState();
}

class _AddInvoiceWidgetState extends State<AddInvoiceWidget>
    implements AddInvoiceWidgetCallBack {
  late final InvoicesCubit invoicesCubit = context.read();
  late final ItemsCubit itemsCubit = context.read();

  @override
  void onTableSelected(TableModel? table) {
    invoicesCubit.setAddInvoiceTableId(table);
  }

  @override
  void onSaveTap() {
    invoicesCubit.addInvoiceToTable();
  }

  void onTryAgainTap() {
    itemsCubit.getTables();
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
                  "create_invoice".tr(),
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
            BlocBuilder<ItemsCubit, GeneralItemsState>(
              buildWhen: (previous, current) => current is TablesState,
              builder: (context, state) {
                if (state is TablesLoading) {
                  return const LoadingIndicator(color: AppColors.black);
                } else if (state is TablesSuccess) {
                  return MainDropDownWidget(
                    items: state.tables.data,
                    text: "table".tr(),
                    onChanged: onTableSelected,
                    focusNode: FocusNode(),
                  );
                } else if (state is TablesFail) {
                  return MainErrorWidget(
                    error: state.error,
                    onTryAgainTap: onTryAgainTap,
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
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
                BlocConsumer<InvoicesCubit, GeneralInvoicesState>(
                  listener: (context, state) {
                    if (state is AddInvoiceToTableSuccess) {
                      invoicesCubit.getInvoices(widget.selectedPage);
                      onIgnoreTap();
                      MainSnackBar.showSuccessMessage(context, state.invoice.toString());
                    } else if (state is AddInvoiceToTableFail) {
                      MainSnackBar.showErrorMessage(context, state.error);
                    }
                  },
                  builder: (context, state) {
                    var onTap = onSaveTap;
                    Widget? child;
                    if (state is AddInvoiceToTableLoading) {
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
