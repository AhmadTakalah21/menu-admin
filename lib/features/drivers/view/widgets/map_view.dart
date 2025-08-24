import 'dart:async';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user_admin/global/utils/constants.dart';
import '../../../../global/di/di.dart';
import '../../service/socket_service.dart';

/// نموذج اختيارات السائق
class DriverOption {
  final int id;
  final String name;
  final int? invoiceId;

  final double? lat; // موقع السائق
  final double? lon;

  final double? customerLat; // موقع العميل (من الفاتورة)
  final double? customerLon;

  const DriverOption({
    required this.id,
    required this.name,
    this.invoiceId,
    this.lat,
    this.lon,
    this.customerLat,
    this.customerLon,
  });

  LatLng? get driverPosition =>
      (lat != null && lon != null) ? LatLng(lat!, lon!) : null;

  LatLng? get customerPosition =>
      (customerLat != null && customerLon != null)
          ? LatLng(customerLat!, customerLon!)
          : null;

  @override
  String toString() => name;
}

class MapView extends StatefulWidget {
  final int invoiceId;
  final LatLng? initialPosition;   // موقع السائق الابتدائي (إن وُجد)
  final LatLng? customerPosition;  // موقع العميل الابتدائي (إن وُجد)

  /// تحميل قائمة السائقين لعرضها في الـ BottomSheet
  final Future<List<DriverOption>> Function()? loadDrivers;

  /// إيجاد رقم فاتورة سائق معيّن إن لم تكن ضمن DriverOption
  final Future<int?> Function(int driverId)? resolveInvoiceId;

