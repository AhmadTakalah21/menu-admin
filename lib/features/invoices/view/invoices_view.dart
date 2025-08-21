import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:user_admin/features/admins/model/admin_model/admin_model.dart';
import 'package:user_admin/features/customer_service/cubit/customer_service_cubit.dart';
import 'package:user_admin/features/drivers/model/drvier_invoice_model/drvier_invoice_model.dart';
import 'package:user_admin/features/invoices/cubit/invoices_cubit.dart';
import 'package:user_admin/features/invoices/view/widgets/add_invoice_widget.dart';
import 'package:user_admin/features/items/cubit/items_cubit.dart';
import 'package:user_admin/features/takeout_orders/cubit/takeout_orders_cubit.dart';
import 'package:user_admin/global/di/di.dart';
import 'package:user_admin/global/model/paginated_model/paginated_model.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/model/role_model/role_model.dart';
import 'package:user_admin/global/model/table_model/table_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/utils/utils.dart';
import 'package:user_admin/global/widgets/add_service_to_order_widget.dart';
import 'package:user_admin/global/widgets/invoice_widget.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_add_button.dart';
import 'package:user_admin/global/widgets/main_app_bar.dart';
import 'package:user_admin/global/widgets/main_data_table.dart';
import 'package:user_admin/global/widgets/main_drawer.dart';
import 'package:user_admin/global/widgets/main_drop_down_widget.dart';
import 'package:user_admin/global/widgets/main_error_widget.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';
import 'package:user_admin/global/widgets/main_text_field.dart';
import 'package:user_admin/global/widgets/select_page_tile.dart';

abstract class InvoicesViewCallBacks {
  Future<void> onRefresh();
  void onAddTap();
  Future<void> onExportToExcelTap(List<DrvierInvoiceModel> invoices);
  void onAddSeriveTap(DrvierInvoiceModel invoice);
  void onUpdateStatusInvoicePaidTap(DrvierInvoiceModel invoice, int index);
  void onUpdateStatusInvoiceReceivedTap(DrvierInvoiceModel invoice, int index);
  void onShowDetails(DrvierInvoiceModel invoice);
  void onTableSelected(TableModel? table);
  void onWaiterSelected(AdminModel? waiter);
  Future<void> onDateSelected();
  void onShowFilters();
  void onSelectPageTap(int page);
  void onTryAgainTap();
}

class InvoicesView extends StatelessWidget {
  const InvoicesView({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => get<InvoicesCubit>(),
      child: InvoicesPage(permissions: permissions, restaurant: restaurant),
    );
  }
}

