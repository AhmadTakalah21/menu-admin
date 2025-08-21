import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/items/cubit/items_cubit.dart';
import 'package:user_admin/features/items/model/is_panorama_enum.dart';
import 'package:user_admin/features/tables/cubit/tables_cubit.dart';
import 'package:user_admin/features/tables/model/edit_table_model/edit_table_model.dart';
import 'package:user_admin/global/model/table_model/table_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';
import 'package:user_admin/global/widgets/main_text_field.dart';

abstract class EditTableWidgetCallBack {
  void onTableNumberChanged(String tableNumber);

  void onTableNumberSubmitted(String tableNumber);

  void onIsQRSelected(IsPanoramaEnum? table);

  void onSaveTap();

  void onIgnoreTap();
}

class EditTableWidget extends StatefulWidget {
  const EditTableWidget({
    super.key,
    required this.isEdit,
    this.table,
  });

  final TableModel? table;
  final bool isEdit;

  @override
  State<EditTableWidget> createState() => _EditTableWidgetState();
}

class _EditTableWidgetState extends State<EditTableWidget>
    implements EditTableWidgetCallBack {
  late final TablesCubit tablesCubit = context.read();
  late final ItemsCubit itemsCubit = context.read();

  final tableNumberFocusNode = FocusNode();
  final qrFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    tableNumberFocusNode.requestFocus();
    final table = widget.table;
    if (table != null) {
      final isPanoramaEnum =
          table.isQrTable ? IsPanoramaEnum.yes : IsPanoramaEnum.no;
      tablesCubit.setTableNumber(table.tableNumber.toString());
      tablesCubit.setIsQrTable(isPanoramaEnum);
    }
  }

  @override
  void onTableNumberChanged(String tableNumber) {
    tablesCubit.setTableNumber(tableNumber);
  }

  @override
  void onTableNumberSubmitted(String tableNumber) {
    qrFocusNode.requestFocus();
  }

  @override
  void onSaveTap() {
    tablesCubit.editTable(isEdit: widget.isEdit, tableId: widget.table?.id);
  }

  @override
  void onIsQRSelected(IsPanoramaEnum? isQr) {
    tablesCubit.setIsQrTable(isQr);
    qrFocusNode.unfocus();
  }

  @override
  void onIgnoreTap() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    tableNumberFocusNode.dispose();
    qrFocusNode.dispose();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        tablesCubit.editTableModel = const EditTableModel();
      }
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    IsPanoramaEnum? isPanorama;
    if (widget.isEdit) {
      isPanorama = IsPanoramaEnum.values.firstWhere((element) {
        bool isQrTable = element.id == 1;
        return widget.table?.isQrTable == isQrTable;
      });
    }
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
                  "add_table".tr(),
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
              initialText: widget.table?.tableNumber.toString(),
              onChanged: onTableNumberChanged,
              onSubmitted: onTableNumberSubmitted,
              focusNode: tableNumberFocusNode,
              labelText: "table_num".tr(),
              textInputType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            const SizedBox(height: 20),
            MainDropDownWidget<IsPanoramaEnum>(
              items: IsPanoramaEnum.values,
              text: "is_add_qr".tr(),
              onChanged: onIsQRSelected,
              focusNode: qrFocusNode,
              selectedValue: isPanorama,
            ),
            const Divider(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MainActionButton(
                  // padding: AppConstants.padding14,
                  onPressed: onIgnoreTap,
                  // borderRadius: AppConstants.borderRadius5,
                  // buttonColor: AppColors.blueShade3,
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
                    if (state is EditTableSuccess) {
                      itemsCubit.getTables();
                      onIgnoreTap();
                      MainSnackBar.showSuccessMessage(context, state.message);
                    } else if (state is EditTableFail) {
                      MainSnackBar.showErrorMessage(context, state.error);
                    }
                  },
                  builder: (context, state) {
                    var onTap = onSaveTap;
                    Widget? child;
                    if (state is EditTableLoading) {
                      onTap = () {};
                      child = const LoadingIndicator(size: 20);
                    }
                    return MainActionButton(
                      // padding: AppConstants.padding14,
                      onPressed: onTap,
                      // borderRadius: AppConstants.borderRadius5,
                      // buttonColor: AppColors.blueShade3,
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
