import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_admin/features/add_order/cubit/add_order_cubit.dart';
import 'package:user_admin/features/advertisements/cubit/advertisements_cubit.dart';
import 'package:user_admin/features/app/admin_material_app.dart';
import 'package:user_admin/features/app_manager/cubit/app_manager_cubit.dart';
import 'package:user_admin/features/coupons/cubit/coupons_cubit.dart';
import 'package:user_admin/features/customer_service/cubit/customer_service_cubit.dart';
import 'package:user_admin/features/drivers/cubit/drivers_cubit.dart';
import 'package:user_admin/features/employees_details/cubit/employees_details_cubit.dart';
import 'package:user_admin/features/home/cubit/home_cubit.dart';
import 'package:user_admin/features/items/cubit/items_cubit.dart';
import 'package:user_admin/features/profile/cubit/profile_cubit.dart';
import 'package:user_admin/features/ratings/cubit/ratings_cubit.dart';
import 'package:user_admin/features/restaurant/cubit/restaurant_cubit.dart';
import 'package:user_admin/features/sales/cubit/sales_cubit.dart';
import 'package:user_admin/features/sign_in/cubit/sign_in_cubit.dart';
import 'package:user_admin/features/tables/cubit/tables_cubit.dart';
import 'package:user_admin/features/takeout_orders/cubit/takeout_orders_cubit.dart';
import 'package:user_admin/features/users/cubit/users_cubit.dart';
import 'package:user_admin/global/blocs/delete_cubit/cubit/delete_cubit.dart';
import 'package:user_admin/global/blocs/show_map_cubit/cubit/show_map_cubit.dart';
import 'package:user_admin/global/di/di.dart';
import 'package:user_admin/global/localization/supported_locales.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => get<AppManagerCubit>(),
        ),
        BlocProvider(
          create: (_) => get<SignInCubit>(),
        ),
        BlocProvider(
          create: (_) => get<HomeCubit>(),
        ),
        BlocProvider(
          create: (_) => get<DeleteCubit>(),
        ),
        BlocProvider(
          create: (_) => get<ItemsCubit>(),
        ),
        BlocProvider(
          create: (_) => get<TablesCubit>(),
        ),
        BlocProvider(
          create: (_) => get<CustomerServiceCubit>(),
        ),
        BlocProvider(
          create: (_) => get<CouponsCubit>(),
        ),
        BlocProvider(
          create: (_) => get<AdvertisementsCubit>(),
        ),
        BlocProvider(
          create: (_) => get<ProfileCubit>(),
        ),
        BlocProvider(
          create: (_) => get<DriversCubit>(),
        ),
        BlocProvider(
          create: (_) => get<TakeoutOrdersCubit>(),
        ),
        BlocProvider(
          create: (_) => get<UsersCubit>(),
        ),
        BlocProvider(
          create: (_) => get<RestaurantCubit>(),
        ),
        BlocProvider(
          create: (_) => get<SalesCubit>(),
        ),
        BlocProvider(
          create: (_) => get<RatingsCubit>(),
        ),
        BlocProvider(
          create: (_) => get<EmployeesDetailsCubit>(),
        ),
        BlocProvider(
          create: (_) => get<AddOrderCubit>(),
        ),
        BlocProvider(
          create: (_) => get<ShowMapCubit>(),
        ),
      ],
      child: EasyLocalization(
        supportedLocales: SupportedLocales.locales,
        path: SupportedLocales.path,
        startLocale: SupportedLocales.arabic,
        fallbackLocale: SupportedLocales.arabic,
        child: const AdminMaterialApp(),
      ),
    );
  }
}
