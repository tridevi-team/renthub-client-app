import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:rent_house/constants/singleton/province_singleton.dart';
import 'package:rent_house/constants/singleton/user_singleton.dart';
import 'package:rent_house/models/province/city.dart';
import 'package:rent_house/models/province/district.dart';
import 'package:rent_house/services/notification_service.dart';
import 'package:rent_house/ui/account/customer/customer_controller.dart';
import 'package:rent_house/ui/notification/notification_controller.dart';
import 'package:rent_house/ui/signin/signin_screen.dart';
import 'package:rent_house/untils/dialog_util.dart';
import 'package:rent_house/untils/local_notification_util.dart';
import 'package:rent_house/untils/shared_pref_helper.dart';
import 'package:rent_house/untils/toast_until.dart';
import 'package:rent_house/widgets/textfield/text_input_widget.dart';

class BottomNavBarController extends FullLifeCycleController {
  late PageController pageController;
  NotificationController notificationController = Get.put(NotificationController());

  RxInt selectedIndex = 0.obs;
  Timer? forceSetFirebaseBackgroundTimer;
  int forceSetFirebaseBackgroundTimerCount = 60;
  List<City> provinces = <City>[];

  RxString currentLabelCity = "Thành phố".obs;
  RxList<City> filteredCities = <City>[].obs;
  Rxn<City> citySelected = Rxn<City>();
  City cityTemp = City();

  RxString currentLabelDistrict = "Quận / Huyện".obs;
  RxList<District> filteredDistricts = <District>[].obs;
  Rxn<District> districtSelected = Rxn<District>();
  District districtTemp = District();

  RxBool isLogin = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkAndRegisterNotification();
    pageController = PageController(initialPage: selectedIndex.value);
    provinces = ProvinceSingleton.instance.provinces;

    currentLabelCity.value = '${provinces[0].name}';
    citySelected.value = provinces[0];
    filteredCities.addAll([...provinces]);
    cityTemp = provinces[0];
    filteredDistricts.addAll([...citySelected.value?.districts ?? []]);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initData();
      if (Get.isRegistered<CustomerController>()) {
        final currentCustomerController = Get.find<CustomerController>();
        currentCustomerController.user.value = UserSingleton.instance.getUser();
      }

