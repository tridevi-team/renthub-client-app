import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/enums/enums.dart';
import 'package:rent_house/models/house_data_model.dart';
import 'package:rent_house/services/home_service.dart';
import 'package:rent_house/untils/dialog_util.dart';
import 'package:rent_house/untils/response_error_util.dart';
import 'package:rent_house/untils/toast_until.dart';

class SearchXController extends BaseController {
  RefreshController refreshController = RefreshController();
  ScrollController scrollCtrl = ScrollController();

  TextEditingController searchEdtCtrl = TextEditingController();
  Timer? _debounce;

  List<House> houseList = [];
  int currentPage = 1;

  List<String> sortOptions = [
    "Tên",
    "Số phòng ngủ",
    "Số người 1 phòng",
    "Diện tích",
    "Giá",
  ];

  //filter
  RxBool showFilters = true.obs;
  RxInt filterSelected = 0.obs;
  double previousOffset = 0.0;
  double threshold = 20.0;
  List<String> sorts = ["houses.name", "numOfBeds", "rooms.max_renters", "rooms.room_area", "rooms.price"];
  int sortBySelected = 0;

  RxString orderBy = "asc".obs;
  int? numOfBeds;
  int? numOfRenters;
  int? roomArea;
  double minPrice = 100000000;
  double maxPrice = 0;
  Rx<RangeValues> currentFilterPrice = const RangeValues(0, 0).obs;

  @override
  void onInit() {
    super.onInit();
    initScrollController();
    fetchHouseList();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchEdtCtrl.removeListener(onSearchChanged);
    searchEdtCtrl.dispose();
    super.dispose();
  }

  void initScrollController() {
    scrollCtrl.addListener(() {
      double currentOffset = scrollCtrl.position.pixels;
      double scrollDelta = (currentOffset - previousOffset).abs();

      if (scrollDelta > threshold * 2) {
        if (scrollCtrl.position.userScrollDirection == ScrollDirection.reverse) {
          if (showFilters.value) {
            _hideFiltersDebounced();
          }
        } else if (scrollCtrl.position.userScrollDirection == ScrollDirection.forward) {
          if (!showFilters.value) {
            _showFiltersDebounced();
          }
        }
        previousOffset = currentOffset;
      }
    });
  }

  void _hideFiltersDebounced() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollCtrl.position.userScrollDirection == ScrollDirection.reverse) {
        showFilters.value = false;
      }
    });
  }

  void _showFiltersDebounced() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollCtrl.position.userScrollDirection == ScrollDirection.forward) {
        showFilters.value = true;
      }
    });
  }

  Future<void> fetchHouseList({bool isLoadMore = false, int? numOfBeds, String? street, String? ward, String? district, String? city, int? numOfRenters, int? roomArea, int? priceFrom, int? priceTo, int limit = 10, int page = 1}) async {
    try {
      viewState.value = ViewState.init;
      if (isLoadMore) {
        currentPage++;
      } else {
        houseList.clear();
        viewState.value = ViewState.loading;
        currentPage = 1;
      }

      String sort = '''{
       "field": "${sorts[sortBySelected]}",
          "direction": "${orderBy.value}"
        }''';

      String filters = 'filter[]={"field": "${sorts[sortBySelected]}", "operator": "cont", "value": "${searchEdtCtrl.text}"}&';

      final response = await HomeService.fetchHouseList(sort, filters, currentPage);
      ResponseErrorUtil.handleErrorResponse(this, response.statusCode);
      if (response.statusCode < 300) {
        final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
        HouseDataModel houseDataModel = HouseDataModel.fromJson(decodedResponse['data']);
        viewState.value = ViewState.complete;
        final houses = houseDataModel.results ?? [];
        if (houseDataModel.results != null && houseDataModel.results!.isNotEmpty) {
          for (var house in houses) {
            if (house.minPrice != null && minPrice > house.minPrice!) {
              minPrice = house.minPrice!.toDouble();
            }
            if (house.maxPrice != null && maxPrice < house.maxPrice!) {
              maxPrice = house.maxPrice!.toDouble();
            }
          }
          currentFilterPrice.value = RangeValues(roundDownToMillion(minPrice), roundUpToMillion(maxPrice));
          houseList.addAll(houses);
          refreshController.loadComplete();
        } else {
          houseList.clear();
        }
      }
    } catch (e) {
      viewState.value = ViewState.notFound;
      houseList.clear();
      log("Error fetch: $e");
    }
  }

  void onLoadMoreHouse() async {
    await fetchHouseList(isLoadMore: true);
  }

  void onRefreshData() async {
    searchEdtCtrl.text = '';
    await fetchHouseList();
    refreshController.requestRefresh();
  }

  void onFilterSelected(int index) {
    onHideKeyboard();
    filterSelected.value = index;
    if (index == 0) {
      DialogUtil.showSortBottomSheet(
        selectedOption: sortBySelected,
        options: sortOptions,
        onSelected: (index) {
          onSortBySelected(index);
          Get.back();
        },
      );
    }
    if (index == 1) {
      orderBy.value = (orderBy.value == "asc") ? "desc" : "asc";
      fetchHouseList();
    }
    if (index == 2) {
      if (houseList.isEmpty) {
        ToastUntil.toastNotification(title: "Thông báo", description: "Bạn cần có ít nhất 5 căn phòng để thực hiện việc lọc danh sách.", status: ToastStatus.warning);
        return;
      }
      DialogUtil.showFilterBottomSheet(
        currentRange: currentFilterPrice,
        onChanged: updateRange,
        onApply: () {},
        minPrice: roundDownToMillion(minPrice),
        maxPrice: roundUpToMillion(maxPrice),
      );
    }
  }

  void onSortBySelected(int index) {
    sortBySelected = index;
    fetchHouseList();
  }

  void onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      fetchHouseList();
    });
  }

  void updateRange(RangeValues values) {
    if (values.end - values.start >= 100000) {
      currentFilterPrice.value = values;
    }
  }

  double roundDownToMillion(double value) {
    return (value ~/ 1000000) * 1000000;
  }

  double roundUpToMillion(double value) {
    return ((value + 999999) ~/ 1000000) * 1000000;
  }
}
