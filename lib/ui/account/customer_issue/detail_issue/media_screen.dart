import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_house/constants/app_colors.dart';
import 'package:rent_house/constants/constant_font.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:rent_house/utils/app_util.dart';
import 'package:rent_house/widgets/images/error_image_widget.dart';
import 'package:rent_house/widgets/loading/loading_widget.dart';
import 'package:video_player/video_player.dart';

class MediaScreen extends StatefulWidget {
  final String url;
  final bool isMp4;

  const MediaScreen({super.key, required this.url, this.isMp4 = false});

  @override
  State<MediaScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<MediaScreen> {
  late VideoPlayerController _controller;
  bool _isError = false;
  bool _isLoading = true;
  bool _isTimeout = false;
  late Timer _timeoutTimer;

  @override
  void initState() {
    super.initState();
    _isError = false;
    _isLoading = true;
    _isTimeout = false;

    if (widget.isMp4) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
        ..initialize().then((_) {
          setState(() {
            _isLoading = false;
            _isTimeout = false;
          });
          _controller.play();
        }).catchError((error) {
          setState(() {
            _isError = true;
            _isLoading = false;
          });
          AppUtil.printDebugMode(type: "Error initializing video", message: error);
        });

      _timeoutTimer = Timer(const Duration(seconds: 10), () {
        if (_isLoading) {
          setState(() {
            _isTimeout = true;
            _isLoading = false;
          });
          AppUtil.printDebugMode(type: "Error load video", message: "Video loading timed out.");
        }
      });
    }
  }

  @override
  void dispose() {
    if (widget.isMp4) {
      _controller.dispose();
      _timeoutTimer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral1B1A19,
      body: Stack(
        children: [
          if (widget.isMp4) ...[
            Center(
              child: _isError
                  ? Text(
                      ConstantString.tryAgainMessage,
                      style: ConstantFont.mediumText.copyWith(
                        fontSize: 16,
                        color: AppColors.white,
                      ),
                    )
                  : _isTimeout
                      ? Text(
                          "Đã hết thời gian tải video. Vui lòng thử lại.",
                          style: ConstantFont.mediumText.copyWith(
                            fontSize: 16,
                            color: AppColors.white,
                          ),
                        )
                      : _isLoading
                          ? const LoadingWidget()
                          : _controller.value.isInitialized
                              ? AspectRatio(
                                  aspectRatio: _controller.value.aspectRatio,
                                  child: VideoPlayer(_controller),
                                )
                              : const LoadingWidget(),
            ),
          ] else ...[
            Center(
              child: Image.network(
                widget.url,
                fit: BoxFit.cover,
                width: Get.width,
                height: 300,
                errorBuilder: (context, error, stackTrace) => const ErrorImageWidget(),
              ),
            ),
          ],
          Positioned(
            top: 40,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
