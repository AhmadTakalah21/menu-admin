import 'dart:async';
import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user_admin/global/utils/constants.dart'; // ضع فيه googleMapsApiKey إن وجد
import '../../../../global/di/di.dart';
import '../../service/socket_service.dart';

class MapView extends StatefulWidget {
  final int invoiceId;
  final LatLng? initialPosition;   // موقع السائق الابتدائي
  final LatLng? customerPosition;  // موقع الزبون (الهدف)

  const MapView({
    super.key,
    required this.invoiceId,
    required this.initialPosition,
    required this.customerPosition,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  String? _distance; // نص المسافة (من Directions API)
  String? _duration; // نص الزمن المقدر (ETA)
  LatLng? _driverPosition;

  // Directions API
  final Dio _dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 10), receiveTimeout: const Duration(seconds: 15)));
  static const String _directionsBase = 'https://maps.googleapis.com/maps/api/directions/json';
  String get _apiKey => (AppConstants.googleMapsApiKey?.isNotEmpty ?? false)
      ? AppConstants.googleMapsApiKey!
      : 'AIzaSyBhtWIKwjA8gN0NRSPakROXE_zpMHo_AJQ';

  // Socket
  SocketService get _socket => get<SocketService>();

  Timer? _recalcTimer;
  LatLng? _lastRoutedFrom;
  static const _recalcDebounce = Duration(seconds: 3);
  static const _moveThresholdMeters = 30.0;

  @override
  void initState() {
    super.initState();

    // 1) تهيئة مواقع العلامات
    _driverPosition = widget.initialPosition;
    if (_driverPosition != null) {
      _addOrUpdateMarker(_driverPosition!, 'driver', Colors.red);
    }
    if (widget.customerPosition != null) {
      _addOrUpdateMarker(widget.customerPosition!, 'customer', Colors.green);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _fitMapBounds());

    if (widget.customerPosition != null) {
      _socket.updateUserLocation(
        widget.customerPosition!.latitude,
        widget.customerPosition!.longitude,
      );
    }

    _socket.onDriverLocationUpdate = (lat, lon) {
      final newPos = LatLng(lat, lon);
      if (!mounted) return;
      setState(() => _driverPosition = newPos);
      _addOrUpdateMarker(newPos, 'driver', Colors.red);
      _fitMapBounds();
      _maybeRecalculateRoute();
    };

    _socket.onDistanceUpdate = (distance, duration) {
      if (!mounted) return;
      if (_distance == null || _duration == null) {
        setState(() {
          _distance = distance;
          _duration = duration;
        });
      }
    };

    _socket.initWebSocket(widget.invoiceId);

    _maybeRecalculateRoute(initial: true);
  }

  @override
  void dispose() {
    _recalcTimer?.cancel();
    _socket.onDriverLocationUpdate = null;
    _socket.onDistanceUpdate = null;
    _socket.onOrderUpdated = null;
    _socket.disconnect();
    super.dispose();
  }


  void _maybeRecalculateRoute({bool initial = false}) {
    final from = _driverPosition;
    final to = widget.customerPosition;
    if (from == null || to == null) return;

    if (initial || _lastRoutedFrom == null) {
      _fetchAndDrawRoute(from, to);
      _lastRoutedFrom = from;
      return;
    }

    final moved = _haversineMeters(_lastRoutedFrom!, from);
    if (moved < _moveThresholdMeters) return;

    _recalcTimer?.cancel();
    _recalcTimer = Timer(_recalcDebounce, () {
      if (!mounted) return;
      _fetchAndDrawRoute(from, to);
      _lastRoutedFrom = from;
    });
  }

  Future<void> _fetchAndDrawRoute(LatLng from, LatLng to) async {
    try {
      final url = '$_directionsBase?origin=${from.latitude},${from.longitude}'
          '&destination=${to.latitude},${to.longitude}'
          '&mode=driving&key=$_apiKey';
      final res = await _dio.get(url);

      if (res.statusCode == 200 && res.data != null && res.data['status'] == 'OK') {
        final routes = res.data['routes'] as List;
        if (routes.isEmpty) return;

        final route = routes.first;
        final overview = route['overview_polyline']?['points'] as String?;
        final legs = (route['legs'] as List?) ?? [];

        String? distanceText;
        String? durationText;
        if (legs.isNotEmpty) {
          distanceText = legs.first['distance']?['text']?.toString();
          durationText = legs.first['duration']?['text']?.toString();
        }

        final points = overview != null ? _decodePolyline(overview) : <LatLng>[];

        if (points.isNotEmpty) {
          final polyline = Polyline(
            polylineId: const PolylineId('route'),
            points: points,
            color: Colors.blueAccent.withOpacity(0.8),
            width: 6,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
            jointType: JointType.round,
          );

          setState(() {
            _polylines
              ..clear()
              ..add(polyline);
            _distance = distanceText ?? _distance;
            _duration = durationText ?? _duration;
          });

          if (_mapController != null) {
            final bounds = _boundsFromLatLngList(points);
            _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
          }
        } else {
          _drawStraightLine(from, to);
        }
      } else {
        _drawStraightLine(from, to);
      }
    } catch (_) {
      _drawStraightLine(from, to);
    }
  }


  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      final latD = lat / 1E5;
      final lngD = lng / 1E5;
      poly.add(LatLng(latD, lngD));
    }
    return poly;
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double x0 = list.first.latitude, x1 = list.first.latitude;
    double y0 = list.first.longitude, y1 = list.first.longitude;
    for (final latLng in list) {
      if (latLng.latitude > x1) x1 = latLng.latitude;
      if (latLng.latitude < x0) x0 = latLng.latitude;
      if (latLng.longitude > y1) y1 = latLng.longitude;
      if (latLng.longitude < y0) y0 = latLng.longitude;
    }
    return LatLngBounds(southwest: LatLng(x0, y0), northeast: LatLng(x1, y1));
  }

  double _haversineMeters(LatLng a, LatLng b) {
    const R = 6371000.0;
    final dLat = _deg2rad(b.latitude - a.latitude);
    final dLon = _deg2rad(b.longitude - a.longitude);
    final s1 = math.sin(dLat / 2);
    final s2 = math.sin(dLon / 2);
    final aa = s1 * s1 +
        math.cos(_deg2rad(a.latitude)) *
            math.cos(_deg2rad(b.latitude)) *
            s2 *
            s2;
    final c = 2 * math.atan2(math.sqrt(aa), math.sqrt(1 - aa));
    return R * c;
  }

  double _deg2rad(double x) => x * (math.pi / 180.0);


  void _addOrUpdateMarker(LatLng position, String id, Color color) {
    final marker = Marker(
      markerId: MarkerId(id),
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(
        color == Colors.red ? BitmapDescriptor.hueRed : BitmapDescriptor.hueGreen,
      ),
      infoWindow: InfoWindow(title: id == 'driver' ? 'السائق' : 'العميل'),
    );
    _markers.removeWhere((m) => m.markerId.value == id);
    _markers.add(marker);
    setState(() {});
  }

  void _drawStraightLine(LatLng from, LatLng to) {
    final polyline = Polyline(
      polylineId: const PolylineId('route'),
      points: [from, to],
      color: Colors.blueAccent.withOpacity(0.7),
      width: 6,
      patterns:  [PatternItem.dash(20), PatternItem.gap(10)],
      jointType: JointType.round,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    );
    setState(() {
      _polylines
        ..clear()
        ..add(polyline);
    });
  }

  void _fitMapBounds() {
    if (_mapController == null || _driverPosition == null || widget.customerPosition == null) return;
    final d = _driverPosition!;
    final c = widget.customerPosition!;
    final bounds = LatLngBounds(
      southwest: LatLng(
        d.latitude < c.latitude ? d.latitude : c.latitude,
        d.longitude < c.longitude ? d.longitude : c.longitude,
      ),
      northeast: LatLng(
        d.latitude > c.latitude ? d.latitude : c.latitude,
        d.longitude > c.longitude ? d.longitude : c.longitude,
      ),
    );
    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
  }

  void _centerToPosition(LatLng? pos) {
    if (pos != null) {
      _mapController?.animateCamera(CameraUpdate.newLatLng(pos));
    }
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("موقع السائق والعميل"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: _driverPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _driverPosition!,
              zoom: 14,
            ),
            markers: _markers,
            polylines: _polylines,
            zoomControlsEnabled: false,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (controller) {
              _mapController = controller;
              _fitMapBounds();
            },
          ),
          if (_distance != null || _duration != null)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_distance != null) ...[
                      const Icon(Icons.directions, size: 20, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(_distance!, style: const TextStyle(color: Colors.white)),
                    ],
                    if (_distance != null && _duration != null) const SizedBox(width: 16),
                    if (_duration != null) ...[
                      const Icon(Icons.timer, size: 20, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(_duration!, style: const TextStyle(color: Colors.white)),
                    ],
                  ],
                ),
              ),
            ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton.extended(
              heroTag: 'customerBtn',
              onPressed: () => _centerToPosition(widget.customerPosition),
              label: const Text("العميل"),
              icon: const Icon(Icons.home),
              backgroundColor: Colors.green,
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton.extended(
              heroTag: 'driverBtn',
              onPressed: () => _centerToPosition(_driverPosition),
              label: const Text("السائق"),
              icon: const Icon(Icons.delivery_dining),
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
