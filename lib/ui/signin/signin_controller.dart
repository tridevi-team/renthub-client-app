import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/access_token_singleton.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:rent_house/models/error_input_model.dart';
import 'package:rent_house/models/response_model.dart';
import 'package:rent_house/models/user_model.dart';
import 'package:rent_house/services/auth_service.dart';
import 'package:rent_house/ui/home/bottom_nav_bar/bottom_navigation_bar.dart';
import 'package:rent_house/untils/shared_pref_helper.dart';
import 'package:rent_house/untils/toast_until.dart';

class SignInController extends BaseController {
  TextEditingController emailEditingController = TextEditingController();
  Rx<ErrorInputModel> emailErrorInputObject = ErrorInputModel().obs;

  TextEditingController passwordEditingController = TextEditingController();
  Rx<ErrorInputModel> passwordErrorInputObject = ErrorInputModel().obs;
  RxBool hidePassword = true.obs;

  @override
  void onInit() {
    emailEditingController.text = "example@gmail.com";
    passwordEditingController.text = "123456Aa";
    super.onInit();
    validateGoogleToken();
  }

  Future<GoogleSignInAuthentication?> _authenticateWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      return googleAuth;
    } catch (e) {
      print('Error during Google sign-in: $e');
      return null;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final googleAuth = await _authenticateWithGoogle();
      if (googleAuth == null) {
        return;
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      AccessTokenSingleton.instance.setToken(googleAuth.idToken!);
      moveToNextPage();
    } on FirebaseAuthException catch (e) {
      print('Error during Firebase sign-in: $e');
    } catch (e) {
      print('Error during sign-in: $e');
    }
  }

  Future<void> validateGoogleToken() async {
    final googleAuth = await _authenticateWithGoogle();
    if (googleAuth == null || googleAuth.idToken == null) {
      return;
    }

    String token = googleAuth.idToken!;
    if (JwtDecoder.isExpired(token)) {
      saveToken(token);
      moveToNextPage();
      return;
    }
    ToastUntil.toastNotification('Có lỗi xảy ra', "Phiên đăng nhập của bạn đã hết hạn. Vui lòng đăng nhập lại để tiếp tục.", ToastStatus.warning);
    return;
  }

  Future<void> loginWithPassword() async {
    final email = emailEditingController.text.trim();
    final password = passwordEditingController.text.trim();

    final response = await AuthService.loginWithPassword({"username": email, "password": password});
    final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
    ResponseModel<UserModel> model =
        ResponseModel.fromJson(decodedResponse, (data) => UserModel.fromJson(data));

    if (model.success ?? false) {
      String accessToken = model.data?.token ?? "";
      saveToken(accessToken);
      moveToNextPage();
    } else {
      ToastUntil.toastNotification('Có lỗi xảy ra', model.message ?? '', ToastStatus.error);
    }
  }

  void saveToken(String accessToken) {
    AccessTokenSingleton.instance.setToken(accessToken);
    SharedPrefHelper.instance.saveString(ConstantString.prefToken, accessToken);
  }

   void moveToNextPage() {
     Get.off(() => BottomNavigationBarView());
   }
}