      await DialogUtil.showDialogSelectLocation(onLocationTap: (bool isDistrict) {
        onTapOpenCityList(isDistrict: isDistrict);
      });
    });
  }

  void onItemTapped(int value) {
    if (!isLogin.value) {
      redirectToLogin();
      return;
    }
    selectedIndex.value = value;
    pageController.jumpToPage(value);
  }

  Future<void> checkAndRegisterNotification() async {
    if (await Permission.notification.isGranted) {
      await _registerFirebaseNotification();
    } else {
      await _requestAndHandlePermission();
    }
    await NotificationService.saveFcmTokenToFirestore();
  }

  Future<void> _requestAndHandlePermission() async {
    await Firebase.initializeApp();
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
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
    return settings.authorizationStatus == AuthorizationStatus.authorized || settings.authorizationStatus == AuthorizationStatus.provisional;
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
        bool isValidAccessToken = JwtDecoder.isExpired(SharedPrefHelper.instance.getString(ConstantString.prefAccessToken) ?? '');
        if (isValidAccessToken) {
          LocalNotificationUtil.createNotification(message);
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle opened app from notification
    });
  }

  List<Widget> listLocationItem({bool isDistrict = false}) {
    List<Widget> list = [];

    final List<dynamic> filteredLocations = isDistrict ? filteredDistricts : filteredCities;
    final dynamic selectedLocation = isDistrict ? districtSelected.value : citySelected.value;

    for (var location in filteredLocations) {
      list.add(InkWell(
        onTap: () {
          if (isDistrict) {
            districtSelected.value = location as District;
          } else {
            citySelected.value = location as City;
          }
        },
        child: ListTile(
          title: Text(
            location.name ?? "",
            style: TextStyle(
              color: const Color(0xff1C1D1F),
              fontWeight: selectedLocation?.name == location.name ? FontWeight.w500 : FontWeight.w400,
              fontSize: 14,
            ),
          ),
          trailing: selectedLocation?.name == location.name ? SvgPicture.asset(AssetSvg.iconCheckMark, color: AppColors.primary1) : const SizedBox.shrink(),
        ),
      ));
    }

    return list;
  }

  void onTapOpenCityList({bool isDistrict = false}) {
    Get.bottomSheet(
      enableDrag: false,
      ignoreSafeArea: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      WillPopScope(
        onWillPop: () {
          Get.back();
          onSelectedCancel();
          return Future.value(true);
        },
        child: Column(
          children: [
            const SizedBox(height: 90),
            Expanded(
              child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  height: Get.height - 90,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SafeArea(
                              child: Text(
                                isDistrict ? 'Chọn Quận / huyện' : 'Chọn Thành phố',
                                style: const TextStyle(
                                  color: AppColors.neutral1B1A19,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextInputWidget(
                              colorBorder: AppColors.neutral8F8D8A,
                              fillColor: Colors.white,
                              hintText: 'Tìm kiếm',
                              height: 48,
                              onChanged: (value) {
                                onFilterCity(value, isDistrict: isDistrict);
                              },
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, thickness: 1, color: Color(0xffF4F4F4)),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Obx(() => Column(
                                children: listLocationItem(isDistrict: isDistrict),
                              )),
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey),
                    top: BorderSide(color: Color(0xffF4F4F4)),
                  )),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        Future.delayed(const Duration(milliseconds: 300), () {
                          Get.back();
                          onSelectedCancel();
                        });
                      },
                      child: Text('Hủy', style: ConstantFont.regularText),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        Get.back();
                        if (isDistrict) {
                          setSelectedDistrict();
                        } else {
                          setSelectedCity();
                        }
                      },
                      style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(AppColors.primary1)),
                      child: Text('Xác nhận', style: ConstantFont.regularText.copyWith(color: AppColors.white)),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void onSelectedCancel() {
    citySelected.value = cityTemp;
    districtSelected.value = districtTemp;
    filteredCities.clear();
    filteredCities.addAll(provinces);
    filteredDistricts.clear();
    filteredDistricts.addAll(citySelected.value?.districts ?? []);
  }

  void setSelectedCity() {
    filteredDistricts.clear();
    currentLabelCity.value = citySelected.value?.name ?? '';
    cityTemp = citySelected.value ?? cityTemp;
    clearDistrict();
  }

  void clearDistrict() {
    currentLabelDistrict.value = 'Quận / Huyện';
    districtTemp = District();
    filteredDistricts.addAll(citySelected.value?.districts ?? []);
  }

  void setSelectedDistrict() {
    districtTemp = districtSelected.value ?? districtTemp;
    currentLabelDistrict.value = districtSelected.value?.name ?? '';
  }

  void onFilterCity(String searchValue, {bool isDistrict = false}) {
    if (isDistrict) {
      filteredDistricts.clear();
      filteredDistricts.addAll(citySelected.value?.districts?.where((district) => district.name?.toLowerCase().contains(searchValue.toLowerCase()) ?? false) ?? []);
    } else {
      filteredCities.clear();
      filteredCities.addAll(provinces.where((city) => city.name != null && city.name!.toLowerCase().contains(searchValue.toLowerCase())));
    }
  }

  void initData() {
    checkIsLogin();
    if (isLogin.value) {
      Future.wait([notificationController.getNotificationsCount()]);
    }
  }

  void checkIsLogin() {
    if (UserSingleton.instance.getUser().id != null) {
      isLogin.value = true;
    } else {
      isLogin.value = false;
    }
  }

  void redirectToLogin() {
    ToastUntil.toastNotification(description: 'Bạn cần đăng nhập để sử dụng chức năng này.', status: ToastStatus.warning);
    Get.to(() => SignInScreen());
  }
}
