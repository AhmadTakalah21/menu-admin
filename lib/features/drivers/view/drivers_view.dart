import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:user_admin/features/app_manager/cubit/app_manager_cubit.dart';
import 'package:user_admin/features/drivers/cubit/drivers_cubit.dart';
import 'package:user_admin/features/drivers/model/driver_model/driver_model.dart';
import 'package:user_admin/features/drivers/view/driver_invoices_view.dart';
import 'package:user_admin/features/drivers/view/widgets/add_driver_widget.dart';
import 'package:user_admin/features/drivers/view/widgets/map_view.dart';
import 'package:user_admin/global/blocs/delete_cubit/cubit/delete_cubit.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/model/role_model/role_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/insure_delete_widget.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_back_button.dart';
import 'package:user_admin/global/widgets/main_data_table.dart';
import 'package:user_admin/global/widgets/main_drawer.dart';
import 'package:user_admin/global/widgets/main_error_widget.dart';
import 'package:user_admin/global/widgets/select_page_tile.dart';

import '../../../global/widgets/main_app_bar.dart';

abstract class DriversViewCallBacks {
  void onAddTap();
  void onEditTap(DriverModel driver);
  void onShowMapTap(DriverModel driver);
  void onDeleteTap(DriverModel driver);
  void onSaveDeleteTap(DriverModel driver);
  void onSaveActivateTap(DriverModel driver);
  void onActivateTap(DriverModel driver);
  void onShowDriverInvoices(DriverModel driver);
  void onSelectPageTap(int page);
  Future<void> onRefresh();
  void onTryAgainTap();
}

class DriversView extends StatelessWidget {
  const DriversView({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return CouponsPage(permissions: permissions, restaurant: restaurant);
  }
}

class CouponsPage extends StatefulWidget {
  const CouponsPage({
    super.key,
    required this.permissions,
    required this.restaurant,
  });

