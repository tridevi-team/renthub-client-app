import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:rent_house/constants/singleton/token_singleton.dart';
import 'package:rent_house/constants/singleton/user_singleton.dart';
import 'package:rent_house/services/auth_service.dart';
import 'package:rent_house/ui/signin/signin_screen.dart';
import 'package:rent_house/untils/extensions/string_extension.dart';
import 'package:rent_house/untils/format_util.dart';
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
      AppUtil.printDebugMode(type: "Error Logout", message: '$e');
    }
  }

  static Future<void> signOutWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();

        await googleSignIn.disconnect().catchError((e) {
          printDebugMode(type: 'Error Google disconnect', message: e);
          return null;
        });
      }

      await FirebaseAuth.instance.signOut();
    } catch (e) {
      printDebugMode(type: 'Error Google SignOut', message: '$e');
    }
  }

  static Future<void> _clearLocalStorage() async {
    try {
      await Future.wait([
        SharedPrefHelper.instance.removeString(ConstantString.prefAccessToken),
        SharedPrefHelper.instance.removeString(ConstantString.prefRefreshToken),
      ]);
    } catch (e) {
      AppUtil.printDebugMode(type: 'Error clear Local Storage', message: "$e");
    }
  }

  static Future<bool> autoRefreshToken() async {
    try {
      final appTypeToken = SharedPrefHelper.instance.getString(ConstantString.prefAppType);
      final refreshToken = SharedPrefHelper.instance.getString(ConstantString.prefRefreshToken);
      String accessToken = '';

      if (appTypeToken == ConstantString.prefTypeEmail ||
          appTypeToken == ConstantString.prefTypePhone) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          accessToken = await user.getIdToken(true) ?? '';
        } else {
          AppUtil.printDebugMode(type: 'Error', message: 'Firebase user is null.');
          return false;
        }
      } else if (refreshToken?.isNotEmpty ?? false) {
        try {
          final response = await AuthService.refreshToken(refreshToken!);
          if (response.statusCode == 200) {
            final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
            accessToken = decodedResponse["data"]["accessToken"] ?? '';
            if (accessToken.isEmpty) {
              AppUtil.printDebugMode(type: 'Error', message: 'Access token missing in response.');
              return false;
            }
          } else {
            AppUtil.printDebugMode(
                type: 'Error', message: 'Invalid response status: ${response.statusCode}');
            return false;
          }
        } catch (e) {
          AppUtil.printDebugMode(type: 'Error Refresh Token', message: "$e");
          return false;
        }
      }

      if (accessToken.isNotEmpty) {
        TokenSingleton.instance.setAccessToken(accessToken);
        await SharedPrefHelper.instance.saveString(ConstantString.prefAccessToken, accessToken);
        if (refreshToken?.isNotEmpty ?? false) {
          TokenSingleton.instance.setRefreshToken(refreshToken!);
          await SharedPrefHelper.instance.saveString(ConstantString.prefRefreshToken, refreshToken);
        }
        return true;
      }
    } catch (e) {
      AppUtil.printDebugMode(type: 'Error', message: 'Unexpected error: $e');
    }

    return false;
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
      AppUtil.printDebugMode(type: 'Error getting device unique ID', message: '$e');
    }
    return "Unknown Device ID";
  }

  static void printDebugMode({required String type, required String message}) {
    if (kDebugMode) {
      print("[$type] $message");
    }
  }

  static String getEquipmentIconPath(String name) {
    String formatName = name.removeSign().toLowerCase();

    Map<String, String> equipmentIcons = {
      "giuong": AssetSvg.iconBed,
      "dieu hoa": AssetSvg.iconAirConditioner,
      "quat": AssetSvg.iconFan,
      "nong lanh": AssetSvg.iconWaterHeater,
      "den": AssetSvg.iconBulb,
      "bep": AssetSvg.iconHeat,
      "tu": AssetSvg.iconCloset,
    };

    return equipmentIcons.entries
        .firstWhere(
          (entry) => formatName.contains(entry.key),
          orElse: () => const MapEntry('', AssetSvg.iconPerson),
        )
        .value;
  }

  static String formatServiceUnit(int amount, String serviceType) {
    String formattedAmount = FormatUtil.formatCurrency(amount);
    if (serviceType == ConstantString.serviceTypeElectric) {
      formattedAmount = "$formattedAmount/kWh";
    } else if (serviceType == ConstantString.serviceTypeWater) {
      formattedAmount = "$formattedAmount/m³";
    } else if (serviceType == ConstantString.serviceTypePeople) {
      formattedAmount = "$formattedAmount/người";
    } else {
      formattedAmount = "$formattedAmount/phòng";
    }
    return formattedAmount;
  }
}
