import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:rent_house/constants/singleton/token_singleton.dart';
import 'package:rent_house/models/error_input_model.dart';
import 'package:rent_house/models/response_model.dart';
import 'package:rent_house/models/user_model.dart';
import 'package:rent_house/services/auth_service.dart';
import 'package:rent_house/ui/home/bottom_nav_bar/bottom_navigation_bar.dart';
import 'package:rent_house/untils/response_error_util.dart';
import 'package:rent_house/untils/shared_pref_helper.dart';
import 'package:rent_house/untils/toast_until.dart';
import 'package:rent_house/untils/validate_util.dart';

class SignInController extends BaseController {
  TextEditingController contactInputController = TextEditingController();
  Rx<ErrorInputModel> contactErrorInputObject = ErrorInputModel().obs;

  TextEditingController otpEditingController = TextEditingController();
  Rx<ErrorInputModel> otpErrorInputObject = ErrorInputModel().obs;

  RxBool isSendOTP = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId = '';
  String accessToken = '';
  String refreshToken = '';

  @override
  void onInit() {
    if (kDebugMode) {
      otpEditingController.text = "000000";
      contactInputController.text = "0123456789";
    }
    super.onInit();
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
      await _auth.signInWithCredential(credential);
      String? token = await _auth.currentUser?.getIdToken();
      String? refreshToken = _auth.currentUser?.refreshToken;
      if (token != null && refreshToken != null) {
        saveToken();
        moveToNextPage();
      }
    } on FirebaseAuthException catch (e) {
      ToastUntil.toastNotification('Có lỗi xảy ra', e.toString(), ToastStatus.warning);
    } catch (e) {
      if (kDebugMode) {
        print('Error during sign-in: $e');
      }
      ToastUntil.toastNotification('Có lỗi xảy ra', e.toString(), ToastStatus.warning);
    }
  }

  Future<void> generateOTPByEmail() async {
    isSendOTP.value = true;
    final email = contactInputController.text.trim();
    final response = await AuthService.generateOTPByEmail({"email": email});

    final errorMessage = ResponseErrorUtil.handleErrorResponse(response.statusCode, response.body);

    if (errorMessage != null) {
      ToastUntil.toastNotification('Có lỗi xảy ra', errorMessage, ToastStatus.error);
      return;
    }

    final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
    ResponseModel model = ResponseModel.fromJson(decodedResponse);
    if (model.success == true) {

    } else {
      ToastUntil.toastNotification('Có lỗi xảy ra', model.message ?? 'Unknown error', ToastStatus.error);
    }
  }

  Future<void> onLogin() async {
    if (contactErrorInputObject.value.isError == true || otpErrorInputObject.value.isError == true) {
      return;
    }

    if (contactInputController.text.isPhoneNumber) {
      signInWithPhone();
    } else {
      signInWithEmail();
    }
  }

  Future<void> signInWithEmail() async {

    final email = contactInputController.text.trim();
    final response = await AuthService.generateOTPByEmail({"email": email});

    final errorMessage = ResponseErrorUtil.handleErrorResponse(response.statusCode, response.body);

    if (errorMessage != null) {
      ToastUntil.toastNotification('Có lỗi xảy ra', errorMessage, ToastStatus.error);
      return;
    }

    final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
    ResponseModel<UserModel> model = ResponseModel.fromJson(decodedResponse, parseData: (data) => UserModel.fromJson(data));
    if (model.success == true) {
      accessToken = model.data?.token ?? "";
      refreshToken = model.data?.refreshToken ?? "";
      saveToken();
      moveToNextPage();
    } else {
      ToastUntil.toastNotification('Có lỗi xảy ra', model.message ?? 'Unknown error', ToastStatus.error);
    }
  }

  void onChangeContactInput(String value) {
    if (value.isEmpty) {
      contactErrorInputObject.value.isError = true;
      contactErrorInputObject.value.message = "Đây là trường bắt buộc";
    } else {
      if (ValidateUtil.isValidEmail(value)) {
        contactErrorInputObject.value.isError = false;
        contactErrorInputObject.value.message = "";
      } else if (ValidateUtil.isValidPhone(value)) {
        contactErrorInputObject.value.isError = false;
        contactErrorInputObject.value.message = "";
      } else {
        contactErrorInputObject.value.isError = true;
        contactErrorInputObject.value.message = "Dữ liệu nhập vào của bạn không đúng định dạng, vui lòng kiểm tra lại";
      }
    }
  }

  void onChangeOTP(String value) {
    if (value.isEmpty) {
      otpErrorInputObject.value.isError = true;
      otpErrorInputObject.value.message = "Đây là trường bắt buộc";
    } else {
      bool isValidOTP = false;
      if (ValidateUtil.isValidOTP(value)) {
        isValidOTP = true;
      }
      if (isValidOTP) {
        otpErrorInputObject.value.isError = false;
      } else {
        otpErrorInputObject.value.isError = true;
        otpErrorInputObject.value.message = "Dữ liệu nhập vào của bạn không đúng định dạng, vui lòng kiểm tra lại";
      }
    }
  }

  void verifyPhoneNumber() async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: contactInputController.text.trim().replaceFirst('0', '+84'),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          Get.snackbar("Success", "Logged in successfully!");
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Verification failed: $e");
        },
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId = verificationId;
          print("VerifiedId: $verificationId");

        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId = verificationId;
        },
        timeout: const Duration(seconds: 120),
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to verify phone number.");
    }
  }

  void signInWithPhone() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otpEditingController.text);
      await _auth.signInWithCredential(credential);
      saveToken();
      ToastUntil.toastNotification("", "Đăng nhập thành công", ToastStatus.success);
    } catch (e) {

      ToastUntil.toastNotification('Có lỗi xảy ra', "Mã xác thực không hợp lệ", ToastStatus.error);
    }
  }

  void saveToken() {
    TokenSingleton.instance.setAccessToken(accessToken);
    TokenSingleton.instance.setRefreshToken(refreshToken);
    SharedPrefHelper.instance.saveString(ConstantString.prefToken, accessToken);
    SharedPrefHelper.instance.saveString(ConstantString.prefRefreshToken, accessToken);
  }

   void moveToNextPage() {
     Get.off(() => BottomNavigationBarView());
   }
}
