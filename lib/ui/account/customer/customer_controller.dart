import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:rent_house/constants/singleton/user_singleton.dart';
import 'package:rent_house/models/user_model.dart';
import 'package:rent_house/services/customer_service.dart';
import 'package:rent_house/utils/app_util.dart';
import 'package:rent_house/utils/toast_until.dart';

class CustomerController extends BaseController {
  String version = '';
  RxString nameUser = "".obs;

  @override
  void onInit() {
    super.onInit();
    nameUser.value = UserSingleton.instance.getUser().name ?? "";
    getCurrentVersion();
  }

  Future<void> getCurrentVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
  }

  Future<bool> getCustomerInfo() async {
    try {
      final response = await CustomerService.getCustomerInfo();
      if (response.statusCode != 200) {
        ToastUntil.toastNotification(
          description: ConstantString.accountNotFoundMessage,
          status: ToastStatus.error,
        );
        UserSingleton.instance.resetUser();
        AppUtil.signOutWithGoogle();
        return false;
      }
      final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
      UserModel userModel = UserModel.fromJson(decodedResponse['data']);
      UserSingleton.instance.setUser(userModel);
      return true;
    } catch (e) {
      ToastUntil.toastNotification(description: ConstantString.tryAgainMessage, status: ToastStatus.error);
      log("Error fetch: $e");
      return false;
    }
  }
}
