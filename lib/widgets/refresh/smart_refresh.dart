import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SmartRefreshWidget extends StatelessWidget {
  final RefreshController controller;
  final bool showLoadCompleted;
  final Widget? widget;
  final bool enablePullUp;
  final bool enablePullDown;
  final ScrollController scrollController;
  final Axis? scrollDirection;
  final Function()? onLoading;
  final Function()? onRefresh;

  const SmartRefreshWidget({super.key,
    required this.controller,
    this.widget,
    this.showLoadCompleted = true,
    this.enablePullUp = true,
    this.enablePullDown = true,
    required this.scrollController,
    this.scrollDirection,
    this.onLoading,
    this.onRefresh});

  @override
  Widget build(BuildContext context) {
    Widget body = Container();
    return SmartRefresher(
      controller: controller,
      header: CustomHeader(
        builder: (context, mode) {
          if (mode == RefreshStatus.canRefresh) {
            body = buildReleaseToReLoad();
          }
          if (mode == RefreshStatus.refreshing) {
            body = buildRefreshing();
          }
          if (mode == RefreshStatus.completed) {
            body = loadCompleted();
          }
          return Padding(padding: const EdgeInsets.all(10), child: body);
        },
      ),
      footer: CustomFooter(
        builder: (context, mode) {
          Widget body = Container();
          if (mode == LoadStatus.idle || mode == LoadStatus.noMore) {
            body = const SizedBox.shrink();
          }
          if (mode == LoadStatus.loading) {
            body = buildRefreshing();
          }
          if (mode == LoadStatus.canLoading) {
            body = buildReleaseToLoadMore();
          }
          if (showLoadCompleted == true) {
            body = loadCompleted();
          }
          return Padding(
            padding: const EdgeInsets.all(10),
            child: body,
          );
        },
      ),
      enablePullUp: enablePullUp,
      enablePullDown: enablePullDown,
      onLoading: onLoading,
      onRefresh: onRefresh,
      child: widget,
    );
  }

  Widget buildReleaseToReLoad() {
    return const Center(
      child: Icon(Icons.refresh),
    );
  }

  Widget buildReleaseToLoadMore() {
    return const Center(
      child: Icon(Icons.refresh),
    );
  }

  Widget buildRefreshing() {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  }

  Widget loadCompleted() {
    return const Center(
      child: Icon(Icons.check),
    );
  }
}
