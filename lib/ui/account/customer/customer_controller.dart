import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/singleton/user_singleton.dart';
import 'package:rent_house/models/user_model.dart';
import 'package:rent_house/services/customer_service.dart';
import 'package:rent_house/ui/home/home_screen/home_controller.dart';
import 'package:rent_house/untils/app_util.dart';
import 'package:rent_house/untils/toast_until.dart';

class CustomerController extends BaseController {
  String version = '';
  Rx<UserModel> user = UserModel().obs;

  @override
  void onInit() {
    super.onInit();
    user.value = UserSingleton.instance.getUser();
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
          description: "Tài khoản không tồn tại trong hệ thống. Vui lòng liên hệ với quản lý toà nhà.",
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
      ToastUntil.toastNotification(description: "Có lỗi xảy ra. Vui lòng thử lại.", status: ToastStatus.error);
      log("Error fetch: $e");
      return false;
    }
  }
}
