// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:user_admin/features/add_order/cubit/add_order_cubit.dart'
    as _i505;
import 'package:user_admin/features/add_order/service/add_order_service.dart'
    as _i1041;
import 'package:user_admin/features/admins/cubit/admins_cubit.dart' as _i65;
import 'package:user_admin/features/admins/service/admins_service.dart'
    as _i419;
import 'package:user_admin/features/advertisements/cubit/advertisements_cubit.dart'
    as _i170;
import 'package:user_admin/features/advertisements/service/advertisements_service.dart'
    as _i191;
import 'package:user_admin/features/app_manager/cubit/app_manager_cubit.dart'
    as _i52;
import 'package:user_admin/features/coupons/cubit/coupons_cubit.dart' as _i797;
import 'package:user_admin/features/coupons/service/coupon_service.dart'
    as _i356;
import 'package:user_admin/features/customer_service/cubit/customer_service_cubit.dart'
    as _i1050;
import 'package:user_admin/features/customer_service/service/customer_service_repo.dart'
    as _i1009;
import 'package:user_admin/features/drivers/cubit/drivers_cubit.dart' as _i703;
import 'package:user_admin/features/drivers/service/drivers_service.dart'
    as _i677;
import 'package:user_admin/features/employees_details/cubit/employees_details_cubit.dart'
    as _i267;
import 'package:user_admin/features/employees_details/service/employees_details_service.dart'
    as _i632;
import 'package:user_admin/features/home/cubit/home_cubit.dart' as _i335;
import 'package:user_admin/features/home/service/home_service.dart' as _i908;
import 'package:user_admin/features/invoices/cubit/invoices_cubit.dart' as _i52;
import 'package:user_admin/features/invoices/service/invoices_service.dart'
    as _i674;
import 'package:user_admin/features/items/cubit/items_cubit.dart' as _i898;
import 'package:user_admin/features/items/service/items_service.dart' as _i53;
import 'package:user_admin/features/profile/cubit/profile_cubit.dart' as _i1014;
import 'package:user_admin/features/profile/service/profile_service.dart'
    as _i325;
import 'package:user_admin/features/ratings/cubit/ratings_cubit.dart' as _i315;
import 'package:user_admin/features/ratings/service/ratings_service.dart'
    as _i504;
import 'package:user_admin/features/restaurant/cubit/restaurant_cubit.dart'
    as _i168;
import 'package:user_admin/features/restaurant/service/restaurant_service.dart'
    as _i216;
import 'package:user_admin/features/sales/cubit/sales_cubit.dart' as _i352;
import 'package:user_admin/features/sales/service/sales_service.dart' as _i152;
import 'package:user_admin/features/sign_in/cubit/sign_in_cubit.dart' as _i380;
import 'package:user_admin/features/sign_in/service/sign_in_service.dart'
    as _i472;
import 'package:user_admin/features/tables/cubit/tables_cubit.dart' as _i853;
import 'package:user_admin/features/tables/service/tables_service.dart'
    as _i818;
import 'package:user_admin/features/takeout_orders/cubit/takeout_orders_cubit.dart'
    as _i1004;
import 'package:user_admin/features/takeout_orders/service/takeout_orders_service.dart'
    as _i862;
import 'package:user_admin/features/users/cubit/users_cubit.dart' as _i916;
import 'package:user_admin/features/users/service/users_service.dart' as _i523;
import 'package:user_admin/global/blocs/delete_cubit/cubit/delete_cubit.dart'
    as _i729;
import 'package:user_admin/global/blocs/show_map_cubit/cubit/show_map_cubit.dart'
    as _i954;
import 'package:user_admin/global/dio/dio_client.dart' as _i998;
import 'package:user_admin/global/services/delete_service/delete_service.dart'
    as _i928;
