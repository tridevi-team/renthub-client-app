import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/utils/app_util.dart';

class QrScanController extends BaseController with WidgetsBindingObserver {

  RxBool isCameraGranted = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    requestCameraPermission();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResume();
    }
  }

  Future<void> onResume() async {
    await requestCameraPermission();
  }

  Future<void> requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.request();
    isCameraGranted.value = status == PermissionStatus.granted;
  }

  Future<void> openSettings() async {
    bool isOpened = await openAppSettings();
    if (!isOpened) {
      AppUtil.printDebugMode(type: "Error OpenSettings", message: 'Failed to open app settings.');
    }
  }
}
