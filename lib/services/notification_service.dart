import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:rent_house/constants/singleton/user_singleton.dart';
import 'package:rent_house/untils/app_util.dart';

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
      Map<String, dynamic> data = { "FCM": fcmToken };

      await db
          .collection("users")
          .doc(uuid)
          .collection("devices")
          .doc(device)
          .set(data, SetOptions(merge: true));

      if (kDebugMode) {
        print("FCM token saved successfully for device: $device");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error saving FCM token to Firestore: $e");
      }
    }
  }
}