import 'package:user_admin/global/services/notafications_service/notafications_service.dart'
    as _i451;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i954.ShowMapCubit>(() => _i954.ShowMapCubit());
    gh.singleton<_i52.AppManagerCubit>(() => _i52.AppManagerCubit());
    gh.singleton<_i998.DioClient>(() => _i998.DioClient());
    gh.singleton<_i451.NotaficationsService>(
        () => _i451.NotaficationsService());
    gh.factory<_i523.UsersService>(() => _i523.UsersServiceImp());
    gh.factory<_i216.RestaurantService>(() => _i216.RestaurantServiceImp());
    gh.factory<_i152.SalesService>(() => _i152.SalesServiceImp());
    gh.factory<_i53.ItemsService>(() => _i53.ItemsServiceImp());
    gh.factory<_i818.TablesService>(() => _i818.TablesServiceImp());
    gh.factory<_i898.ItemsCubit>(
        () => _i898.ItemsCubit(gh<_i53.ItemsService>()));
    gh.factory<_i419.AdminsService>(() => _i419.AdminsServiceImp());
    gh.factory<_i472.SignInService>(() => _i472.SignInServiceImp());
    gh.factory<_i677.DriversService>(() => _i677.DriversServiceImp());
    gh.factory<_i632.EmployeesDetailsService>(
        () => _i632.EmployeesDetailsServiceImp());
    gh.factory<_i356.CouponService>(() => _i356.CouponServiceImp());
    gh.factory<_i908.HomeService>(() => _i908.HomeServiceImp());
    gh.factory<_i1041.AddOrderService>(() => _i1041.AddOrderServiceImp());
    gh.factory<_i674.InvoicesService>(() => _i674.InvoicesServiceImp());
    gh.factory<_i928.DeleteService>(() => _i928.DeleteServiceImp());
    gh.factory<_i1009.CustomerServiceRepo>(
        () => _i1009.CustomerServiceRepoImp());
    gh.factory<_i1050.CustomerServiceCubit>(
        () => _i1050.CustomerServiceCubit(gh<_i1009.CustomerServiceRepo>()));
    gh.factory<_i862.TakeoutOrdersService>(
        () => _i862.TakeoutOrdersServiceImp());
    gh.factory<_i325.ProfileService>(() => _i325.ProfileServiceImp());
    gh.factory<_i191.AdvertisementsService>(
        () => _i191.AdvertisementsServiceImp());
    gh.factory<_i504.RatingsService>(() => _i504.RatingsServiceImp());
    gh.factory<_i797.CouponsCubit>(
        () => _i797.CouponsCubit(gh<_i356.CouponService>()));
    gh.factory<_i505.AddOrderCubit>(
        () => _i505.AddOrderCubit(gh<_i1041.AddOrderService>()));
    gh.factory<_i729.DeleteCubit>(
        () => _i729.DeleteCubit(gh<_i928.DeleteService>()));
    gh.factory<_i315.RatingsCubit>(
        () => _i315.RatingsCubit(gh<_i504.RatingsService>()));
    gh.factory<_i65.AdminsCubit>(
        () => _i65.AdminsCubit(gh<_i419.AdminsService>()));
    gh.factory<_i703.DriversCubit>(
        () => _i703.DriversCubit(gh<_i677.DriversService>()));
    gh.factory<_i853.TablesCubit>(
        () => _i853.TablesCubit(gh<_i818.TablesService>()));
    gh.factory<_i916.UsersCubit>(
        () => _i916.UsersCubit(gh<_i523.UsersService>()));
    gh.factory<_i170.AdvertisementsCubit>(
        () => _i170.AdvertisementsCubit(gh<_i191.AdvertisementsService>()));
    gh.factory<_i52.InvoicesCubit>(
        () => _i52.InvoicesCubit(gh<_i674.InvoicesService>()));
    gh.factory<_i335.HomeCubit>(() => _i335.HomeCubit(gh<_i908.HomeService>()));
    gh.factory<_i168.RestaurantCubit>(
        () => _i168.RestaurantCubit(gh<_i216.RestaurantService>()));
    gh.factory<_i1014.ProfileCubit>(
        () => _i1014.ProfileCubit(gh<_i325.ProfileService>()));
    gh.factory<_i380.SignInCubit>(
        () => _i380.SignInCubit(gh<_i472.SignInService>()));
    gh.factory<_i352.SalesCubit>(
        () => _i352.SalesCubit(gh<_i152.SalesService>()));
    gh.factory<_i267.EmployeesDetailsCubit>(
        () => _i267.EmployeesDetailsCubit(gh<_i632.EmployeesDetailsService>()));
    gh.factory<_i1004.TakeoutOrdersCubit>(
        () => _i1004.TakeoutOrdersCubit(gh<_i862.TakeoutOrdersService>()));
    return this;
  }
}
