import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:toastification/toastification.dart';

enum ToastStatus{warning, success, error}

class ToastUntil {
  static toastNotification(String title, String description, ToastStatus status) {
    //status error
    Color statusColor = AppColors.red;
    String iconPath = 'assets/icons/ic_close_circle.svg';
    if(status == ToastStatus.success){
      statusColor = AppColors.green;
      iconPath = 'assets/icons/ic_checkmark_circle.svg';
    }
    if(status == ToastStatus.warning){
      statusColor = AppColors.yellow;
      iconPath = 'assets/icons/ic_alert_circle.svg';
    }

    toastification.show(
        title: Text(title),
        description: Text(description),
        style: ToastificationStyle.fillColored,
        primaryColor: const Color(0xFF242C32),
        alignment: Alignment.bottomCenter,
        closeButtonShowType: CloseButtonShowType.none,
        showProgressBar: false,
        autoCloseDuration: const Duration(seconds: 5),
        icon: Container(
          padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: statusColor.withOpacity(0.4),
                  spreadRadius: 10,
                  blurRadius: 20,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: SvgPicture.asset(iconPath, width: 24, color: statusColor)),
        boxShadow: [
          const BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.14),
            offset: Offset(0, 16),
            blurRadius: 24),
          const BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.12),
            offset: Offset(0, 6),
            blurRadius: 30),
          const BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.20),
            offset: Offset(0, 8),
            blurRadius: 10),
        ]
    );
  }
}