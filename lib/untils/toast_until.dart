import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:toastification/toastification.dart';

enum ToastStatus{warning, success, error}

class ToastUntil {
  static void toastNotification({String? title, required String description, required ToastStatus status}) {
    final Map<ToastStatus, Map<String, dynamic>> statusDetails = {
      ToastStatus.error: {
        'iconPath': 'assets/icons/ic_close.svg',
        'color': AppColors.red,
        'defaultTitle': ConstantString.messageSuccess,
      },
      ToastStatus.success: {
        'iconPath': 'assets/icons/ic_checkmark_circle.svg',
        'color': AppColors.green,
        'defaultTitle': ConstantString.messageSuccess,
      },
      ToastStatus.warning: {
        'iconPath': 'assets/icons/ic_alert_circle.svg',
        'color': AppColors.yellow,
        'defaultTitle': ConstantString.messageWarning,
      },
    };

    final details = statusDetails[status]!;
    String iconPath = details['iconPath'];
    Color statusColor = details['color'];

    title = (title?.isEmpty ?? true) ? details['defaultTitle'] : title;

    toastification.dismissAll();

    toastification.show(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      title: Text(title!),
      description: Text(description),
      style: ToastificationStyle.fillColored,
      primaryColor: const Color(0xFF242C32),
      alignment: Alignment.bottomCenter,
      closeButtonShowType: CloseButtonShowType.none,
      showProgressBar: true,
      autoCloseDuration: const Duration(seconds: 5),
      dismissDirection: DismissDirection.vertical,
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
        child: SvgPicture.asset(iconPath, width: 24, color: statusColor),
      ),
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.14),
          offset: Offset(0, 16),
          blurRadius: 24,
        ),
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.12),
          offset: Offset(0, 6),
          blurRadius: 30,
        ),
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.20),
          offset: Offset(0, 8),
          blurRadius: 10,
        ),
      ],
    );
  }
}
