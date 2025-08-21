import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:user_admin/features/app_manager/cubit/app_manager_cubit.dart';
import 'package:user_admin/features/drivers/cubit/drivers_cubit.dart';
import 'package:user_admin/features/drivers/model/driver_model/driver_model.dart';
import 'package:user_admin/features/drivers/view/driver_invoices_view.dart';
import 'package:user_admin/features/drivers/view/widgets/add_driver_widget.dart';
import 'package:user_admin/features/drivers/view/widgets/map_view.dart';
import 'package:user_admin/global/blocs/delete_cubit/cubit/delete_cubit.dart';
import 'package:user_admin/global/model/paginated_model/paginated_model.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/model/role_model/role_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/widgets/insure_delete_widget.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_action_button.dart';
import 'package:user_admin/global/widgets/main_add_button.dart';
import 'package:user_admin/global/widgets/main_app_bar.dart';
import 'package:user_admin/global/widgets/main_data_table.dart';
import 'package:user_admin/global/widgets/main_drawer.dart';
import 'package:user_admin/global/widgets/main_error_widget.dart';
import 'package:user_admin/global/widgets/more_options_widget.dart';
import 'package:user_admin/global/widgets/select_page_tile.dart';
import 'package:user_admin/global/widgets/switch_view_button.dart';

