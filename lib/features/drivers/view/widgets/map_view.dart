import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:user_admin/global/blocs/show_map_cubit/cubit/show_map_cubit.dart';
import 'package:user_admin/global/widgets/loading_indicator.dart';
import 'package:user_admin/global/widgets/main_error_widget.dart';

abstract class MapViewCallBacks {
  void onTryAgainTap();
}

class MapView extends StatefulWidget {
  const MapView({super.key, required this.initialPosition});

  final LatLng? initialPosition;

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> implements MapViewCallBacks {
  late final ShowMapCubit showMapCubit = context.read();

  final mapController = MapController();

  @override
  void initState() {
    super.initState();
    showMapCubit.showMap();
  }

  @override
  void onTryAgainTap() {
    showMapCubit.showMap();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ShowMapCubit, ShowMapState>(
        builder: (context, state) {
          if (state is ShowMapLoading) {
            return const LoadingIndicator();
          } else if (state is ShowMapSuccess) {
            return FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter:
                    widget.initialPosition ?? const LatLng(33.5138, 36.2765),
                initialZoom: 12,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: widget.initialPosition ??
                          const LatLng(33.5138, 36.2765),
                      width: 80,
                      height: 80,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else if (state is ShowMapFail) {
            return MainErrorWidget(
              error: state.error,
              onTryAgainTap: onTryAgainTap,
            );
          } else {
            return MainErrorWidget(error: "went_wrong".tr());
          }
        },
      ),
    );
  }
}
