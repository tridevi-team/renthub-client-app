import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/ui/home/home_app_bar.dart';
import 'package:rent_house/ui/home/home_screen/home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Obx(() => homeController.isLoadingRefresh.value
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary1),
              ),
            )
          : Column(
              children: [
                homeController.widgets.isNotEmpty ?
                   const HomeAppBar() : const Center(child: SizedBox.shrink()),
                Expanded(
                    child: CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  slivers: [SliverList(delegate: SliverChildListDelegate([], addAutomaticKeepAlives: false, addRepaintBoundaries: false, addSemanticIndexes: false))],
                ))
              ],
            )),
    );
  }
}
