import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:rent_house/constants/singleton/token_singleton.dart';
import 'package:rent_house/services/auth_service.dart';
import 'package:rent_house/ui/signin/signin_screen.dart';
import 'package:rent_house/untils/shared_pref_helper.dart';

class AppUtil {
  AppUtil._();

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => SignInScreen());
    await SharedPrefHelper.instance.removeString(ConstantString.prefAccessToken);
    await SharedPrefHelper.instance.removeString(ConstantString.prefRefreshToken);
    TokenSingleton.instance.setAccessToken('');
    TokenSingleton.instance.setRefreshToken('');
  }

  static Future<void> autoRefreshToken() async {
    final appTypeToken = SharedPrefHelper.instance.getString(ConstantString.prefAppType);
    final refreshToken = SharedPrefHelper.instance.getString(ConstantString.prefRefreshToken);
    String accessToken = '';

    if (appTypeToken == ConstantString.prefTypeEmail || appTypeToken == ConstantString.prefTypePhone) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        accessToken = await user.getIdToken(true) ?? '';
      }
    } else if (refreshToken?.isNotEmpty ?? false) {
      try {
        final response = await AuthService.refreshToken(refreshToken!);
        final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
        accessToken = decodedResponse["accessToken"] ?? '';
      } catch (e) {
        print("Lỗi khi refresh token: $e");

      }
    }

    if (accessToken.isNotEmpty) {
      TokenSingleton.instance.setAccessToken(accessToken);
      await SharedPrefHelper.instance.saveString(ConstantString.prefAccessToken, accessToken);
    }

    if (refreshToken?.isNotEmpty ?? false) {
      TokenSingleton.instance.setRefreshToken(refreshToken!);
      await SharedPrefHelper.instance.saveString(ConstantString.prefRefreshToken, refreshToken);
    }
  }

}