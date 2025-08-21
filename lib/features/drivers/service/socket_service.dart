// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../model/driver_model/driver_model.dart';

@injectable
class SocketService {
  double? userLatitude, userLongitude;
  double? driverLatitude, driverLongitude;

  void Function(double lat, double lon)? onDriverLocationUpdate;
  void Function(DriverModel order)? onOrderUpdated;
  void Function(String distance, String duration)? onDistanceUpdate;

  WebSocketChannel? _channel;
  bool _connected = false;
  bool _manuallyClosed = false;

  Timer? _pingTimer;
  static const _reconnectDelay = Duration(seconds: 3);
  static const _pingInterval = Duration(seconds: 50);

  void initWebSocket(int orderId) {
    _manuallyClosed = false;
    _connected = false;
    _stopPing();
    _channel?.sink.close();

    _channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.1.49:8080/app/bqfkpognxb0xxeax5bjc'),
    );

    _channel!.stream.listen(
          (message) => _handleMessage(message, orderId),
      onError: (err) {
        if (kDebugMode) print('❌ WS error: $err');
        _scheduleReconnect(orderId);
      },
      onDone: () {
        if (kDebugMode) print('🔌 WS closed (connected=$_connected, manual=$_manuallyClosed)');
        if (!_manuallyClosed) _scheduleReconnect(orderId);
      },
      cancelOnError: false,
    );
  }

  void _handleMessage(dynamic message, int orderId) {
    if (kDebugMode) print('📩 $message');
    Map<String, dynamic>? frame;
    try {
      frame = jsonDecode(message as String) as Map<String, dynamic>;
    } catch (_) {
      if (kDebugMode) print('❌ JSON decode fail');
      return;
    }

    final event = frame['event'];
    dynamic data = frame['data'];

    // بعض الخوادم تُرسل data كسلسلة JSON دومًا
    if (data is String) {
      try { data = jsonDecode(data); } catch (_) {}
    }

    switch (event) {
      case 'pusher:connection_established':
        _connected = true;
        _startPing();
        _subscribe(orderId);
        return;

      case 'pusher:pong':
      // keep-alive OK
        return;

      case 'pusher_internal:subscription_succeeded':
        if (kDebugMode) print('✅ subscribed');
        return;

      case 'client-locationUpdated':
        _applyDriverPoint(
          _toDouble(data?['latitude']),
          _toDouble(data?['longitude']),
        );
        return;

      default:
      // رسائل order.*
        if (event is String && event.startsWith('order.')) {
          _handleOrderPayload(data);
        }
    }
  }

  void _handleOrderPayload(dynamic data) {
    // ابحث عن الـ Map الفعلية للطلب:
    // قد تكون data مباشرة، أو data.data، أو data.data[0]
    dynamic payload = data;
    if (payload is Map && payload['data'] != null) {
      payload = payload['data'];
    }
    if (payload is List && payload.isNotEmpty) {
      payload = payload.first;
    }
    if (payload is! Map) return;

    try {
      final order = DriverModel.fromJson(payload as Map<String, dynamic>);
      onOrderUpdated?.call(order);

      final lat = _toDouble(payload['latitude']);
      final lon = _toDouble(payload['longitude']);
      _applyDriverPoint(lat, lon);
    } catch (e) {
      if (kDebugMode) print('❌ order parse fail: $e');
    }
  }

  void _applyDriverPoint(double? lat, double? lon) {
    if (lat == null || lon == null) return;

    driverLatitude = lat;
    driverLongitude = lon;
    onDriverLocationUpdate?.call(lat, lon);

    if (userLatitude != null && userLongitude != null) {
      final meters = calculateDistance(userLatitude!, userLongitude!, lat, lon);
      final distanceStr = '${(meters / 1000).toStringAsFixed(1)} كم';
      final minutes = (meters / (40 * 1000 / 60)).round();
      final durationStr = '$minutes دقيقة';
      onDistanceUpdate?.call(distanceStr, durationStr);
    }
  }

  void _subscribe(int invoiceId) {
    final frame = {
      'event': 'pusher:subscribe',
      'data': {'channel': 'order.$invoiceId'},
    };
    _send(frame);
    if (kDebugMode) print('🔄 subscribing order.$invoiceId …');
  }

  void _send(Map<String, dynamic> frame) {
    try {
      _channel?.sink.add(jsonEncode(frame));
    } catch (e) {
      if (kDebugMode) print('❌ send error: $e');
    }
  }

  void _startPing() {
    _stopPing();
    _pingTimer = Timer.periodic(_pingInterval, (_) {
      _send({'event': 'pusher:ping', 'data': {}});
    });
  }

  void _stopPing() {
    _pingTimer?.cancel();
    _pingTimer = null;
  }

  void _scheduleReconnect(int orderId) {
    _connected = false;
    if (_manuallyClosed) return;
    _stopPing();
    Future.delayed(_reconnectDelay, () {
      if (_manuallyClosed) return;
      if (kDebugMode) print('⚡️ reconnecting …');
      initWebSocket(orderId);
    });
  }

  // API عامّة
  void disconnect() {
    _manuallyClosed = true;
    _connected = false;
    _stopPing();
    _channel?.sink.close();
    _channel = null;
  }

  void updateUserLocation(double latitude, double longitude) {
    userLatitude = latitude;
    userLongitude = longitude;
  }

  // Haversine (متر)
  double calculateDistance(double userLat, double userLon, double driverLat, double driverLon) {
    const R = 6371000.0;
    final dLat = _deg2rad(driverLat - userLat);
    final dLon = _deg2rad(driverLon - userLon);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(userLat)) * cos(_deg2rad(driverLat)) *
            sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  // Helpers
  double _deg2rad(double x) => x * (pi / 180.0);
  double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  double? getDriverLatitude()  => driverLatitude;
  double? getDriverLongitude() => driverLongitude;
  bool get isConnected => _connected;
}