import '../../../global/widgets/main_show_details_widget.dart';

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
  void onShowDetails(DriverModel driver);
  void onMoreOptionsTap(DriverModel driver, bool isActive);
  void onSwichViewTap();
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
  bool isCardView = true;

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
    final inv = (driver.invoice.isNotEmpty) ? driver.invoice.first : null;
    if (inv == null || inv.lat == null || inv.lon == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يوجد موقع للزبون في الفاتورة')),
      );
      return;
    }

    final driverPos = (driver.driverLat != null && driver.driverLon != null)
        ? LatLng(driver.driverLat!, driver.driverLon!)
        : null;

    final customerPos = LatLng(inv.lat!, inv.lon!);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapView(
          invoiceId: inv.id,
          initialPosition: driverPos,
          customerPosition: customerPos,
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
  void onSwichViewTap() {
    setState(() {
      isCardView = !isCardView;
    });
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
  void onShowDetails(DriverModel driver) {
    final String activity = driver.isActive ? "active".tr() : "inactive".tr();

    String distanceStr = "---";
    if (driver.distance != null) {

      distanceStr = driver.distance!.toString();
    }

    final driverLat =
    driver.driverLat != null ? driver.driverLat!.toStringAsFixed(6) : "---";
    final driverLon =
    driver.driverLon != null ? driver.driverLon!.toStringAsFixed(6) : "---";

    final restLat = driver.restaurantLatitude != null
        ? driver.restaurantLatitude!.toString()
        : "---";
    final restLon = driver.restaurantLongitude != null
        ? driver.restaurantLongitude!.toString()
        : "---";

    final inv = driver.invoice.isNotEmpty ? driver.invoice.first : null;

    final details = _DriverDetails(
      id: driver.id,
      image: (driver.image.isNotEmpty) ? driver.image : null,
      tiles: [
        IconTitleValueModel(icon: Icons.person,        title: 'name',          value: driver.name),
        IconTitleValueModel(icon: Icons.badge,         title: 'account_name',  value: driver.username),
        IconTitleValueModel(icon: Icons.phone,         title: 'phone_number',  value: driver.phone),
        IconTitleValueModel(icon: Icons.cake,          title: 'birthday',      value: driver.birthday ?? '---'),
        IconTitleValueModel(icon: Icons.verified_user, title: 'status',        value: activity),
        IconTitleValueModel(icon: Icons.straighten,    title: 'distance',      value: distanceStr),
        IconTitleValueModel(icon: Icons.my_location,   title: 'driver_lat',    value: driverLat),
        IconTitleValueModel(icon: Icons.my_location,   title: 'driver_lon',    value: driverLon),
        IconTitleValueModel(icon: Icons.store_mall_directory, title: 'restaurant_latitude',  value: restLat),
        IconTitleValueModel(icon: Icons.store_mall_directory, title: 'restaurant_longitude', value: restLon),
      ],
    );

    showDialog(
      context: context,
      builder: (_) => MainShowDetailsWidget<_DriverDetails>(
        model: details,
        // أيقونة على الصورة لفتح الخريطة (اختياري)
        iconOnImage: (inv != null)
            ? const CircleAvatar(
          radius: 16,
          backgroundColor: Colors.black54,
          child: Icon(Icons.location_on, color: Colors.white, size: 16),
        )
            : null,
        onIconOnImageTap: (ctx, m) {
          Navigator.of(ctx).pop();
          onShowMapTap(driver);
        },
      ),
    );
  }


  @override
  void onMoreOptionsTap(DriverModel driver, bool isActive) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return MoreOptionsWidget(
          item: driver,
          onShowDetailsTap: onShowDetails,
          onEditTap: onEditTap,
          onDeleteTap: onDeleteTap,
          customeButtons: [
            if (isActive)
              ActionTile(
                icon: driver.isActive ? Icons.block : Icons.check_circle,
                label: driver.isActive ? 'إلغاء التنشيط' : 'تنشيط',
                onTap: () => onActivateTap(driver),
              ),
          ],
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
    final permissions = widget.permissions.map((e) => e.name).toSet();

    final isAdd = permissions.contains("delivery.add");
    final isEdit = permissions.contains("delivery.update");
    final isDelete = permissions.contains("delivery.delete");
    final isActive = permissions.contains("delivery.active");
    final isOrder = permissions.contains("order.index");

    if (isEdit || isDelete || isActive || isOrder) {
      titles.add("event".tr());
    }

    //final restColor = widget.restaurant.color;

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
        appBar: MainAppBar(
          restaurant: widget.restaurant,
          title: "drivers".tr(),
          onSearchChanged: (q) => driversCubit.searchByName(q),
          onSearchSubmitted: (q) => driversCubit.searchByName(q),
          onSearchClosed: () => driversCubit.searchByName(''),
          onLanguageToggle: (loc) {
          },
        ),
        drawer: MainDrawer(
          permissions: widget.permissions,
          restaurant: widget.restaurant,
        ),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            padding: AppConstants.padding16,
            child: Column(
              children: [
                BlocBuilder<DriversCubit, GeneralDriversState>(
                  buildWhen: (previous, current) => current is DriversState,
                  builder: (context, state) {
                    if (state is DriversLoading) {
                      return const LoadingIndicator(color: AppColors.black);
                    } else if (state is DriversSuccess) {
                      if (isCardView) {
                        return _buildCardView(state.drivers);
                      } else {
                        return _buildTableView(titles, state.drivers);
                      }
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
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SwitchViewButton(
              onTap: onSwichViewTap,
              isCardView: isCardView,
              color: widget.restaurant.color,
            ),
            const SizedBox(width: 10),
            if (isAdd)
              MainAddButton(onTap: onAddTap, color: widget.restaurant.color)
          ],
        ),
      ),
    );
  }

  Widget _buildCardView(PaginatedModel<DriverModel> drivers) {
    final permissions = widget.permissions.map((e) => e.name).toSet();
    final isEdit = permissions.contains("delivery.update");
    final isDelete = permissions.contains("delivery.delete");
    final isActive = permissions.contains("delivery.active");
    final isOrder = permissions.contains("order.index");
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: drivers.data.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final driver = drivers.data[index];
        Widget textWidget(String text) {
          return Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: AppColors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        }

        return Container(
          decoration: const BoxDecoration(
            borderRadius: AppConstants.borderRadius25,
            color: Color(0xFFD9D9D9),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: widget.restaurant.color,
                  borderRadius: AppConstants.borderRadiusT25,
                ),
                child: Padding(
                  padding: AppConstants.paddingH12V4,
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          driver.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: AppColors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 5),
                      if (isOrder) ...[
                        InkWell(
                          onTap: () => onShowDriverInvoices(driver),
                          child: const Icon(
                            FontAwesomeIcons.fileInvoice,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(width: 5),
                      ],
                      if (isActive)
                        InkWell(
                          onTap: () => onShowMapTap(driver),
                          child: const Icon(
                            Icons.location_on,
                            color: AppColors.white,
                          ),
                        ),
                      if (!isEdit && isDelete)
                        InkWell(
                          onTap: () => onShowDetails(driver),
                          child: const Icon(
                            Icons.visibility_outlined,
                            color: AppColors.white,
                          ),
                        ),
                      if (isEdit && isDelete)
                        InkWell(
                          onTap: () => onMoreOptionsTap(driver, isActive),
                          child: const Icon(
                            Icons.more_vert_outlined,
                            color: AppColors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: AppConstants.padding10,
                child: Row(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFBDD358)),
                        borderRadius: AppConstants.borderRadius15,
                      ),
                      child: Padding(
                        padding: AppConstants.padding8,
                        child: SvgPicture.asset("assets/images/driver.svg"),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textWidget(
                              "${"account_name".tr()} : ${driver.username}"),
                          textWidget(
                              "${"phone_number".tr()} : ${driver.phone}"),
                          textWidget(
                              "${"birthday".tr()} : ${driver.birthday ?? "---"}"),
                          textWidget(
                              "${"status".tr()} : ${driver.status ?? "---"}"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTableView(
      List<String> titles,
      PaginatedModel<DriverModel> drivers,
      ) {
    final permissions = widget.permissions.map((e) => e.name).toSet();

    final isEdit = permissions.contains("delivery.update");
    final isDelete = permissions.contains("delivery.delete");
    final isActive = permissions.contains("delivery.active");
    final isOrder = permissions.contains("order.index");

    final rows = List.generate(
      drivers.data.length,
          (index) {
        final driver = drivers.data[index];
        final values = [
          Text(driver.name),
          Text(driver.username),
          Text(driver.phone),
          Text(driver.birthday ?? "_"),
          MainActionButton(
            padding: AppConstants.padding6,
            onPressed: () {},
            text: driver.isActive ? "active".tr() : "inactive".tr(),
            buttonColor: driver.isActive ? AppColors.greenShade : AppColors.red,
          ),
          if (isEdit || isDelete || isActive || isOrder)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isOrder)
                  InkWell(
                    onTap: () => onShowDriverInvoices(driver),
                    child: const Icon(FontAwesomeIcons.fileInvoice),
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
                      driver.isActive ? Icons.block : Icons.check_circle,
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
        MainDataTable(titles: titles, rows: rows,color: widget.restaurant.color,),
        SelectPageTile(
          length: drivers.meta.totalPages,
          selectedPage: selectedPage,
          onSelectPageTap: onSelectPageTap,
        ),
      ],
    );
  }
}

class _DriverDetails implements DetailsModel {
  @override
  final int id;
  @override
  final String? image;
  @override
  final List<IconTitleValueModel> tiles;

  const _DriverDetails({
    required this.id,
    this.image,
    required this.tiles,
  });
}

