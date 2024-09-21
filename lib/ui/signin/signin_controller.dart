import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/models/error_input_model.dart';

class SignInController extends BaseController {
  TextEditingController emailEditingController = TextEditingController();
  Rx<ErrorInputModel> emailErrorInputObject = ErrorInputModel().obs;

  TextEditingController passwordEditingController = TextEditingController();
  Rx<ErrorInputModel> passwordErrorInputObject = ErrorInputModel().obs;
  RxBool hidePassword = true.obs;


}