class InvoicesPage extends StatefulWidget {
  const InvoicesPage({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage>
    implements InvoicesViewCallBacks {
  late final InvoicesCubit invoicesCubit = context.read();
  late final TakeoutOrdersCubit takeoutOrdersCubit = context.read();
  late final ItemsCubit itemsCubit = context.read();
  late final CustomerServiceCubit customerServiceCubit = context.read();

  int selectedPage = 1;
  bool isShowFilters = false;

  final dateController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String selectedMonth = "mm";
  String selectedDay = "dd";
  String selectedYear = "yyyy";

  @override
  void initState() {
    super.initState();
    invoicesCubit.getInvoices(selectedPage);
    invoicesCubit.getWaiters();
    itemsCubit.getTables();
    customerServiceCubit.getServices();

    dateController.text = "$selectedMonth/$selectedDay/$selectedYear";
  }

  @override
  void onShowDetails(DrvierInvoiceModel invoice) {
    showDialog(
      context: context,
      builder: (context) => InvoiceWidget(invoice: invoice),
    );
  }

  @override
  void onShowFilters() {
    setState(() {
      isShowFilters = !isShowFilters;
    });
  }

  @override
  Future<void> onExportToExcelTap(List<DrvierInvoiceModel> invoices) async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
    }

    List<List<CellValue?>> list = [
      [
        TextCellValue("invoice_num".tr()),
        TextCellValue("total_price".tr()),
        TextCellValue("table_num".tr()),
        TextCellValue("waiter_name".tr()),
        TextCellValue("invoice_created_at".tr()),
        TextCellValue("status".tr())
      ],
    ];
    final listOfData = List.generate(
      invoices.length,
          (index) {
        return [
          TextCellValue(invoices[index].number.toString()),
          TextCellValue(invoices[index].total ?? "_"),
          TextCellValue(invoices[index].tableNumber?.toString() ?? "_"),
          TextCellValue(invoices[index].waiter ?? "_"),
          TextCellValue(invoices[index].createdAt),
          TextCellValue(invoices[index].status ?? "_")
        ];
      },
    );
    for (var data in listOfData) {
      list.add(data);
    }

    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    CellStyle cellStyle = CellStyle(horizontalAlign: HorizontalAlign.Center);

    for (int rowIndex = 0; rowIndex < list.length; rowIndex++) {
      var row = list[rowIndex];
      for (int colIndex = 0; colIndex < row.length; colIndex++) {
        var cell = sheetObject.cell(
          CellIndex.indexByColumnRow(columnIndex: colIndex, rowIndex: rowIndex),
        );
        cell.value = row[colIndex];
        cell.cellStyle = cellStyle;
      }
    }

    Directory? directory;
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    String outputFile = "${directory!.path}/${"invoices".tr()}.xlsx";

    final fileBytes = excel.encode();
    final file = File(outputFile)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);

    final result = await Share.shareXFiles([XFile(file.path)]);

    if (!mounted) return;
    if (result.status == ShareResultStatus.success) {
      MainSnackBar.showSuccessMessage(context, "shared_successfully".tr());
    } else if (result.status == ShareResultStatus.dismissed) {
      MainSnackBar.showErrorMessage(context, "share_dismissed".tr());
    }
  }

  @override
  void onAddSeriveTap(DrvierInvoiceModel invoice) {
    showDialog(
      context: context,
      builder: (context) => AddServiceToOrderWidget(
        isTable: false,
        id: invoice.id,
        onSuccess: () {
          invoicesCubit.getInvoices(selectedPage);
        }, restaurant: widget.restaurant,
      ),
    );
  }

  @override
  void onAddTap() {
    showDialog(
      context: context,
      builder: (context) => AddInvoiceView(
        selectedPage: selectedPage,
        invoicesCubit: invoicesCubit,
        restaurant: widget.restaurant,
      ),
    );
  }

  @override
  void onUpdateStatusInvoicePaidTap(DrvierInvoiceModel invoice, int index) {
    invoicesCubit.updateStatusToPaid(invoice.id, index);
  }

  @override
  void onTableSelected(TableModel? table) {
    invoicesCubit.setTableId(table);
    invoicesCubit.getInvoices(selectedPage);
  }

  @override
  void onWaiterSelected(AdminModel? waiter) {
    invoicesCubit.setAdminId(waiter);
    invoicesCubit.getInvoices(selectedPage);
  }

  @override
  void onUpdateStatusInvoiceReceivedTap(DrvierInvoiceModel invoice, int index) {
    takeoutOrdersCubit.updateStatusToRecieved(invoice.id, index);
  }

