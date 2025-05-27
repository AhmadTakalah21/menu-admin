import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:user_admin/features/add_order/view/add_order_view.dart';
import 'package:user_admin/features/admins/view/admins_view.dart';
import 'package:user_admin/features/advertisements/view/advertisements_view.dart';
import 'package:user_admin/features/coupons/view/coupons_view.dart';
import 'package:user_admin/features/customer_service/view/customer_service_view.dart';
import 'package:user_admin/features/drivers/view/drivers_view.dart';
import 'package:user_admin/features/employees_details/view/employees_details_view.dart';
import 'package:user_admin/features/home/view/home_view.dart';
import 'package:user_admin/features/invoices/view/invoices_view.dart';
import 'package:user_admin/features/profile/view/profile_view.dart';
import 'package:user_admin/features/restaurant/view/restaurant_view.dart';
import 'package:user_admin/features/sales/view/sales_view.dart';
import 'package:user_admin/features/sign_in/model/sign_in_model/sign_in_model.dart';
import 'package:user_admin/features/tables/view/tables_view.dart';
import 'package:user_admin/features/takeout_orders/view/takeout_orders_view.dart';
import 'package:user_admin/features/users/view/users_view.dart';
import 'package:user_admin/global/model/role_model/role_model.dart';

enum DrawerTileEnum {
  categories,
  advertisements,
  admins,
  restaurant,
  tables,
  coupons,
  salesInventory,
  invoices,
  addOrder,
  employeesDetails,
  users,
  drivers,
  takeOutOrders,
  ratings,
  services,
  profile,
  userUi,
  logout;

  String get displayName {
    switch (this) {
      case DrawerTileEnum.categories:
        return "categories".tr();
      case DrawerTileEnum.advertisements:
        return "advertisements".tr();
      case DrawerTileEnum.admins:
        return "admins".tr();
      case DrawerTileEnum.restaurant:
        return "restaurant".tr();
      case DrawerTileEnum.tables:
        return "tables".tr();
      case DrawerTileEnum.coupons:
        return "coupons".tr();
      case DrawerTileEnum.salesInventory:
        return "sales_inventory".tr();
      case DrawerTileEnum.invoices:
        return "invoices".tr();
      case DrawerTileEnum.addOrder:
        return "add_order".tr();
      case DrawerTileEnum.employeesDetails:
        return "employees_details".tr();
      case DrawerTileEnum.users:
        return "users".tr();
      case DrawerTileEnum.drivers:
        return "drivers".tr();
      case DrawerTileEnum.takeOutOrders:
        return "takeout_orders".tr();
      case DrawerTileEnum.ratings:
        return "ratings".tr();
      case DrawerTileEnum.services:
        return "services".tr();
      case DrawerTileEnum.profile:
        return "profile".tr();
      case DrawerTileEnum.userUi:
        return "go_to_user_interface".tr();
      case DrawerTileEnum.logout:
        return "logout".tr();
    }
  }

  IconData get icon {
    switch (this) {
      case DrawerTileEnum.categories:
        return Icons.home_outlined;
      case DrawerTileEnum.advertisements:
        return Icons.ads_click;
      case DrawerTileEnum.admins:
        return Icons.groups;
      case DrawerTileEnum.restaurant:
        return Icons.restaurant;
      case DrawerTileEnum.tables:
        return Icons.table_restaurant;
      case DrawerTileEnum.coupons:
        return Icons.sell;
      case DrawerTileEnum.salesInventory:
        return Icons.inventory_2_outlined;
      case DrawerTileEnum.invoices:
        return Icons.receipt_long;
      case DrawerTileEnum.addOrder:
        return Icons.add_circle_outline;
      case DrawerTileEnum.employeesDetails:
        return Icons.add_shopping_cart_outlined;
      case DrawerTileEnum.users:
        return Icons.people;
      case DrawerTileEnum.drivers:
        return Icons.motorcycle;
      case DrawerTileEnum.takeOutOrders:
        return Icons.fire_truck;
      case DrawerTileEnum.ratings:
        return Icons.star;
      case DrawerTileEnum.services:
        return Icons.settings;
      case DrawerTileEnum.profile:
        return Icons.person;
      case DrawerTileEnum.userUi:
        return Icons.view_quilt_outlined;
      case DrawerTileEnum.logout:
        return Icons.logout;
    }
  }

