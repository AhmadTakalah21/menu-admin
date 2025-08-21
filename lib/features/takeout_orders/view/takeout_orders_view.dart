import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:user_admin/features/drivers/cubit/drivers_cubit.dart';
import 'package:user_admin/features/drivers/model/drvier_invoice_model/drvier_invoice_model.dart';
import 'package:user_admin/features/takeout_orders/cubit/takeout_orders_cubit.dart';
import 'package:user_admin/features/takeout_orders/view/widgets/edit_driver_of_order.dart';
import 'package:user_admin/global/model/paginated_model/paginated_model.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/model/role_model/role_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/invoice_widget.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_app_bar.dart';
import 'package:user_admin/global/widgets/main_data_table.dart';
import 'package:user_admin/global/widgets/main_drawer.dart';
import 'package:user_admin/global/widgets/main_error_widget.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';
import 'package:user_admin/global/widgets/select_page_tile.dart';

abstract class TakeoutOrdersViewCallBacks {
  Future<void> onRefresh();
  void onEditTap(DrvierInvoiceModel invoice);
  void onShowInvoice(DrvierInvoiceModel invoice);
  void onUpdateStatusToReceived(DrvierInvoiceModel invoice, int index);
  void onSelectPageTap(int page);
  void onTryAgainTap();
}

class TakeoutOrdersView extends StatelessWidget {
  const TakeoutOrdersView({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return TakeoutOrdersPage(permissions: permissions, restaurant: restaurant);
  }
}

class TakeoutOrdersPage extends StatefulWidget {
  const TakeoutOrdersPage({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  State<TakeoutOrdersPage> createState() => _TakeoutOrdersPageState();
}

class _TakeoutOrdersPageState extends State<TakeoutOrdersPage>
    implements TakeoutOrdersViewCallBacks {
  late final DriversCubit driversCubit = context.read();
  late final TakeoutOrdersCubit takeoutOrdersCubit = context.read();
  int selectedPage = 1;

  @override
  void initState() {
    super.initState();
    takeoutOrdersCubit.getTakeoutOrders(1);
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
  void onEditTap(DrvierInvoiceModel invoice) {
    showDialog(
      context: context,
      builder: (context) {
        return EditDriverOfOrder(invoice: invoice);
      },
    );
  }

  @override
  void onUpdateStatusToReceived(DrvierInvoiceModel invoice, int index) {
    takeoutOrdersCubit.updateStatusToRecieved(invoice.id, index);
  }

  @override
  Future<void> onRefresh() async {
    takeoutOrdersCubit.getTakeoutOrders(1);
    driversCubit.getDrivers(isActive: true, isRefresh: true);
    setState(() {
      selectedPage = 1;
    });
  }

  @override
  void onTryAgainTap() {
    takeoutOrdersCubit.getTakeoutOrders(1);
    driversCubit.getDrivers(isActive: true, isRefresh: true);
    setState(() {
      selectedPage = 1;
    });
  }

  @override
  void onSelectPageTap(int page) {
    if (selectedPage != page) {
      setState(() {
        selectedPage = page;
      });
      takeoutOrdersCubit.getTakeoutOrders(page);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        restaurant: widget.restaurant,
        title: "takeout_orders".tr(),
        onSearchChanged: (q) => takeoutOrdersCubit.searchByName(q),
        onSearchSubmitted: (q) => takeoutOrdersCubit.searchByName(q),
        onSearchClosed: () => takeoutOrdersCubit.searchByName(''),
        onLanguageToggle: (loc) {
        },
      ),
      drawer: MainDrawer(
        permissions: widget.permissions,
        restaurant: widget.restaurant,
      ),
      body: BlocBuilder<TakeoutOrdersCubit, GeneralTakeoutOrdersState>(
        buildWhen: (previous, current) => current is TakeoutOrdersState,
        builder: (context, state) {
          if (state is TakeoutOrdersLoading) {
            return const LoadingIndicator(color: AppColors.black);
          } else if (state is TakeoutOrdersSuccess) {
            return _buildTableView(state.paginatedModel);
          } else if (state is TakeoutOrdersEmpty) {
            return MainErrorWidget(
              error: state.message,
              isRefresh: true,
              onTryAgainTap: onTryAgainTap,
            );
          } else if (state is TakeoutOrdersFail) {
            return MainErrorWidget(
              error: state.error,
              onTryAgainTap: onTryAgainTap,
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildTableView(PaginatedModel<DrvierInvoiceModel> invoices) {
    bool isEdit = widget.permissions.any((e) => e.name == "delivery.update");
    final List<String> titles = [
      "customer_name".tr(),
      "driver_name".tr(),
      "address".tr(),
      "phone_number".tr(),
      "created_at".tr(),
      "recieved_at".tr(),
      "delivery_price".tr(),
      "status".tr(),
      "event".tr(),
    ];
    List<DataRow> rows = [];
    rows = List.generate(
      invoices.data.length,
          (index) {
        final invoice = invoices.data[index];
        final values = [
          Text(invoice.user ?? "_"),
          Text(invoice.deliveryName ?? "_"),
          Text(invoice.region ?? "_"),
          Text(invoice.userPhone ?? "_"),
          Text(invoice.createdAt),
          Text(invoice.receivedAt ?? "_"),
          Text(invoice.deliveryPrice ?? "_"),
          Text(invoice.status ?? "_"),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isEdit)
                InkWell(
                  onTap: () => onEditTap(invoice),
                  child: const Icon(Icons.edit_outlined),
                ),
              if (isEdit) const SizedBox(width: 10),
              InkWell(
                onTap: () => onShowInvoice(invoice),
                child: const Icon(Icons.remove_red_eye),
              ),
              const SizedBox(width: 10),
              if (isEdit) _buildUpdateToReceivedBtn(index, invoice),
              if (isEdit) const SizedBox(width: 10),
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
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: AppConstants.padding16,
        child: Column(
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
        ),
      ),
    );
  }

  Widget _buildUpdateToReceivedBtn(int index, DrvierInvoiceModel invoice) {
    return BlocConsumer<TakeoutOrdersCubit, GeneralTakeoutOrdersState>(
      listener: (context, state) {
        if (state is UpdateStatusToReceivedSuccess && state.index == index) {
          takeoutOrdersCubit.getTakeoutOrders(1);
          MainSnackBar.showSuccessMessage(context, state.message);
        } else if (state is UpdateStatusToReceivedFail &&
            state.index == index) {
          MainSnackBar.showErrorMessage(context, state.error);
        }
      },
      builder: (context, state) {
        var onTap = onUpdateStatusToReceived;
        Widget child = const Icon(FontAwesomeIcons.handHolding);
        if (state is UpdateStatusToReceivedLoading && state.index == index) {
          onTap = (driver, index) {};
          child = const LoadingIndicator(size: 20, color: AppColors.black);
        }
        return InkWell(onTap: () => onTap(invoice, index), child: child);
      },
    );
  }
}
