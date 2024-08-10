import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ViewState { init, loading, complete, error, none, end }

abstract class BaseController extends GetxController {
  ScrollController scrollController = ScrollController();
  RxBool isLoadingMore = false.obs;
  Rx<ViewState> viewState = ViewState.init.obs;
  RxString errorMessage = "".obs;

  void onHideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}