import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/untils/app_util.dart';


class LocalNotificationUtil {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(const AndroidNotificationChannel(
          'renthub_notification', // id
          'renthub_notification_description', // title description
          importance: Importance.high,
        ));
    const InitializationSettings initializationSettings = InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher'), iOS: DarwinInitializationSettings());
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse, onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  static Future<void> createNotification(RemoteMessage message) async {
    BigPictureStyleInformation? bigPictureStyleInformation;
    if (message.notification?.android?.imageUrl != null) {
      try {
        final response = await http.get(Uri.parse(message.notification!.android!.imageUrl!));
        bigPictureStyleInformation = BigPictureStyleInformation(
          ByteArrayAndroidBitmap.fromBase64String(base64Encode(response.bodyBytes)),
          largeIcon: ByteArrayAndroidBitmap.fromBase64String(base64Encode(response.bodyBytes)),
        );
      } catch (e) {
        AppUtil.printDebugMode(type: 'Failed to download notification image', message: "$e");
      }
    }

    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'renthub_notification',
        'renthub_notification_description',
        importance: Importance.max,
        priority: Priority.max,
        color: AppColors.primary1,
        icon: '@mipmap/ic_launcher',
        styleInformation: bigPictureStyleInformation,
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? 'No title',
      message.notification?.body ?? 'No body',
      notificationDetails,
      payload: json.encode(message.data),
    );
  }

  static void onDidReceiveBackgroundNotificationResponse(NotificationResponse notificationResponse) {
    if (notificationResponse.payload != null) {
      AppUtil.printDebugMode(type: 'Background notification response', message: "$notificationResponse");
    }
  }

  static void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) {
    if (notificationResponse.payload != null) {
      AppUtil.printDebugMode(type: 'Background notification response', message: "$notificationResponse");

    }
  }


}
