import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/ui/home/home_app_bar.dart';
import 'package:rent_house/ui/home/home_list/home_list.dart';
import 'package:rent_house/ui/home/home_screen/home_controller.dart';
import 'package:rent_house/untils/bottom_sheet_until.dart';
import 'package:rent_house/widgets/refresh/smart_refresh.dart';

import '../../../base/base_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final homeController = Get.find<HomeController>();

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
                    scrollController: homeController.scrollController,
                    onRefresh: homeController.onRefreshData,
                    onLoadingMore: homeController.onLoadMoreHouse,
                    child: homeController.widgets.isEmpty
                        ? const Center(child: SizedBox.shrink())
                        : CustomScrollView(
                            physics: const ClampingScrollPhysics(),
                            slivers: [
                              if (homeController.showFilters.value)
                                SliverAppBar(
                                  title: Row(
                                    children: [
                                      _buildFilterOption(
                                        title: "Lọc theo",
                                        index: 0,
                                        icon: AssetSvg.iconChevronDown,
                                        controller: homeController,
                                      ),
                                      Container(
                                        width: 1,
                                        height: 28,
                                        color: AppColors.neutral9E9E9E,
                                      ),
                                      _buildFilterOption(
                                        title: "Xếp theo",
                                        index: 1,
                                        icon: AssetSvg.iconTrendingDown,
                                        icon2: AssetSvg.iconTrendingUp,
                                        controller: homeController,
                                      ),
                                      Container(
                                        width: 1,
                                        height: 28,
                                        color: AppColors.neutral9E9E9E,
                                      ),
                                      _buildFilterOption(
                                        index: 2,
                                        icon: AssetSvg.iconFilter,
                                        controller: homeController,
                                      ),
                                    ],
                                  ),
                                  pinned: true,
                                  floating: true,
                                  snap: true,
                                  toolbarHeight: 40,
                                  elevation: 10,
                                  shadowColor: AppColors.neutral9E9E9E,
                                  surfaceTintColor: AppColors.white,
                                )
                              else
                                const SliverToBoxAdapter(),
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

  Widget _buildFilterOption({
    String? title,
    String? icon2,
    required int index,
    required String icon,
    required HomeController controller,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () {
          controller.onFilterSelected(index);
        },
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (title != null)...[
              Text(
                title,
                style: ConstantFont.regularText.copyWith(
                  color: controller.filterSelected.value == index
                      ? AppColors.primary1
                      : AppColors.black,
                ),
              ),
            ],
            const SizedBox(width: 4),
            SvgPicture.asset(
              icon2 != null && controller.orderBy.value == 'asc' ? icon2 : icon,
              width: 18,
              color: controller.filterSelected.value == index
                  ? AppColors.primary1
                  : AppColors.black,
            )
          ],
        ),
      ),
    );
  }
}
