import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/ui/home/home_app_bar.dart';
import 'package:rent_house/ui/home/home_list/home_list.dart';
import 'package:rent_house/ui/home/home_screen/home_controller.dart';
import 'package:rent_house/widgets/refresh/smart_refresh.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
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
              Expanded(
                child: SmartRefreshWidget(
                  controller: homeController.refreshController,
                  scrollController: homeController.scrollController,
                  widget: homeController.widgets.isEmpty
                      ? const Center(child: SizedBox.shrink())
                      :
                  CustomScrollView(
                    physics: const ClampingScrollPhysics(),
                    slivers: [
                      SliverList(
                          delegate: SliverChildListDelegate(
                            [...homeController.widgets],
                            addAutomaticKeepAlives: false,
                            addRepaintBoundaries: false,
                            addSemanticIndexes: false,
                          )),
                      const HomeList()
                    ],
                  ),
                ),
              ),
            ],
          )

      ),
    );
  }
}
