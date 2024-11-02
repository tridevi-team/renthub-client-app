import 'package:get/get.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/models/room_model.dart';
import 'package:url_launcher/url_launcher.dart';

class RoomDetailController extends BaseController {
  late Room selectedRoom;
  String? address = '';
  RxBool isExpanded = false.obs;

  RoomDetailController({required this.selectedRoom, required this.address});

  void toggleExpanded() {
    isExpanded.value =!isExpanded.value;
  }

  void makePhoneCall() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: '0123456789',
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }
}