import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:rent_house/constants/singleton/token_singleton.dart';
import 'package:rent_house/ui/signin/signin_screen.dart';
import 'package:rent_house/untils/shared_pref_helper.dart';

class AppUtil {
  AppUtil._();

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => SignInScreen());
    await SharedPrefHelper.instance.removeString(ConstantString.prefToken);
    await SharedPrefHelper.instance.removeString(ConstantString.prefRefreshToken);
    TokenSingleton.instance.setAccessToken('');
    TokenSingleton.instance.setRefreshToken('');
  }
}