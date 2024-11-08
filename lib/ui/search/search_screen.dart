import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/ui/home/home_list/home_list.dart';
import 'package:rent_house/ui/search/search_controller.dart';
import 'package:rent_house/ui/search/search_widget/not_found_widget.dart';
import 'package:rent_house/widgets/refresh/smart_refresh.dart';
import 'package:rent_house/widgets/textfield/text_input_widget.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final searchController = Get.put(SearchXController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            surfaceTintColor: Colors.white,
            automaticallyImplyLeading: false,
            elevation: 3,
            shadowColor: AppColors.neutralCCCAC6,
            title: Row(
              children: [
                GestureDetector(
                    onTap: Get.back, child: SvgPicture.asset(AssetSvg.iconChevronBack, height: 30)),
                const SizedBox(width: 10),
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextInputWidget(
                          controller: searchController.searchEdtCtrl,
                          isSearch: true,
                          height: 40,
                          colorBorder: Colors.transparent,
                          backgroundColor: AppColors.neutralF5F5F5,
                          onChanged: (value) {
                            searchController.onSearchChanged();
                          },
                        ))),
              ],
            ),
            bottom: searchController.showFilters.value ? PreferredSize(
              preferredSize: const Size.fromHeight(56.0),
              child: AnimatedOpacity(
                opacity: searchController.showFilters.value ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: AppBar(
                    automaticallyImplyLeading: false,
                    forceMaterialTransparency: true,
                    title: Row(
                      children: [
                        _buildFilterOption(
                          title: "Lọc theo",
                          index: 0,
                          icon: AssetSvg.iconChevronDown,
                          controller: searchController,
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
                          controller: searchController,
                        ),
                        Container(
                          width: 1,
                          height: 28,
                          color: AppColors.neutral9E9E9E,
                        ),
                        _buildFilterOption(
                          index: 2,
                          icon: AssetSvg.iconFilter,
                          controller: searchController,
                        ),
                      ],
                    )),
              ),
            ): null),
        body: Obx(
          () => searchController.viewState.value == ViewState.loading && searchController.houseList.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary1),
                  ),
                )
              : searchController.houseList.isNotEmpty ? SmartRefreshWidget(
            controller: searchController.refreshController,
            scrollController: searchController.scrollCtrl,
            onRefresh: searchController.onRefreshData,
            onLoadingMore: searchController.onLoadMoreHouse,
            child: CustomScrollView(
              slivers: [HomeList(houseList: searchController.houseList)],
            ),
          ) : const NotFoundWidget(),
        ),
      ),
    );
  }

  Widget _buildFilterOption({
    String? title,
    String? icon2,
    required int index,
    required String icon,
    required SearchXController controller,
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
            if (title != null) ...[
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
              color:
                  controller.filterSelected.value == index ? AppColors.primary1 : AppColors.black,
            )
          ],
        ),
      ),
    );
  }
}