  String get getTileShowName {
    switch (this) {
      case DrawerTileEnum.categories:
        return "category.index";
      case DrawerTileEnum.advertisements:
        return "advertisement.index";
      case DrawerTileEnum.admins:
        return "user.index";
      case DrawerTileEnum.restaurant:
        return "update_restaurant_admin";
      case DrawerTileEnum.tables:
        return "table.index";
      case DrawerTileEnum.coupons:
        return "coupon.index";
      case DrawerTileEnum.salesInventory:
        return "order.index";
      case DrawerTileEnum.invoices:
        return "order.index";
      case DrawerTileEnum.addOrder:
        return "order.add";
      case DrawerTileEnum.employeesDetails:
        return "user.index";
      case DrawerTileEnum.users:
        return "user.index";
      case DrawerTileEnum.drivers:
        return "delivery.index";
      case DrawerTileEnum.takeOutOrders:
        return "order.index";
      case DrawerTileEnum.ratings:
        return "rate.index";
      case DrawerTileEnum.services:
        return "service.index";
      case DrawerTileEnum.profile:
        return "show_always";
      case DrawerTileEnum.userUi:
        return "show_always";
      case DrawerTileEnum.logout:
        return "show_always";
    }
  }

  bool isHasPermission(List<RoleModel> permissions) {
    if (getTileShowName == "show_always") {
      return true;
    }
    int index = permissions.indexWhere(
      (element) => element.name == getTileShowName,
    );
    if (index != -1) {
      return true;
    }
    return false;
  }

  VoidCallback onTap(BuildContext context, SignInModel signInModel) {
    switch (this) {
      case DrawerTileEnum.categories:
        return () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeView(signInModel: signInModel),
            ),
          );
        };
      case DrawerTileEnum.advertisements:
        return () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AdvertisementsView(signInModel: signInModel),
            ),
          );
        };
      case DrawerTileEnum.admins:
        return () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminsView(signInModel: signInModel),
            ),
          );
        };
      case DrawerTileEnum.restaurant:
        return () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RestaurantView(signInModel: signInModel),
            ),
          );
        };
      case DrawerTileEnum.tables:
        return () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TablesView(signInModel: signInModel),
            ),
          );
        };
      case DrawerTileEnum.coupons:
        return () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CouponsView(signInModel: signInModel),
            ),
          );
        };
      case DrawerTileEnum.salesInventory:
        return () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SalesView(signInModel: signInModel),
            ),
          );
        };
      case DrawerTileEnum.invoices:
        return () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InvoicesView(signInModel: signInModel),
            ),
          );
        };
      case DrawerTileEnum.addOrder:
        return () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddOrderView(signInModel: signInModel),
            ),
          );
        };
      case DrawerTileEnum.employeesDetails:
        return () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EmployeesDetailsView(signInModel: signInModel),
            ),
          );
        };
      case DrawerTileEnum.users:
        return () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UsersView(signInModel: signInModel),
            ),
          );
        };
      case DrawerTileEnum.drivers:
        return () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DriversView(signInModel: signInModel),
            ),
          );
        };
      case DrawerTileEnum.takeOutOrders:
        return () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TakeoutOrdersView(signInModel: signInModel),
            ),
          );
        };
      case DrawerTileEnum.ratings:
        return () {};
      case DrawerTileEnum.services:
        return () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CustomerServiceView(signInModel: signInModel),
            ),
          );
        };
      case DrawerTileEnum.profile:
        return () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileView(signInModel: signInModel),
            ),
          );
        };
      case DrawerTileEnum.userUi:
        return () {};
      case DrawerTileEnum.logout:
        return () {};
    }
  }
}
