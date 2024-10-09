import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/asset_svg.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/models/explore_model.dart';
import 'package:rent_house/models/house_data_model.dart';
import 'package:rent_house/models/response_model.dart';
import 'package:rent_house/services/home_service.dart';
import 'package:rent_house/ui/home/home_explore/home_explore.dart';
import 'package:rent_house/widgets/ratio/radio_option.dart';

class HomeController extends BaseController {
  //controller
  RefreshController refreshController = RefreshController();
  ScrollController scrollController = ScrollController();

  //widgets
  RxList<Widget> widgets = <Widget>[].obs;

  //data
  List<Explore> exploreList = [
    Explore(id: 1, name: "Explore 1", image: "image1", description: "Description 1", quantity: 50),
    Explore(id: 2, name: "Explore 2", image: "image2", description: "Description 2", quantity: 60),
    Explore(id: 3, name: "Explore 3", image: "image3", description: "Description 3", quantity: 70),
  ];

  List<House> houseList = [];
  int currentPage = 1;

  //filter
  RxBool showFilters = true.obs;
  RxInt filterSelected = 0.obs;
  double previousOffset = 0.0;
  double threshold = 20.0;
  List<String> sorts = ["name", "numOfBeds", "numOfRenters", "roomArea", "price"];
  int sortBySelected = 0;

  RxString orderBy = "asc".obs;
  String searchKeyword = "";
  int? numOfBeds;
  int? numOfRenters;
  int? roomArea;
  int? priceFrom;
  int? priceTo;

  @override
  void onInit() {
    super.onInit();
    initScrollController();
    _buildExploreWidget();
    fetchHouseList();
  }

  void _buildExploreWidget() {
    widgets.add(HomeExplore());
  }

  void initScrollController() {
    scrollController.addListener(() {
      double currentOffset = scrollController.position.pixels;
      double scrollDelta = (currentOffset - previousOffset).abs();

      if (scrollDelta > threshold) {
        if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
          if (showFilters.value) {
            showFilters.value = false;
          }
        } else if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
          if (!showFilters.value) {
            showFilters.value = true;
          }
        }
        previousOffset = currentOffset;
      }
    });
  }

  Future<void> fetchHouseList(
      {bool isLoadMore = false,
      int? numOfBeds,
      String? street,
      String? ward,
      String? district,
      String? city,
      int? numOfRenters,
      int? roomArea,
      int? priceFrom,
      int? priceTo,
      int limit = 10,
      int page = 1}) async {
    try {
      viewState.value = ViewState.init;
      if (isLoadMore) {
        currentPage++;
      } else {
        viewState.value = ViewState.loading;
        currentPage = 1;
      }
      Map<String, dynamic> queryParams = {
        'limit': limit.toString(),
        'page': currentPage.toString(),
        'sortBy': sorts[sortBySelected],
        'orderBy': orderBy.value,
        'keyword': searchKeyword,
        if (numOfBeds != null) 'numOfBeds': numOfBeds,
        if (numOfRenters != null) 'numOfRenters': numOfRenters,
        if (roomArea != null) 'roomArea': roomArea,
        if (priceFrom != null) 'priceFrom': priceFrom,
        if (priceTo != null) 'priceTo': priceTo,
      };
      final response = await HomeService.fetchHouseList(queryParams);
      if (response.statusCode != 200) {
        viewState.value = ViewState.error;
        log("Failed to fetch house list, status code: ${response.statusCode}");
        return;
      }
      final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
      HouseDataModel houseDataModel = HouseDataModel.fromJson(decodedResponse['data']);
      viewState.value = ViewState.complete;
      if (houseDataModel.results != null && houseDataModel.results!.isNotEmpty) {
        if (!isLoadMore) {
          houseList.clear();
        }
        houseList.addAll(houseDataModel.results!);
        refreshController.loadComplete();
      } else {
        refreshController.loadNoData();
      }
    } catch (e) {
      viewState.value = ViewState.error;
      refreshController.loadNoData();
      log("Error fetch: $e");
    }
  }

  void onLoadMoreHouse() async {
    await fetchHouseList(isLoadMore: true);
  }

  void onRefreshData() async {
    await fetchHouseList();
    refreshController.requestRefresh();
  }

  void onFilterSelected(int index) {
    filterSelected.value = index;
    if (index == 0) {
      showBottomSheetTypeSort();
    }
    if (index == 1) {
      orderBy.value = (orderBy.value == "asc") ? "desc" : "asc";
      fetchHouseList();
    }
    if (index == 2) {
      showBottomSheetTypeSort();
    }
  }

  void onSortBySelected(int index) {
    sortBySelected = index;
    Get.back();
    fetchHouseList();
  }

  Future<void> showBottomSheetTypeSort() async {
    await Get.bottomSheet(
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      Container(
        height: Get.height / 3,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                'Sắp xếp theo',
                style: ConstantFont.regularText.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(onTap: Get.back, child: SvgPicture.asset(AssetSvg.iconClose))
            ]),
            const SizedBox(height: 10),
            const Divider(height: 1, color: AppColors.neutralF5F5F5),
            const SizedBox(height: 20),
            RadioOption(
                label: "Tên",
                isSelected: 0 == sortBySelected,
                onSelected: () => onSortBySelected(0)),
            const SizedBox(height: 10),
            RadioOption(
                label: "Số phòng ngủ",
                isSelected: 1 == sortBySelected,
                onSelected: () => onSortBySelected(1)),
            const SizedBox(height: 10),
            RadioOption(
                label: "Số người 1 phòng",
                isSelected: 2 == sortBySelected,
                onSelected: () => onSortBySelected(2)),
            const SizedBox(height: 10),
            RadioOption(
                label: "Diện tích",
                isSelected: 3 == sortBySelected,
                onSelected: () => onSortBySelected(3)),
            const SizedBox(height: 10),
            RadioOption(
                label: "Giá",
                isSelected: 4 == sortBySelected,
                onSelected: () => onSortBySelected(4)),
          ],
        ),
      ),
    );
  }
}
