import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:rent_house/base/base_controller.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:rent_house/constants/singleton/user_singleton.dart';
import 'package:rent_house/models/room_model.dart';
import 'package:rent_house/models/user_model.dart';
import 'package:rent_house/services/issue_service.dart';
import 'package:rent_house/untils/app_util.dart';
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
  EquipmentModel? equipment;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void showToast(String message, ToastStatus status) {
    ToastUntil.toastNotification(description: message, status: status);
  }

  Future<void> pickImage() async {
    if (selectedImages.length >= 3) {
      showToast("Chỉ có thể tải lên tối đa 3 hình ảnh.", ToastStatus.warning);
      return;
    }
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImages.add(File(pickedFile.path));
    }
  }

  Future<void> pickVideo() async {
    if (selectedVideos.length >= 3) {
      showToast("Chỉ có thể tải lên tối đa 3 video.", ToastStatus.warning);
      return;
    }
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      final videoFile = File(pickedFile.path);
      double videoSizeInMB = await _getFileSizeInMB(videoFile);

      if (videoSizeInMB > maxVideoSizeInMB) {
        showToast("Kích thước video vượt quá giới hạn $maxVideoSizeInMB MB.", ToastStatus.warning);
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

  Future<void> createIssue() async {
    Get.focusScope!.unfocus();

    if (titleCtrl.text.isEmpty || contentCtrl.text.isEmpty) {
      showToast("Vui lòng điền đầy đủ thông tin.", ToastStatus.warning);
      return;
    }

    UserModel user = UserSingleton.instance.getUser();
    String houseId = user.houseId ?? "";
    String floorId = user.floorId ?? "";
    String roomId = user.roomId ?? "";
    var uploadedImageUrls = [];
    var uploadedVideoUrls = [];
    try {
      final files = [
        ...selectedImages.map((image) => File(image.path)),
        ...selectedVideos.map((video) => File(video.path)),
      ];

      if (files.isNotEmpty) {
        uploadProgress.value = 0.0;
        final uploadResponse = await IssueService.uploadFiles(files, (progress) {
          if (progress >= 0.991) return;
          uploadProgress.value = progress * 100;

        });
        if (uploadResponse.statusCode != 200) {
          showToast("Không thể tải lên tệp. Vui lòng thử lại.", ToastStatus.error);
          return;
        }

        final decodedResponse = jsonDecode(uploadResponse.body) as Map<String, dynamic>;
        final filesData = decodedResponse['data']['files'] as List?;

        if (filesData == null) {
          showToast("Phản hồi không hợp lệ từ máy chủ. Vui lòng thử lại.", ToastStatus.error);
          return;
        }

        uploadedImageUrls = filesData.where((file) => file['file'].toString().contains(RegExp(r'\.(jpg|png)$')))
            .map((file) => file['url'] as String).toList();
        uploadedVideoUrls = filesData.where((file) => file['file'].toString().contains('.mp4'))
            .map((file) => file['url'] as String).toList();
      }


      final data = {
        "floorId": floorId,
        "roomId": roomId,
        if (equipment != null) "equipmentId": equipment?.id,
        "title": titleCtrl.text,
        "content": contentCtrl.text,
        "files": {
          "image": uploadedImageUrls,
          "video": uploadedVideoUrls,
        },
      };

      final response = await IssueService.createIssues(houseId: houseId, body: data);
      if (response.statusCode == 200) {
        showToast("Tạo báo cáo thành công!", ToastStatus.success);
        uploadProgress.value = 100;
      } else {
        showToast("Tạo báo cáo thất bại. Vui lòng thử lại.", ToastStatus.error);
      }
    } catch (e) {
      AppUtil.printDebugMode(type: "create issue", message: "$e");
      showToast(ConstantString.tryAgainMessage, ToastStatus.error);
    }
  }
}
