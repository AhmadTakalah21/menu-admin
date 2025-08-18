import 'dart:async';
import 'package:user_admin/features/splash/cubit/restaurant_cubit.dart';
import 'package:user_admin/global/blocs/internet_connection/cubit/internet_connection_cubit.dart';
import 'package:user_admin/global/di/di.dart';
import 'package:user_admin/global/model/restaurant_model/restaurant_model.dart';
import 'package:user_admin/global/utils/app_colors.dart';
import 'package:user_admin/global/utils/constants.dart';
import 'package:user_admin/global/utils/utils.dart';
import 'package:user_admin/global/widgets/logo_loading_indicator.dart';
import 'package:user_admin/global/widgets/main_error_widget.dart';
import 'package:user_admin/global/widgets/main_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SplashViewCallBacks {
  void onTryAgainTap();
  void goToNextPage(RestaurantModel restaurant);
  void fetchData(bool isRefresh);
}

class SplashView extends StatelessWidget {
  final RestaurantModel? restaurant;

  const SplashView({super.key, this.restaurant});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => get<RestaurantCubit>(),
        ),
        BlocProvider(
          create: (context) => get<InternetConnectionCubit>(),
        ),
      ],
      child: const SplashPage(),
    );
  }
}

class SplashPage extends StatefulWidget {
  final RestaurantModel? restaurant;

  const SplashPage({super.key, this.restaurant});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    implements SplashViewCallBacks {
  late final RestaurantCubit restaurantCubit = context.read();
  late final InternetConnectionCubit internetConnectionCubit = context.read();

  Timer? timer;
  int time = 0;
  Color backgroundColor = AppColors.whiteShade;

  @override
  void initState() {
    super.initState();
    _loadBackgroundColor();
    timer ??= Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        time++;
      });
    });
    internetConnectionCubit.checkInternetConnection();
  }

  Future<void> _loadBackgroundColor() async {
    final prefs = await SharedPreferences.getInstance();
    String? storedColor = prefs.getString(AppConstants.restaurantBackgroundColor);
    if (storedColor != null && storedColor.isNotEmpty) {
      setState(() {
        backgroundColor = Color(int.parse(storedColor));
      });
    } else {
      fetchData(true);
    }
  }

  @override
  void goToNextPage(RestaurantModel restaurant) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Utils.determineInitialRoute(restaurant),
      ),
          (route) => false,
    );
  }

  @override
  void fetchData(bool isRefresh) {
    restaurantCubit.getRestaurantInfo(isRefresh: isRefresh);
  }

  @override
  void onTryAgainTap() => fetchData(true);

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InternetConnectionCubit, InternetConnectionState>(
      listener: (context, state) {
        if (state is InternetConnectedState) {
          fetchData(true);
        } else if (state is InternetDisconnectedState) {
          fetchData(false);
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: BlocConsumer<RestaurantCubit, RestaurantState>(
          listener: (context, state) {
            if (state is RestaurantSuccess) {
              _saveBackgroundColor(state.restaurant.backgroundColor);
              if (time < 3) {
                Future.delayed(const Duration(seconds: 4), () {
                  goToNextPage(state.restaurant);
                });
              } else {
                goToNextPage(state.restaurant);
              }
            } else if (state is RestaurantFail) {
              MainSnackBar.showErrorMessage(context, state.error);
            }
          },
          builder: (context, state) {
            Widget child = const SizedBox.shrink();
            if (state is RestaurantLoading || timer!.isActive) {
              child = LogoLoadingIndicator(
                size: 300,
                restaurant: widget.restaurant,
              );
            } else if (state is RestaurantFail) {
              child = MainErrorWidget(
                height: MediaQuery.sizeOf(context).height / 2,
                error: state.error,
                onTryAgainTap: onTryAgainTap,
              );
            }
            return Center(child: child);
          },
        ),
      ),
    );
  }

  Future<void> _saveBackgroundColor(Color? color) async {
    if (color != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
        AppConstants.restaurantBackgroundColor,
        color.value.toString(),
      );
    }
  }
}
