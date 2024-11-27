import 'package:flutter/cupertino.dart';
import 'package:rent_house/base/base_controller.dart';

import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:rent_house/untils/toast_until.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

class CustomerIssueController extends BaseController {

  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController contentCtrl = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  var selectedImages = <File>[].obs;
  var selectedVideos = <File>[].obs;
  var videoThumbnails = <File?>[].obs;
  final int maxVideoSizeInMB = 25;
  RxDouble uploadProgress = 0.0.obs;

  Future<void> pickImage() async {
    if (selectedImages.length >= 3) {
      ToastUntil.toastNotification(description: "Chỉ có thể tải lên tối đa 3 hình ảnh.", status: ToastStatus.warning);
      return;
    }
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImages.add(File(pickedFile.path));
    }
  }

  Future<void> pickVideo() async {
    if (selectedVideos.length >= 3) {
      ToastUntil.toastNotification(description: "Chỉ có thể tải lên tối đa 3 video.", status: ToastStatus.warning);
      return;
    }
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      File videoFile = File(pickedFile.path);
      double videoSizeInMB = await _getFileSizeInMB(videoFile);

      if (videoSizeInMB > maxVideoSizeInMB) {
        ToastUntil.toastNotification(description: "Kích thước video vượt quá giới hạn $maxVideoSizeInMB MB.", status: ToastStatus.warning);
        return;
      }

      selectedVideos.add(videoFile);
      String? thumbPath = await _generateVideoThumbnail(videoFile.path);
      videoThumbnails.add(thumbPath != null ? File(thumbPath) : null);
    }
  }

  Future<double> _getFileSizeInMB(File file) async {
    int sizeInBytes = await file.length();
    return sizeInBytes / (1024 * 1024);
  }

  Future<String?> _generateVideoThumbnail(String videoPath) async {
    final tempDir = await getTemporaryDirectory();
    return await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: tempDir.path,
      imageFormat: ImageFormat.PNG,
      maxHeight: 100,
      quality: 100,
    );
  }

  void removeImage(int index) => selectedImages.removeAt(index);

  void removeVideo(int index) {
    selectedVideos.removeAt(index);
    videoThumbnails.removeAt(index);
  }

  Future<void> uploadFiles() async {
    Get.focusScope!.unfocus();
    if (selectedImages.isEmpty) {
      ToastUntil.toastNotification(description: "Vui lòng chọn ít nhất một hình ảnh.", status: ToastStatus.warning);
      return;
    }

    if (selectedVideos.isEmpty) {
      ToastUntil.toastNotification(description: "Vui lòng chọn ít nhất một video.", status: ToastStatus.warning);
      return;
    }

    uploadProgress.value = 0.0;
    double totalSizeInBytes = 0.0;
    double uploadedBytes = 0.0;

    // Calculate the total size of all files (images and videos)
    for (var image in selectedImages) {
      totalSizeInBytes += await image.length();
    }

    for (var video in selectedVideos) {
      totalSizeInBytes += await video.length();
    }

    try {
      // Upload images
      for (var image in selectedImages) {
        uploadedBytes += await _uploadFile(image);
        uploadProgress.value = (uploadedBytes / totalSizeInBytes) * 100;
      }

      // Upload videos
      for (var video in selectedVideos) {
        uploadedBytes += await _uploadFile(video);
        uploadProgress.value = (uploadedBytes / totalSizeInBytes) * 100;
      }

      ToastUntil.toastNotification(description: "Tạo báo cáo thành công!", status: ToastStatus.success);
      Get.back();
    } catch (e) {
      ToastUntil.toastNotification(description: ConstantString.tryAgainMessage, status: ToastStatus.error);
    }
  }


  Future<double> _uploadFile(File file) async {
    final totalBytes = file.lengthSync();
    int uploadedBytes = 0;

    final chunkSize = (totalBytes / 10).round(); // Upload in chunks
    for (int i = 0; i < 10; i++) {
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network delay
      uploadedBytes += chunkSize;
    }

    return uploadedBytes.toDouble();
  }
}
