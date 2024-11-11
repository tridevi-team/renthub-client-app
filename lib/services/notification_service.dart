import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:rent_house/base/base_service.dart';
import 'package:rent_house/constants/singleton/user_singleton.dart';
import 'package:rent_house/untils/app_util.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static Future<void> saveFcmTokenToFirestore() async {
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken == null) {
        if (kDebugMode) {
          print("Failed to retrieve FCM token.");
        }
        return;
      }

      String? uuid = UserSingleton.instance.getUser().id;
      if (uuid == null) {
        if (kDebugMode) {
          print("User ID is null, cannot save FCM token.");
        }
        return;
      }

      String? device = await AppUtil.getUniqueDeviceId();
      if (device.isEmpty) {
        if (kDebugMode) {
          print("Device ID is null or empty, cannot save FCM token.");
        }
        return;
      }

      FirebaseFirestore db = FirebaseFirestore.instance;
      Map<String, dynamic> data = {"FCM": fcmToken};

      await db.collection("users").doc(uuid).collection("devices").doc(device).set(data, SetOptions(merge: true));

      if (kDebugMode) {
        print("FCM token saved successfully for device: $device");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error saving FCM token to Firestore: $e");
      }
    }
  }

  static Future<http.Response> fetchHouseInformation(String houseId) {
    String endpoint = '/notifications/list';
    return BaseService.requestApi(endpoint: endpoint, httpMethod: HttpMethod.get, auth: true);
  }

  static Future<http.Response> getAllNotifications(String sort, String filters, int page, {int pageSize = 10}) {
    String endpoint = '/notifications/list?$filters$sort&page=$page&pageSize=$pageSize';
    return BaseService.requestApi(endpoint: endpoint, httpMethod: HttpMethod.get, auth: true);
  }

  static Future<http.Response> fetchNotificationCount() {
    String endpoint = '/notifications/count';
    return BaseService.requestApi(endpoint: endpoint, httpMethod: HttpMethod.get, auth: true);
  }

  static Future<http.Response> markNotificationAsRead(Map<String, dynamic> data) {
    String endpoint = '/notifications/update';
    return BaseService.requestApi(endpoint: endpoint, httpMethod: HttpMethod.put, params: data, auth: true);
  }

  static Future<http.Response> removeNotification() {
    String endpoint = '/notifications/delete';
    return BaseService.requestApi(endpoint: endpoint, httpMethod: HttpMethod.delete, auth: true);
  }
}
