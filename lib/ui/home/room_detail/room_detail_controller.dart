import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:url_launcher/url_launcher.dart';

class RoomDetailController extends BaseController {
  RxBool isExpanded = false.obs;

  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
  }

  void makePhoneCall(String phone) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  Map<String, dynamic> getRoomStatusIconPath(String status) {
    String path = AssetSvg.iconOccupied;
    String description = "Đã cho thuê";
    Color color = AppColors.green;
    if (status == ConstantString.statusMaintain || status == ConstantString.statusPending) {
      path = AssetSvg.iconMaintain;
      description = "Đang bảo trì";
      color = AppColors.yellow;
    } else if (status == ConstantString.statusExpired) {
      path = AssetSvg.iconNotAvailable;
      description = "Không có sẵn";
      color = AppColors.red;
    } else if (status == ConstantString.statusAvailable) {
      path = AssetSvg.iconRent;
      description = "Đang có sẵn";
      color = AppColors.green;
    }
    return {
      'path': path,
      'description': description,
      'color': color,
    };
  }
}
