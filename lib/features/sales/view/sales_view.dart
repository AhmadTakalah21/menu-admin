import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:user_admin/features/sales/cubit/sales_cubit.dart';
import 'package:user_admin/features/tables/model/order_details_model/order_details_model.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/model/role_model/role_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/utils/utils.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_back_button.dart';
import 'package:user_admin/global/widgets/main_data_table.dart';
import 'package:user_admin/global/widgets/main_drawer.dart';
import 'package:user_admin/global/widgets/main_error_widget.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';
import 'package:user_admin/global/widgets/main_text_field.dart';
import 'package:user_admin/global/widgets/select_page_tile.dart';

abstract class SalesViewCallBacks {
  Future<void> onRefresh();
  Future<void> onStartDateSelected();
  Future<void> onEndDateSelected();
  void onShowFilters();
  void onSearchSubmitted(String search);
  void onSearchChanged(String search);
  void onSelectPageTap(int page);
  Future<void> onExportToExcelTap(List<OrderDetailsModel> orders);
  void onTryAgainTap();
}

class SalesView extends StatelessWidget {
  const SalesView({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return SalesPage(permissions: permissions, restaurant: restaurant);
  }
}

class SalesPage extends StatefulWidget {
  const SalesPage({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> implements SalesViewCallBacks {
  late final SalesCubit salesCubit = context.read();
  int selectedPage = 1;

  bool isShowFilters = false;

  final startDateController = TextEditingController();
  final endDateController = TextEditingController();

  String selectedStartMonth = "mm";
  String selectedStartDay = "dd";
  String selectedStartYear = "yyyy";

  String selectedEndMonth = "mm";
  String selectedEndDay = "dd";
  String selectedEndYear = "yyyy";

  @override
  void initState() {
    super.initState();
    salesCubit.getSales(selectedPage);
    startDateController.text =
        "$selectedStartMonth/$selectedStartDay/$selectedStartYear";
    endDateController.text =
        "$selectedEndMonth/$selectedEndDay/$selectedEndYear";
  }

  @override
  Future<void> onEndDateSelected() async {
    final dateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );
    if (dateTime != null) {
      setState(() {
        selectedEndMonth = dateTime.month.toString();
        selectedEndDay = dateTime.day.toString();
        selectedEndYear = dateTime.year.toString();
        endDateController.text =
            "$selectedEndMonth/$selectedEndDay/$selectedEndYear";
      });
      salesCubit.setEndDate(
        Utils.convertToIsoFormat(endDateController.text),
      );
      salesCubit.getSales(selectedPage);
    }
  }

  @override
  Future<void> onStartDateSelected() async {
    final dateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );
    if (dateTime != null) {
      setState(() {
        selectedStartMonth = dateTime.month.toString();
        selectedStartDay = dateTime.day.toString();
        selectedStartYear = dateTime.year.toString();
        startDateController.text =
            "$selectedStartMonth/$selectedStartDay/$selectedStartYear";
      });
      salesCubit.setStartDate(
        Utils.convertToIsoFormat(startDateController.text),
      );
      salesCubit.getSales(selectedPage);
    }
  }

  @override
  void onSearchSubmitted(String search) {
    salesCubit.setSearch(search);
    salesCubit.getSales(selectedPage);
  }

  @override
  void onSearchChanged(String search) {
    if (search.isEmpty) {
      salesCubit.setSearch(search);
      salesCubit.getSales(selectedPage);
    }
  }

  @override
  void onShowFilters() {
    setState(() {
      isShowFilters = !isShowFilters;
    });
  }

  @override
  Future<void> onExportToExcelTap(List<OrderDetailsModel> orders) async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
    }