  const MapView({
    super.key,
    required this.invoiceId,
    required this.initialPosition,
    required this.customerPosition,
    this.loadDrivers,
    this.resolveInvoiceId,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  String? _distance; // نص المسافة (API/سوكت)
  String? _duration; // زمن الوصول

  LatLng? _driverPosition;
  LatLng? _customerPosition;

  bool _loadingDrivers = false;
  List<DriverOption> _drivers = [];
  DriverOption? _selectedDriver;

  // Directions API
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );
  static const String _directionsBase =
      'https://maps.googleapis.com/maps/api/directions/json';
  String get _apiKey =>
      (AppConstants.googleMapsApiKey?.isNotEmpty ?? false)
          ? AppConstants.googleMapsApiKey!
          : ''; // إن كان فارغاً سنرسم خطاً مستقيماً

  // Socket
  SocketService get _socket => get<SocketService>();

  Timer? _recalcTimer;
  LatLng? _lastRoutedFrom;
  static const _recalcDebounce = Duration(seconds: 3);
  static const _moveThresholdMeters = 30.0;

  int? _currentInvoiceId;

  // مركز افتراضي للخريطة لو ما فيه مواقع (تكبير صغير)
  static const LatLng _fallbackCenter = LatLng(20.0, 0.0);
  static const double _fallbackZoom = 3;

  @override
  void initState() {
    super.initState();

    _currentInvoiceId = widget.invoiceId;

    _driverPosition = widget.initialPosition;
    _customerPosition = widget.customerPosition;

    if (_driverPosition != null) {
      _addOrUpdateMarker(_driverPosition!, 'driver', Colors.red);
    }
    if (_customerPosition != null) {
      _addOrUpdateMarker(_customerPosition!, 'customer', Colors.green);
      // إن كان سيرفرك يعتمد عليها
      _socket.updateUserLocation(
        _customerPosition!.latitude,
        _customerPosition!.longitude,
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _fitMapBounds());

    _bindSocketListeners();

    // لا تفتح سوكت لرقم فاتورة غير صالح
    if ((widget.invoiceId) > 0) {
      _switchToInvoice(widget.invoiceId, force: true);
    }

    _maybeRecalculateRoute(initial: true);
  }

  void _bindSocketListeners() {
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
      setState(() {
        _distance ??= distance;
        _duration ??= duration;
      });
    };
  }

  Future<void> _switchToInvoice(int invoiceId, {bool force = false}) async {
    if (invoiceId <= 0) return;
    if (!force && _currentInvoiceId == invoiceId) return;

    _currentInvoiceId = invoiceId;

    _socket.disconnect();
    _bindSocketListeners();
    _socket.initWebSocket(invoiceId);
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

  // ======== حساب/رسم المسار ========

  void _maybeRecalculateRoute({bool initial = false}) {
    final from = _driverPosition;
    final to = _customerPosition;
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
    if (_apiKey.isEmpty) {
      _drawStraightLine(from, to);
      return;
    }

    try {
      final url =
          '$_directionsBase?origin=${from.latitude},${from.longitude}'
          '&destination=${to.latitude},${to.longitude}'
          '&mode=driving&key=$_apiKey';

      final res = await _dio.get(url);

      if (res.statusCode == 200 &&
          res.data != null &&
          res.data['status'] == 'OK') {
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
            _mapController!.animateCamera(
              CameraUpdate.newLatLngBounds(bounds, 70),
            );
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

  // ======== مساعدات جغرافية ========

  List<LatLng> _decodePolyline(String encoded) {
    final List<LatLng> poly = [];
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
    double x0 = list.first.latitude, x1 = list.first.latitude;
    double y0 = list.first.longitude, y1 = list.first.longitude;
    for (final p in list) {
      if (p.latitude > x1) x1 = p.latitude;
      if (p.latitude < x0) x0 = p.latitude;
      if (p.longitude > y1) y1 = p.longitude;
      if (p.longitude < y0) y0 = p.longitude;
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

  // ======== ماركر/خط مستقيم/كاميرا ========

  void _addOrUpdateMarker(LatLng position, String id, Color color) {
    final marker = Marker(
      markerId: MarkerId(id),
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(
        color == Colors.red
            ? BitmapDescriptor.hueRed
            : BitmapDescriptor.hueGreen,
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
      patterns: [PatternItem.dash(20), PatternItem.gap(10)],
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
    if (_mapController == null ||
        _driverPosition == null ||
        _customerPosition == null) return;
    final d = _driverPosition!;
    final c = _customerPosition!;
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

  // ======== اختيار السائق ========

  void _openDriverPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, sbSet) {
            if (_drivers.isEmpty && !_loadingDrivers) {
              _loadingDrivers = true;
              Future.microtask(() async {
                try {
                  final list = await (widget.loadDrivers?.call() ??
                      Future.value(<DriverOption>[]));
                  if (!mounted) return;
                  setState(() {
                    _drivers = list;
                    _loadingDrivers = false;
                  });
                  sbSet(() {});
                } catch (_) {
                  if (!mounted) return;
                  setState(() => _loadingDrivers = false);
                  sbSet(() {});
                }
              });
            }

            return SafeArea(
              child: SizedBox(
                height: 460,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'اختيار السائق',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'اختر السائق لمتابعة توصيل فاتورته وعرض أفضل مسار.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: _loadingDrivers
                          ? const Center(child: CircularProgressIndicator())
                          : (_drivers.isEmpty
                          ? const Center(child: Text('لا يوجد سائقون متاحون'))
                          : ListView.separated(
                        itemCount: _drivers.length,
                        separatorBuilder: (_, __) =>
                        const Divider(height: 1),
                        itemBuilder: (_, i) {
                          final d = _drivers[i];
                          final selected =
                              _selectedDriver?.id == d.id;
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: selected
                                  ? Colors.green
                                  : Colors.blueGrey.shade200,
                              child: const Icon(Icons.delivery_dining,
                                  color: Colors.white),
                            ),
                            title: Text(
                              d.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700),
                            ),
                            subtitle: Row(
                              children: [
                                if (d.invoiceId != null)
                                  Padding(
                                    padding:
                                    const EdgeInsetsDirectional
                                        .only(end: 8),
                                    child: Chip(
                                      label: Text(
                                          'فاتورة ${d.invoiceId}'),
                                      labelStyle:
                                      const TextStyle(fontSize: 11),
                                      backgroundColor:
                                      Colors.grey.shade100,
                                      side: BorderSide(
                                          color: Colors.grey.shade300),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                if (d.lat != null && d.lon != null)
                                  Text(
                                    '(${d.lat!.toStringAsFixed(4)}, ${d.lon!.toStringAsFixed(4)})',
                                    style:
                                    const TextStyle(fontSize: 12),
                                  ),
                              ],
                            ),
                            trailing: selected
                                ? const Icon(Icons.check_circle,
                                color: Colors.green)
                                : const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.pop(ctx);
                              _onDriverChosen(d);
                            },
                          );
                        },
                      )),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onDriverChosen(DriverOption d) async {
    setState(() => _selectedDriver = d);

    // حدّث موقع العميل أولاً إن متوفر من DriverOption
    if (d.customerLat != null && d.customerLon != null) {
      _customerPosition = LatLng(d.customerLat!, d.customerLon!);
      _addOrUpdateMarker(_customerPosition!, 'customer', Colors.green);
    }

    // حدّث موقع السائق إن متوفر
    if (d.lat != null && d.lon != null) {
      final pos = LatLng(d.lat!, d.lon!);
      _driverPosition = pos;
      _addOrUpdateMarker(pos, 'driver', Colors.red);
    }

    _fitMapBounds();

    // تحديد رقم الفاتورة
    int? invId = d.invoiceId;
    if (invId == null && widget.resolveInvoiceId != null) {
      try {
        invId = await widget.resolveInvoiceId!(d.id);
      } catch (_) {}
    }

    if (invId != null) {
      await _switchToInvoice(invId, force: true);
    }

    _maybeRecalculateRoute(initial: true);
  }

  // ======== UI ========

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    // الهدف الأولي للكاميرا (حتى لو ما فيه سائق/عميل)
    final LatLng initialTarget =
        _driverPosition ?? _customerPosition ?? _fallbackCenter;
    final double initialZoom =
    (_driverPosition != null || _customerPosition != null) ? 14 : _fallbackZoom;

    return Scaffold(
      appBar: AppBar(
        title: const Text("موقع السائق والعميل"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: initialTarget,
              zoom: initialZoom,
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

          // تلميح أعلى لو لسه ما اخترنا سائق
          if (_driverPosition == null)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'اختر السائق من الزر بالأسفل لبدء المتابعة.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

          // شريط معلومات المسافة/المدة
          if (_distance != null || _duration != null)
            Positioned(
              top: _driverPosition == null ? 64 : 16,
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
                    if (_distance != null && _duration != null)
                      const SizedBox(width: 16),
                    if (_duration != null) ...[
                      const Icon(Icons.timer, size: 20, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(_duration!, style: const TextStyle(color: Colors.white)),
                    ],
                  ],
                ),
              ),
            ),

          // أزرار تركيز
          Positioned(
            bottom: 90 + bottomPadding,
            left: 20,
            child: FloatingActionButton.extended(
              heroTag: 'customerBtn',
              onPressed: () => _centerToPosition(_customerPosition),
              label: const Text("العميل"),
              icon: const Icon(Icons.home),
              backgroundColor: Colors.green,
            ),
          ),
          Positioned(
            bottom: 90 + bottomPadding,
            right: 20,
            child: FloatingActionButton.extended(
              heroTag: 'driverBtn',
              onPressed: () => _centerToPosition(_driverPosition),
              label: const Text("السائق"),
              icon: const Icon(Icons.delivery_dining),
              backgroundColor: Colors.red,
            ),
          ),

          // زر اختيار السائق (يظهر دائماً)
          Positioned(
            bottom: 20 + bottomPadding,
            left: 20,
            right: 20,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.blueGrey.shade800,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _openDriverPicker,
                icon: const Icon(Icons.person_search),
                label: Text(
                  _selectedDriver == null
                      ? 'اختيار السائق'
                      : 'السائق: ${_selectedDriver!.name}',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
