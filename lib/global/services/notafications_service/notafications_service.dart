import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> backgroundHandler(RemoteMessage message) async {}

@singleton
class NotaficationsService {
  final localNotification = FlutterLocalNotificationsPlugin();

  bool? _isInitialized = false;
  bool? get isInitialized => _isInitialized;
  Future<void> initLocalNotifications() async {
    if (_isInitialized == true) return;
    const initSettingsAndroid =
    AndroidInitializationSettings('@mipmap/launcher_icon');

    const initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    _isInitialized = await localNotification.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onLocalNotificationTap,
    );
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_channel_id',
          "Daily notifications",
          channelDescription: "Daily description channel",
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails());
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    return localNotification.show(
      id,
      title,
      body,
      notificationDetails(),
      payload: payload,
    );
  }

  void _onLocalNotificationTap(NotificationResponse response) async {
    _handleNavigations(response.payload);
  }

  Future<void> initialize() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.subscribeToTopic("menu-admin-new");

    initLocalNotifications();

    final fcmToken = await FirebaseMessaging.instance.getToken();
    final prefs = await SharedPreferences.getInstance();
    debugPrint("FCM Token: $fcmToken");
    prefs.setString("fcm_token", fcmToken ?? "");

    await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    final initialMessage = await firebaseMessaging.getInitialMessage();

    if (initialMessage != null) {
      _handleMessageOnTap(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOnTap);

    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  }

  Future<void> _handleMessageOnTap(RemoteMessage message) async {
    _handleNavigations(message.notification?.title);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      showNotification(
        title: notification.title,
        body: notification.body,
        //payload: notification.title,
        payload: jsonEncode({'target': notification.title}),
      );
    }
  }
}

Future<void> _handleNavigations(
    // String? title
    String? payload) async {
  final prefs = await SharedPreferences.getInstance();
  final signInModelString = prefs.getString("admin_data");
  if (signInModelString == null) {
    // TODO check this
    //Get.to(const SignInView());
    return;
  }
  //final signInModel = SignInModel.fromString(signInModelString);

  String? title;
  try {
    final decoded = jsonDecode(payload ?? '{}');
    title = decoded['target'];
  } catch (_) {
    title = payload;
  }

  if (title != null) {
    // TODO
    // if (title.contains("Rate")) {
    //   Get.to(RatingsView(signInModel: signInModel));
    // } else if (title.contains("order")) {
    //   Get.to(TablesView(signInModel: signInModel));
    // } else if (title.contains("invoice")) {
    //   Get.to(InvoicesView(signInModel: signInModel));
    // }
  }
}
