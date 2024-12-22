import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:panorama_viewer/panorama_viewer.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';

class View360 extends StatelessWidget {
  const View360({super.key});

  void onTapBack() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]).then((value) => Get.back());
  }

  @override
  Widget build(BuildContext context) {
    final random = Random();
    String image = random.nextInt(2) == 0 ? "assets/images/360_1.jpg" : "assets/images/360_2.jpg";
    return FutureBuilder(
      future: SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            body: PopScope(
              canPop: false,
              onPopInvoked: (didPop) async {
                if (didPop) return;
                onTapBack();
              },
              child: Stack(
                children: [
                  PanoramaViewer(
                    child: Image.asset(image),
                  ),
                  Positioned(
                    top: 20,
                    right: 16,
                    child: GestureDetector(
                      onTap: onTapBack,
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: SvgPicture.asset(
                          AssetSvg.iconClose,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
