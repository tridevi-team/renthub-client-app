import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/ui/home/home_app_bar.dart';
import 'package:rent_house/ui/home/home_list/home_list.dart';
import 'package:rent_house/ui/home/home_screen/home_controller.dart';
import 'package:rent_house/widgets/refresh/smart_refresh.dart';

import '../../../base/base_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      backgroundColor: AppColors.white,
      body: Obx(() => homeController.viewState.value == ViewState.loading
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
                    scrollController: homeController.scrollCtrl,
                    onRefresh: homeController.onRefreshData,
                    onLoadingMore: homeController.onLoadMoreHouse,
                    child: homeController.widgets.isEmpty
                        ? const Center(child: SizedBox.shrink())
                        : CustomScrollView(
                            physics: const ClampingScrollPhysics(),
                            slivers: [

                              SliverList(
                                  delegate: SliverChildListDelegate(
                                [...homeController.widgets],
                                addAutomaticKeepAlives: false,
                                addRepaintBoundaries: false,
                                addSemanticIndexes: false,
                              )),
                              SliverPadding(
                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                  sliver: SliverToBoxAdapter(
                                      child: Text('Danh sách nhà',
                                          style: ConstantFont.boldText.copyWith(fontSize: 16)))),
                              HomeList(houseList: homeController.houseList)
                            ],
                          ),
                  ),
                ),
              ],
            )),
    );
  }
}