    List<List<CellValue?>> list = [
      [
        TextCellValue("product_name".tr()),
        TextCellValue("price".tr()),
        TextCellValue("count".tr()),
        TextCellValue("created_at".tr()),
      ],
    ];
    final listOfData = List.generate(
      orders.length,
      (index) {
        return [
          TextCellValue(orders[index].name),
          TextCellValue(orders[index].price.toString()),
          TextCellValue(orders[index].count.toString()),
          TextCellValue(orders[index].createdAt),
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

    String outputFile = "${directory!.path}/${"sales".tr()}.xlsx";

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
  Future<void> onRefresh() async {
    startDateController.text = "mm/dd/yyyy";
    endDateController.text = "mm/dd/yyyy";

    salesCubit.resetParams();
    salesCubit.getSales(selectedPage);
  }

  @override
  void onTryAgainTap() {
    salesCubit.getSales(selectedPage);
  }

  @override
  void onSelectPageTap(int page) {
    if (selectedPage != page) {
      setState(() {
        selectedPage = page;
      });
      salesCubit.getSales(page);
    }
  }

  @override
  Widget build(BuildContext context) {
    int excelIndex = widget.permissions.indexWhere(
      (element) => element.name == "excel",
    );
    bool isExcel = excelIndex != -1;

    final List<String> titles = [
      "product_name".tr(),
      "price".tr(),
      "count".tr(),
      "created_at".tr(),
    ];
    final restColor = widget.restaurant.color;

    return Scaffold(
      appBar: AppBar(),
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
                MainBackButton(color: restColor!),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      "orders".tr(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    if (isExcel)
                      BlocBuilder<SalesCubit, GeneralSalesState>(
                        buildWhen: (previous, current) => current is SalesState,
                        builder: (context, state) {
                          if (state is SalesSuccess) {
                            final sales = state.paginatedModel.data;
                            return MainActionButton(
                              padding: AppConstants.padding10,
                              onPressed: () => onExportToExcelTap(sales),
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
                    const SizedBox(width: 10),
                    MainActionButton(
                      padding: AppConstants.padding10,
                      onPressed: onRefresh,
                      text: "",
                      child: const Icon(Icons.refresh, color: AppColors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: AppConstants.paddingH20,
                  child: MainActionButton(
                    padding: AppConstants.padding4,
                    onPressed: onShowFilters,
                    text: "text",
                    child: const Icon(
                      Icons.filter_alt,
                      color: AppColors.white,
                      size: 30,
                    ),
                  ),
                ),
                if (isShowFilters)
                  Padding(
                    padding: AppConstants.paddingH20,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        MainTextField(
                          hintText: "search".tr(),
                          onChanged: onSearchChanged,
                          onSubmitted: onSearchSubmitted,
                        ),
                        const SizedBox(height: 20),
                        MainTextField(
                          controller: startDateController,
                          labelText: "start_date".tr(),
                          readOnly: true,
                          onTap: onStartDateSelected,
                          onClearTap: () {
                            salesCubit.setStartDate(null);
                            setState(() {
                              startDateController.text = "mm/dd/yyyy";
                            });
                            salesCubit.getSales(selectedPage);
                          },
                          showCloseIcon:
                              startDateController.text != "mm/dd/yyyy",
                          suffixIcon: IconButton(
                            onPressed: onStartDateSelected,
                            icon: const Icon(Icons.calendar_today),
                          ),
                        ),
                        const SizedBox(height: 20),
                        MainTextField(
                          controller: endDateController,
                          labelText: "end_date".tr(),
                          readOnly: true,
                          onTap: onEndDateSelected,
                          onClearTap: () {
                            salesCubit.setEndDate(null);
                            setState(() {
                              endDateController.text = "mm/dd/yyyy";
                            });
                            salesCubit.getSales(selectedPage);
                          },
                          showCloseIcon: endDateController.text != "mm/dd/yyyy",
                          suffixIcon: IconButton(
                            onPressed: onEndDateSelected,
                            icon: const Icon(Icons.calendar_today),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                Center(
                  child: BlocBuilder<SalesCubit, GeneralSalesState>(
                    buildWhen: (previous, current) => current is SalesState,
                    builder: (context, state) {
                      if (state is SalesLoading) {
                        return const LoadingIndicator(color: AppColors.black);
                      } else if (state is SalesSuccess) {
                        List<DataRow> rows = [];
                        rows = List.generate(
                          state.paginatedModel.data.length,
                          (index) {
                            final order = state.paginatedModel.data[index];
                            final values = [
                              Text(order.name),
                              Text(order.price.toString()),
                              Text(order.count.toString()),
                              Text(order.createdAt),
                            ];
                            return DataRow(
                              cells: List.generate(
                                values.length,
                                (index2) {
                                  return DataCell(
                                    Center(child: values[index2]),
                                  );
                                },
                              ),
                            );
                          },
                        );
                        return Column(
                          children: [
                            MainDataTable(titles: titles, rows: rows),
                            SelectPageTile(
                              length: state.paginatedModel.meta.totalPages,
                              selectedPage: selectedPage,
                              onSelectPageTap: onSelectPageTap,
                            ),
                          ],
                        );
                      } else if (state is SalesEmpty) {
                        return Center(child: Text(state.message));
                      } else if (state is SalesFail) {
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
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
