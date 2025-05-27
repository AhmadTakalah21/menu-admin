import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/drivers/cubit/drivers_cubit.dart';
import 'package:user_admin/features/drivers/model/driver_model/driver_model.dart';
import 'package:user_admin/features/drivers/model/drvier_invoice_model/drvier_invoice_model.dart';
import 'package:user_admin/features/sign_in/model/sign_in_model/sign_in_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/invoice_widget.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_back_button.dart';
import 'package:user_admin/global/widgets/main_data_table.dart';
import 'package:user_admin/global/widgets/main_drawer.dart';
import 'package:user_admin/global/widgets/main_error_widget.dart';
import 'package:user_admin/global/widgets/select_page_tile.dart';

abstract class DriverInvoicesViewCallBacks {
  void onShowInvoice(DrvierInvoiceModel invoice);

  void onSelectPageTap(int page);

  Future<void> onRefresh();

  void onTryAgainTap();
}

class DriverInvoicesView extends StatelessWidget {
  const DriverInvoicesView({
    super.key,
    required this.driver,
    required this.signInModel,
  });

  final DriverModel driver;
  final SignInModel signInModel;

  @override
  Widget build(BuildContext context) {
    return DriverInvoicesPage(
      driver: driver,
      signInModel: signInModel,
    );
  }
}

class DriverInvoicesPage extends StatefulWidget {
  const DriverInvoicesPage({
    super.key,
    required this.driver,
    required this.signInModel,
  });

  final SignInModel signInModel;
  final DriverModel driver;

  @override
  State<DriverInvoicesPage> createState() => _DriverInvoicesPageState();
}

class _DriverInvoicesPageState extends State<DriverInvoicesPage>
    implements DriverInvoicesViewCallBacks {
  late final DriversCubit driversCubit = context.read();

  int selectedPage = 1;

  @override
  void initState() {
    super.initState();
    driversCubit.getDriverInvoices(widget.driver.id, page: selectedPage);
  }

  @override
  void onShowInvoice(DrvierInvoiceModel invoice) {
    showDialog(
      context: context,
      builder: (context) {
        return InvoiceWidget(invoice: invoice);
      },
    );
  }

  @override
  void onSelectPageTap(int page) {
    if (selectedPage != page) {
      setState(() {
        selectedPage = page;
      });
      driversCubit.getDriverInvoices(widget.driver.id, page: page);
    }
  }

  @override
  Future<void> onRefresh() async {
    driversCubit.getDriverInvoices(widget.driver.id);
  }

  @override
  void onTryAgainTap() {
    driversCubit.getDriverInvoices(widget.driver.id, page: selectedPage);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> titles = [
      "invoice_num".tr(),
      "username".tr(),
      "created_at".tr(),
      "recieved_at".tr(),
      "status".tr(),
      "event".tr(),
    ];
    final restColor = widget.signInModel.restaurant.color;

    return Scaffold(
      appBar: AppBar(),
      drawer: MainDrawer(signInModel: widget.signInModel),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: AppConstants.paddingH16,
                child: MainBackButton(color: restColor ?? AppColors.black),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: AppConstants.paddingH16,
                child: Text(
                  "drivers_invoices".tr(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              BlocBuilder<DriversCubit, GeneralDriversState>(
                buildWhen: (previous, current) =>
                    current is DriverInvoicesState,
                builder: (context, state) {
                  List<DataRow> rows = [];
                  if (state is DriverInvoicesLoading) {
                    return const LoadingIndicator(color: AppColors.black);
                  } else if (state is DriverInvoicesSuccess) {
                    rows = List.generate(
                      state.invoices.data.length,
                      (index) {
                        final invoice = state.invoices.data[index];
                        final values = [
                          Text(invoice.number.toString()),
                          Text(invoice.username ?? "_"),
                          Text(invoice.createdAt),
                          Text(invoice.receivedAt ?? "_"),
                          MainActionButton(
                            padding: AppConstants.padding6,
                            onPressed: () {},
                            text: invoice.status ?? "_",
                            buttonColor: AppColors.mainColor,
                          ),
                          InkWell(
                            onTap: () => onShowInvoice(invoice),
                            child: const Icon(Icons.remove_red_eye),
                          )
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
                          length: state.invoices.meta.totalPages,
                          selectedPage: selectedPage,
                          onSelectPageTap: onSelectPageTap,
                        ),
                      ],
                    );
                  } else if (state is DriverInvoicesEmpty) {
                    return Center(child: Text(state.message));
                  } else if (state is DriverInvoicesFail) {
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
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
