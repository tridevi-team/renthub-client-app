import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:rent_house/constants/singleton/renter_singleton.dart';

class NotificationService {
  static Future<void> saveFcmTokenToFirestore() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    if (fcmToken != null) {
      FirebaseFirestore db = FirebaseFirestore.instance;
      Map<String, dynamic> data = { "FCM": fcmToken };
      String? uuid = UserSingleton.instance.getUser().id;
      if (uuid == null) {
        return;
      }
      await db.collection("renter_device").doc(uuid).set(data);
    } else {
      if (kDebugMode) {
        print("Failed to retrieve FCM token.");
      }
    }
  }
}