  final List<RoleModel> permissions;
  final RestaurantModel restaurant;

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage>
    implements DriversViewCallBacks {
  late final DriversCubit driversCubit = context.read();
  late final DeleteCubit deleteCubit = context.read();

  late final StreamSubscription<List<ConnectivityResult>> subscription;

  int selectedPage = 1;

  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if (result.isNotEmpty && !result.contains(ConnectivityResult.none)) {
        driversCubit.getDrivers(
          isActive: false,
          isRefresh: true,
          page: selectedPage,
        );
      } else {
        driversCubit.getDrivers(
          isActive: false,
          isRefresh: false,
          page: selectedPage,
        );
      }
    });
  }

  @override
  void onAddTap() {
    showDialog(
      context: context,
      builder: (context) => AddDriverWidget(
        permissions: widget.permissions,
        restaurant: widget.restaurant,
        isEdit: false,
      ),
    );
  }

  @override
  void onShowMapTap(DriverModel driver) {
    LatLng? initialPosition;
    final lat = driver.latitude;
    final long = driver.longitude;
    if (lat != null && long != null) {
      initialPosition = LatLng(double.parse(lat), double.parse(long));
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapView(
          initialPosition: initialPosition,
        ),
      ),
    );
  }

  @override
  void onDeleteTap(DriverModel driver) {
    showDialog(
      context: context,
      builder: (context) {
        return InsureDeleteWidget(
          isDelete: true,
          item: driver,
          onSaveTap: onSaveDeleteTap,
        );
      },
    );
  }

  @override
  void onSaveDeleteTap(DriverModel driver) {
    deleteCubit.deleteItem<DriverModel>(driver);
  }

  @override
  void onActivateTap(DriverModel driver) {
    showDialog(
      context: context,
      builder: (context) {
        return InsureDeleteWidget(
          isDelete: false,
          item: driver,
          onSaveTap: onSaveActivateTap,
        );
      },
    );
  }

  @override
  void onSaveActivateTap(DriverModel driver) {
    deleteCubit.deactivateItem<DriverModel>(driver);
  }

  @override
  void onEditTap(DriverModel driver) {
    showDialog(
      context: context,
      builder: (context) => AddDriverWidget(
        permissions: widget.permissions,
        restaurant: widget.restaurant,
        isEdit: true,
        driver: driver,
      ),
    );
  }

  @override
  void onShowDriverInvoices(DriverModel driver) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DriverInvoicesView(
          driver: driver,
          permissions: widget.permissions,
          restaurant: widget.restaurant,
        ),
      ),
    );
  }

  @override
  void onSelectPageTap(int page) {
    if (selectedPage != page) {
      setState(() {
        selectedPage = page;
      });
      driversCubit.getDrivers(
        isActive: false,
        isRefresh: true,
        page: selectedPage,
      );
    }
  }

  @override
  Future<void> onRefresh() async {
    driversCubit.getDrivers(
      isActive: false,
      isRefresh: true,
      page: selectedPage,
    );
  }

  @override
  void onTryAgainTap() {
    driversCubit.getDrivers(
      isActive: false,
      isRefresh: true,
      page: selectedPage,
    );
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> titles = [
      "name".tr(),
      "account_name".tr(),
      "phone_number".tr(),
      "birthday".tr(),
      "status".tr(),
    ];
    final permissions =
        widget.permissions.map((e) => e.name).toSet();

    final isAdd = permissions.contains("delivery.add");
    final isEdit = permissions.contains("delivery.update");
    final isDelete = permissions.contains("delivery.delete");
    final isActive = permissions.contains("delivery.active");
    final isOrder = permissions.contains("order.index");

    if (isEdit || isDelete || isActive || isOrder) {
      titles.add("event".tr());
    }

    final restColor = widget.restaurant.color;

    return BlocListener<AppManagerCubit, AppManagerState>(
      listener: (context, state) {
        if (state is DeletedState) {
          driversCubit.getDrivers(
            isActive: false,
            isRefresh: true,
            page: selectedPage,
          );
        }
      },
      child: Scaffold(
        appBar: MainAppBar(restaurant: widget.restaurant, title: "drivers".tr()),
        drawer: MainDrawer(
          permissions: widget.permissions,
          restaurant: widget.restaurant,
        ),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: AppConstants.paddingH16,
                  child: MainBackButton(color: restColor!),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: AppConstants.paddingH16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "drivers".tr(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      MainActionButton(
                        padding: AppConstants.padding10,
                        onPressed: onRefresh,
                        text: "",
                        child:
                            const Icon(Icons.refresh, color: AppColors.white),
                      ),
                      if (isAdd) const SizedBox(width: 10),
                      if (isAdd)
                        MainActionButton(
                          padding: AppConstants.padding10,
                          onPressed: onAddTap,
                          text: "add_driver".tr(),
                          child: const Icon(
                            Icons.add_circle,
                            color: AppColors.white,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                BlocBuilder<DriversCubit, GeneralDriversState>(
                  buildWhen: (previous, current) => current is DriversState,
                  builder: (context, state) {
                    List<DataRow> rows = [];
                    if (state is DriversLoading) {
                      return const LoadingIndicator(color: AppColors.black);
                    } else if (state is DriversSuccess) {
                      rows = List.generate(
                        state.drivers.data.length,
                        (index) {
                          final driver = state.drivers.data[index];
                          final values = [
                            Text(driver.name),
                            Text(driver.username),
                            Text(driver.phone),
                            Text(driver.birthday ?? "_"),
                            MainActionButton(
                              padding: AppConstants.padding6,
                              onPressed: () {},
                              text: driver.isActive
                                  ? "active".tr()
                                  : "inactive".tr(),
                              buttonColor: driver.isActive
                                  ? AppColors.greenShade
                                  : AppColors.red,
                            ),
                            if (isEdit || isDelete || isActive || isOrder)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isOrder)
                                    InkWell(
                                      onTap: () => onShowDriverInvoices(driver),
                                      child: const Icon(
                                          FontAwesomeIcons.fileInvoice),
                                    ),
                                  if (isOrder) const SizedBox(width: 10),
                                  if (isDelete)
                                    InkWell(
                                      onTap: () => onDeleteTap(driver),
                                      child: const Icon(Icons.delete),
                                    ),
                                  if (isDelete) const SizedBox(width: 10),
                                  if (isEdit)
                                    InkWell(
                                      onTap: () => onEditTap(driver),
                                      child: const Icon(Icons.edit_outlined),
                                    ),
                                  if (isEdit) const SizedBox(width: 10),
                                  if (isActive)
                                    InkWell(
                                      onTap: () => onActivateTap(driver),
                                      child: Icon(
                                        driver.isActive
                                            ? Icons.block
                                            : Icons.check_circle,
                                        size: 30,
                                      ),
                                    ),
                                  if (isActive) const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () => onShowMapTap(driver),
                                    child: const Icon(Icons.location_on),
                                  ),
                                ],
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
                            length: state.drivers.meta.totalPages,
                            selectedPage: selectedPage,
                            onSelectPageTap: onSelectPageTap,
                          ),
                        ],
                      );
                    } else if (state is DriversEmpty) {
                      return Text(state.message);
                    } else if (state is DriversFail) {
                      return MainErrorWidget(
                        error: state.error,
                        onTryAgainTap: onTryAgainTap,
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
      ),
    );
  }
}
