import 'package:rent_house/constants/web_service.dart';
import 'package:rent_house/main.dart';

Future<void> main() async {
  WebService.baseUrl = 'http://sandbox.tmquang.com';
  await mainApp();
}