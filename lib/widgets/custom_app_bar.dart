import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/constant_font.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String label;
  final bool noti;
  final double? elevationDouble;
  final Function? onTap;

  const CustomAppBar({super.key, required this.label, this.noti = false, this.elevationDouble, this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.white,
      title: Text(label, style: ConstantFont.boldText.copyWith(fontSize: 20)),
        elevation: elevationDouble ?? 10,
        centerTitle: true,
        actions: [
          if (noti) ...[
            MaterialButton(
              onPressed: onTap?.call(),
              child: SvgPicture.asset('assets/icon/ic_noti.svg'),
            )
          ]
        ],
        leading: InkWell(
          onTap: Get.back,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const SizedBox(height: 24, width: 24),
              SvgPicture.asset('assets/icons/ic_chevron_back.svg'),
            ],
          ),
        )
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kTextTabBarHeight);
}
