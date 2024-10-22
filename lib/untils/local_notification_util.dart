import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rent_house/constants/app_colors.dart';


class LocalNotificationUtil {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(const AndroidNotificationChannel(
          'renthub_notification', // id
          'renthub_notification_title_description', // title description
          importance: Importance.high,
        ));
    const InitializationSettings initializationSettings = InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher_notification'), iOS: DarwinInitializationSettings());
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse, onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  static void createNotification(RemoteMessage message) async {
    try {
      BigPictureStyleInformation? bigPictureStyleInformation;
      try {
        final response = await http.get(Uri.parse(message.notification?.android?.imageUrl ?? ''));
        bigPictureStyleInformation =
        BigPictureStyleInformation(
          ByteArrayAndroidBitmap.fromBase64String(base64Encode(response.bodyBytes)),
          largeIcon: ByteArrayAndroidBitmap.fromBase64String(base64Encode(response.bodyBytes)),
        );
      } catch (_) {}

      NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'renthub_notification',
          'renthub_notification_title_description',
          importance: Importance.max,
          priority: Priority.max,
          color: AppColors.primary1,
          icon: '@mipmap/ic_launcher_notification',
          styleInformation: bigPictureStyleInformation,
        ),
      );
      await flutterLocalNotificationsPlugin.show(message.hashCode, message.notification?.title, message.notification?.body, notificationDetails,
          payload: json.encode(
            message.data,
          ),

      );
    } on Exception catch (e, tr) {
      print(tr);
      print('Firebase Message Error ${e.toString()}');
    }
  }

  static void onDidReceiveBackgroundNotificationResponse(NotificationResponse notificationResponse) {
    if (notificationResponse.payload != null) {

    }
  }

  static void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) {
    if (notificationResponse.payload != null) {

    }
  }


}
