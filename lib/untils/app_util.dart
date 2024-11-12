import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:rent_house/constants/singleton/token_singleton.dart';
import 'package:rent_house/constants/singleton/user_singleton.dart';
import 'package:rent_house/services/auth_service.dart';
import 'package:rent_house/ui/signin/signin_screen.dart';
import 'package:rent_house/untils/shared_pref_helper.dart';

class AppUtil {
  AppUtil._();

  static Future<void> logout() async {
    try {
      await Future.wait([
        signOutWithGoogle(),
        _clearLocalStorage(),
      ]);

      TokenSingleton.instance.setAccessToken('');
      TokenSingleton.instance.setRefreshToken('');
      UserSingleton.instance.resetUser();

      Get.offAll(() => SignInScreen());
    } catch (e) {
      print("Error during logout: $e");
    }
  }

  static Future<void> signOutWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();

        await googleSignIn.disconnect().catchError((e) => print('Error during disconnect: $e'));
      }

      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print("Error during Google Sign Out: $e");
    }
  }

  static Future<void> _clearLocalStorage() async {
    try {
      await Future.wait([
        SharedPrefHelper.instance.removeString(ConstantString.prefAccessToken),
        SharedPrefHelper.instance.removeString(ConstantString.prefRefreshToken),
      ]);
    } catch (e) {
      print("Error clearing local storage: $e");
    }
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

  static Future<String> getUniqueDeviceId() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        return iosInfo.identifierForVendor ?? "Unknown iOS ID";
      }
    } catch (e) {
      print('Error getting device unique ID: $e');
    }
    return "Unknown Device ID";
  }
}
