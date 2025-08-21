import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:user_admin/features/add_order/view/add_order_view.dart';
import 'package:user_admin/features/admins/view/admins_view.dart';
import 'package:user_admin/features/advertisements/view/advertisements_view.dart';
import 'package:user_admin/features/coupons/view/coupons_view.dart';
import 'package:user_admin/features/customer_service/view/customer_service_view.dart';
import 'package:user_admin/features/drivers/view/drivers_view.dart';
import 'package:user_admin/features/home/view/home_view.dart';
import 'package:user_admin/features/invoices/view/invoices_view.dart';
import 'package:user_admin/features/profile/view/profile_view.dart';
import 'package:user_admin/features/restaurant/view/restaurant_view.dart';
import 'package:user_admin/features/sales/view/sales_view.dart';
import 'package:user_admin/features/tables/view/tables_view.dart';
import 'package:user_admin/features/takeout_orders/view/takeout_orders_view.dart';
import 'package:user_admin/features/users/view/users_view.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
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
  //employeesDetails,
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
      case categories:
        return "categories".tr();
      case advertisements:
        return "advertisements".tr();
      case admins:
        return "admins".tr();
      case restaurant:
        return "restaurant".tr();
      case tables:
        return "tables".tr();
      case coupons:
        return "coupons".tr();
      case salesInventory:
        return "sales_inventory".tr();
      case invoices:
        return "invoices".tr();
      case addOrder:
        return "add_order".tr();
    // case employeesDetails:
    //   return "employees_details".tr();
      case users:
        return "users".tr();
      case drivers:
        return "drivers".tr();
      case takeOutOrders:
        return "takeout_orders".tr();
      case ratings:
        return "ratings".tr();
      case services:
        return "services".tr();
      case profile:
        return "profile".tr();
      case userUi:
        return "go_to_user_interface".tr();
      case logout:
        return "logout".tr();
    }
  }

  bool get hasDividerAfter {
    return this == advertisements || this == invoices || this == takeOutOrders;
  }

  IconData get icon {
    switch (this) {
      case categories:
        return Icons.home_outlined;
      case advertisements:
        return Icons.ads_click;
      case admins:
        return Icons.groups;
      case restaurant:
        return Icons.restaurant;
      case tables:
        return Icons.table_restaurant;
      case coupons:
        return Icons.sell;
      case salesInventory:
        return Icons.inventory_2_outlined;
      case invoices:
        return Icons.receipt_long;
      case addOrder:
        return Icons.add_circle_outline;
    // case employeesDetails:
    //   return Icons.add_shopping_cart_outlined;
      case users:
        return Icons.people;
      case drivers:
        return Icons.motorcycle;
      case takeOutOrders:
        return Icons.fire_truck;
      case ratings:
        return Icons.star;
      case services:
        return Icons.settings;
      case profile:
        return Icons.person;
      case userUi:
        return Icons.view_quilt_outlined;
      case logout:
        return Icons.logout;
    }
  }

  String get getTileShowName {
    switch (this) {
      case categories:
        return "category.index";
      case advertisements:
        return "advertisement.index";
      case admins:
        return "user.index";
      case restaurant:
        return "update_restaurant_admin";
      case tables:
        return "table.index";
      case coupons:
        return "coupon.index";
      case salesInventory:
        return "order.index";
      case invoices:
        return "order.index";
      case addOrder:
        return "order.add";
    // case employeesDetails:
    //   return "user.index";
      case users:
        return "user.index";
      case drivers:
        return "delivery.index";
      case takeOutOrders:
        return "order.index";
      case ratings:
        return "rate.index";
      case services:
        return "service.index";
      case profile:
        return "show_always";
      case userUi:
        return "show_always";
      case logout:
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

  VoidCallback onTap(BuildContext context, RestaurantModel restaurant,
      List<RoleModel> permissions) {
    switch (this) {
      case categories:
        return () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeView(
                restaurant: restaurant,
                permissions: permissions,
              ),
            ),
          );
        };
      case advertisements:
        return () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdvertisementsView(
                restaurant: restaurant,
                permissions: permissions,
              ),
            ),
          );
        };
      case admins:
        return () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminsView(
                restaurant: restaurant,
                permissions: permissions,
              ),
            ),
          );
        };
      case DrawerTileEnum.restaurant:
        return () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RestaurantView(
                restaurant: restaurant,
                permissions: permissions,
              ),
            ),
          );
        };
      case tables:
        return () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TablesView(
                restaurant: restaurant,
                permissions: permissions,
              ),
            ),
          );
        };
      case coupons:
        return () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CouponsView(
                restaurant: restaurant,
                permissions: permissions,
              ),
            ),
          );
        };
      case salesInventory:
        return () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SalesView(
                restaurant: restaurant,
                permissions: permissions,
              ),
            ),
          );
        };
      case invoices:
        return () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InvoicesView(
                restaurant: restaurant,
                permissions: permissions,
              ),
            ),
          );
        };
      case addOrder:
        return () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddOrderView(
                restaurant: restaurant,
                permissions: permissions,
              ),
            ),
          );
        };
    // case employeesDetails:
    //   return () {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => EmployeesDetailsView(
    //           restaurant: restaurant,
    //           permissions: permissions,
    //         ),
    //       ),
    //     );
    //   };
      case users:
        return () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UsersView(
                restaurant: restaurant,
                permissions: permissions,
              ),
            ),
          );
        };
      case drivers:
        return () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DriversView(
                restaurant: restaurant,
                permissions: permissions,
              ),
            ),
          );
        };
      case takeOutOrders:
        return () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TakeoutOrdersView(
                restaurant: restaurant,
                permissions: permissions,
              ),
            ),
          );
        };
      case ratings:
        return () {};
      case services:
        return () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CustomerServiceView(
                restaurant: restaurant,
                permissions: permissions,
              ),
            ),
          );
        };
      case profile:
        return () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileView(
                restaurant: restaurant,
                permissions: permissions,
              ),
            ),
          );
        };
      case userUi:
        return () {};
      case logout:
        return () {};
    }
  }
}