  @override
  Future<void> onDateSelected() async {
    final dateTime = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );
    if (dateTime != null) {
      setState(() {
        selectedDate = dateTime;
        selectedMonth = dateTime.month.toString();
        selectedDay = dateTime.day.toString();
        selectedYear = dateTime.year.toString();
        dateController.text = "$selectedMonth/$selectedDay/$selectedYear";
      });
      invoicesCubit.setDate(
        Utils.convertToIsoFormat(dateController.text),
      );
      invoicesCubit.getInvoices(selectedPage);
    }
  }

  @override
  Future<void> onRefresh() async {
    invoicesCubit.resetParams();
    dateController.text = "mm/dd/yyyy";
    invoicesCubit.getInvoices(selectedPage);
    invoicesCubit.getWaiters();
    itemsCubit.getTables();
    customerServiceCubit.getServices();
  }

  @override
  void onTryAgainTap() {
    invoicesCubit.getInvoices(selectedPage);
    invoicesCubit.getWaiters();
    itemsCubit.getTables();
    customerServiceCubit.getServices();
  }

  @override
  void onSelectPageTap(int page) {
    if (selectedPage != page) {
      setState(() {
        selectedPage = page;
      });
      invoicesCubit.getInvoices(page);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(restaurant: widget.restaurant, title: "invoices".tr()),
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
                if (isShowFilters) _buildFilters(),
                BlocBuilder<InvoicesCubit, GeneralInvoicesState>(
                  buildWhen: (previous, current) => current is InvoicesState,
                  builder: (context, state) {
                    if (state is InvoicesLoading) {
                      return const LoadingIndicator(color: AppColors.black);
                    } else if (state is InvoicesSuccess) {
                      return _buildTablesView(state.paginatedModel);
                    } else if (state is InvoicesEmpty) {
                      return Center(child: Text(state.message));
                    } else if (state is InvoicesFail) {
                      return Center(
                        child: MainErrorWidget(
                          error: state.error,
                          onTryAgainTap: onTryAgainTap,
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloatingButtons(),
    );
  }

  Widget _buildFilters() {
    return Column(
      children: [
        MainTextField(
          controller: dateController,
          labelText: "date".tr(),
          readOnly: true,
          onTap: onDateSelected,
          onClearTap: () {
            invoicesCubit.setDate(null);
            setState(() {
              dateController.text = "mm/dd/yyyy";
            });
            invoicesCubit.getInvoices(selectedPage);
          },
          showCloseIcon: dateController.text != "mm/dd/yyyy",
          suffixIcon: IconButton(
            onPressed: onDateSelected,
            icon: const Icon(Icons.calendar_today),
          ),
        ),
        const SizedBox(height: 10),
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
                  error: state.error, onTryAgainTap: onTryAgainTap);
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        const SizedBox(height: 10),
        BlocBuilder<InvoicesCubit, GeneralInvoicesState>(
          buildWhen: (previous, current) => current is WaitersState,
          builder: (context, state) {
            if (state is WaitersLoading) {
              return const LoadingIndicator(color: AppColors.black);
            } else if (state is WaitersSuccess) {
              return MainDropDownWidget(
                items: state.waiters,
                text: "waiter".tr(),
                onChanged: onWaiterSelected,
                focusNode: FocusNode(),
              );
            } else if (state is WaitersFail) {
              return MainErrorWidget(
                error: state.error,
                onTryAgainTap: onTryAgainTap,
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTablesView(PaginatedModel<DrvierInvoiceModel> invoices) {
    final List<String> titles = [
      "invoice_num".tr(),
      "total_price".tr(),
      "table_num".tr(),
      "waiter_name".tr(),
      "invoice_created_at".tr(),
      "status".tr(),
      "event".tr(),
    ];

    final permissions = widget.permissions.map((e) => e.name).toSet();
    final isEdit = permissions.contains("order.update");
    final isAddService = permissions.contains("service.add");

    List<DataRow> rows = [];
    rows = List.generate(
      invoices.data.length,
          (index) {
        final invoice = invoices.data[index];
        final values = [
          Text(invoice.number.toString()),
          Text(invoice.total ?? "_"),
          Text(invoice.tableNumber?.toString() ?? "_"),
          Text(invoice.waiter ?? "_"),
          Text(invoice.createdAt),
          Text(invoice.status ?? "_"),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => onShowDetails(invoice),
                child: const Icon(Icons.remove_red_eye),
              ),
              const SizedBox(width: 10),
              if (isEdit)
                BlocConsumer<InvoicesCubit, GeneralInvoicesState>(
                  listener: (context, state) {
                    if (state is UpdateStatusToPaidSuccess &&
                        state.index == index) {
                      MainSnackBar.showSuccessMessage(context, state.message);
                      invoicesCubit.getInvoices(selectedPage);
                    } else if (state is UpdateStatusToPaidFail &&
                        state.index == index) {
                      MainSnackBar.showErrorMessage(context, state.error);
                    }
                  },
                  builder: (context, state) {
                    var onTap = onUpdateStatusInvoicePaidTap;
                    Widget child = const Icon(Icons.edit_outlined);
                    if (state is UpdateStatusToPaidLoading &&
                        state.index == index) {
                      onTap = (driver, index) {};
                      child = const LoadingIndicator(
                        size: 20,
                        color: AppColors.black,
                      );
                    }
                    return InkWell(
                      onTap: () => onTap(invoice, index),
                      child: child,
                    );
                  },
                ),
              if (isEdit) const SizedBox(width: 10),
              if (isEdit)
                BlocConsumer<TakeoutOrdersCubit, GeneralTakeoutOrdersState>(
                  listener: (context, state) {
                    if (state is UpdateStatusToReceivedSuccess &&
                        state.index == index) {
                      MainSnackBar.showSuccessMessage(context, state.message);
                      invoicesCubit.getInvoices(selectedPage);
                    } else if (state is UpdateStatusToReceivedFail &&
                        state.index == index) {
                      MainSnackBar.showErrorMessage(context, state.error);
                    }
                  },
                  builder: (context, state) {
                    var onTap = onUpdateStatusInvoiceReceivedTap;
                    Widget child = const Icon(FontAwesomeIcons.handHolding);
                    if (state is UpdateStatusToReceivedLoading &&
                        state.index == index) {
                      onTap = (driver, index) {};
                      child = const LoadingIndicator(
                        size: 20,
                        color: AppColors.black,
                      );
                    }
                    return InkWell(
                      onTap: () => onTap(invoice, index),
                      child: child,
                    );
                  },
                ),
              if (isEdit) const SizedBox(width: 10),
              if (isAddService)
                InkWell(
                  onTap: () => onAddSeriveTap(invoice),
                  child: const Icon(Icons.settings),
                ),
              if (isAddService) const SizedBox(width: 10),
            ],
          )
        ];
        return DataRow(
          cells: List.generate(
            values.length,
                (index2) => DataCell(Center(child: values[index2])),
          ),
        );
      },
    );
    return Column(
      children: [
        MainDataTable(
          titles: titles,
          rows: rows,
          color: widget.restaurant.color,
        ),
        SelectPageTile(
          length: invoices.meta.totalPages,
          selectedPage: selectedPage,
          onSelectPageTap: onSelectPageTap,
        ),
      ],
    );
  }

  Widget _buildFloatingButtons() {
    final permissions = widget.permissions.map((e) => e.name).toSet();
    final isAdd = permissions.contains("order.add");
    final isExcel = permissions.contains("excel");
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (isExcel) ...[
              const SizedBox(width: 30),
              BlocBuilder<InvoicesCubit, GeneralInvoicesState>(
                buildWhen: (previous, current) => current is InvoicesState,
                builder: (context, state) {
                  if (state is InvoicesSuccess) {
                    final invoices = state.paginatedModel.data;
                    return MainActionButton(
                      padding: AppConstants.padding14,
                      buttonColor: widget.restaurant.color,
                      onPressed: () => onExportToExcelTap(invoices),
                      text: "export_excel".tr(),
                      icon: const Icon(
                        FontAwesomeIcons.fileExcel,
                        color: AppColors.white,
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
            const Spacer(),
            if (isAdd)
              MainAddButton(onTap: onAddTap, color: widget.restaurant.color),
            const SizedBox(width: 10),
            MainActionButton(
              padding: AppConstants.padding10,
              onPressed: onShowFilters,
              text: "text",
              buttonColor: widget.restaurant.color,
              child: const Icon(
                Icons.filter_alt,
                color: AppColors.white,
                size: 30,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
