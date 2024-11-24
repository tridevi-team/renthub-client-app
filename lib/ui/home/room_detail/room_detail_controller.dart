import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:rent_house/models/room_model.dart';
import 'package:rent_house/untils/format_util.dart';
import 'package:url_launcher/url_launcher.dart';

class RoomDetailController extends BaseController {
  RxBool isExpanded = false.obs;

  void toggleExpanded() {
    isExpanded.value =!isExpanded.value;
  }

  void makePhoneCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: '0123456789',
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  String formatServiceUnit(int amount, String serviceType) {
    String formattedAmount = FormatUtil.formatCurrency(amount);
    if (serviceType == ConstantString.serviceTypeElectric) {
      formattedAmount = "$formattedAmount/kWh";
    } else if (serviceType == ConstantString.serviceTypeWater) {
      formattedAmount = "$formattedAmount/khối";
    } else if (serviceType == ConstantString.serviceTypePeople) {
      formattedAmount = "$formattedAmount/người";
    } else {
      formattedAmount = "$formattedAmount/phòng";
    }
    return formattedAmount;
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