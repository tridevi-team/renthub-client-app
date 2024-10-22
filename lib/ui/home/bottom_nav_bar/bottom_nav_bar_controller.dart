import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rent_house/ui/home/home_screen/home_controller.dart';
import 'package:rent_house/untils/local_notification_util.dart';

class BottomNavBarController extends FullLifeCycleController {
  late PageController pageController;
  RxInt selectedIndex = 0.obs;
  final homeController = Get.put(HomeController());
  Timer? forceSetFirebaseBackgroundTimer;
  int forceSetFirebaseBackgroundTimerCount = 60;

  @override
  void onInit() {
    super.onInit();
    checkAndRegisterNotification();
    pageController = PageController(initialPage: selectedIndex.value);
  }

  void onItemTapped(int value) => selectedIndex.value = value;

  Future<void> getListProvince() async {
    try {
      final response = await HomeService.fetchProvinces();
      ResponseErrorUtil.handleErrorResponse(response.statusCode, response.body);
      final decodedResponse = jsonDecode(response.body) as List<dynamic>;
      if (decodedResponse.isNotEmpty) {
        List<City> provinces = decodedResponse.map((json) => City.fromJson(json)).toList();
        ProvinceSingleton.instance.setProvinces(provinces);
      }
    } catch (e) {
      ToastUntil.toastNotification('Error fetching provinces', '$e', ToastStatus.error);
      print("Error fetching provinces: $e");
    }
  }
}
  void onItemTapped(int value) {
    selectedIndex.value = value;
    pageController.jumpToPage(value);
  }

  Future<void> checkAndRegisterNotification() async {
    if (await Permission.notification.isGranted) {
      await _registerFirebaseNotification();
    } else {
      await _requestAndHandlePermission();
    }
  }

  Future<void> _requestAndHandlePermission() async {
    await Firebase.initializeApp();
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true, badge: true, sound: true,
    );

    bool isPermissionAllowed = _isPermissionGranted(settings);

    if (!isPermissionAllowed) {
      if (Platform.isAndroid) {
        LocalNotificationUtil.createNotification(const RemoteMessage(
          notification: RemoteNotification(
            title: 'Request Notification Permission',
            body: 'Please enable notifications',
          ),
        ));
      }
      _startPermissionCheckTimer();
    } else {
      await _registerFirebaseNotification();
    }
  }

  bool _isPermissionGranted(NotificationSettings settings) {
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  void _startPermissionCheckTimer() {
    forceSetFirebaseBackgroundTimer = Timer.periodic(
      const Duration(milliseconds: 500),
          (timer) async {
        forceSetFirebaseBackgroundTimerCount -= 1;
        if (forceSetFirebaseBackgroundTimerCount == 0) {
          timer.cancel();
        }
        if (await Permission.notification.isGranted) {
          timer.cancel();
          await _registerFirebaseNotification();
        }
      },
    );
  }

  Future<void> _registerFirebaseNotification() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      // LocalNotificationUtil.handleJsonMessage(json.encode(initialMessage.data));
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (Platform.isAndroid) {
        LocalNotificationUtil.createNotification(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle opened app from notification
    });
  }
}
