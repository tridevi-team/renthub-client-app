import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/constant_font.dart';

class SmartRefreshWidget extends StatelessWidget {
  final RefreshController controller;
  final bool showLoadCompleted;
  final Widget? child;
  final bool enablePullUp;
  final bool enablePullDown;
  final ScrollController scrollController;
  final Axis? scrollDirection;
  final VoidCallback? onLoadingMore;
  final VoidCallback? onRefresh;

  const SmartRefreshWidget({
    super.key,
    required this.controller,
    this.child,
    this.showLoadCompleted = true,
    this.enablePullUp = true,
    this.enablePullDown = true,
    required this.scrollController,
    this.scrollDirection,
    this.onLoadingMore,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: controller,
      physics: const ClampingScrollPhysics(),
      header: CustomHeader(
        builder: (context, mode) {
          Widget headerWidget;

          switch (mode) {
            case RefreshStatus.canRefresh:
              headerWidget = buildRefreshingIndicator();
              break;
            case RefreshStatus.refreshing:
              headerWidget = buildRefreshingIndicator();
              break;
            case RefreshStatus.completed:
              headerWidget = loadCompleted();
              break;
            default:
              headerWidget = const SizedBox.shrink();
              break;
          }

          return Padding(
            padding: const EdgeInsets.all(10),
            child: headerWidget,
          );
        },
      ),
      footer: CustomFooter(
        builder: (context, mode) {
          Widget footerWidget;

          switch (mode) {
            case LoadStatus.idle:
            case LoadStatus.noMore:
              footerWidget = const SizedBox.shrink();
              break;
            case LoadStatus.loading:
              footerWidget = buildRefreshingIndicator();
              break;
            case LoadStatus.canLoading:
              footerWidget = buildReleaseToLoadMore();
              break;
            default:
              footerWidget = const SizedBox.shrink();
              break;
          }

          if (showLoadCompleted) {
            footerWidget = loadCompleted();
          }

          return Padding(
            padding: const EdgeInsets.all(10),
            child: footerWidget,
          );
        },
      ),
      enablePullUp: enablePullUp,
      enablePullDown: enablePullDown,
      onLoading: onLoadingMore,
      onRefresh: onRefresh,
      scrollController: scrollController,
      child: child ?? const SizedBox.shrink(),
    );
  }

  Widget buildReleaseToRefresh() {
    return const Center(
      child: Icon(Icons.refresh),
    );
  }

  Widget buildReleaseToLoadMore() {
    return const Center(
      child: Icon(Icons.refresh),
    );
  }

  Widget buildRefreshingIndicator() {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  }

  Widget loadCompleted() {
    return Center(
      child: Text(
        'Đang tải',
        style: ConstantFont.mediumText.copyWith(
          color: AppColors.primary1,
          fontSize: 12,
        ),
      ),
    );
  }
}
