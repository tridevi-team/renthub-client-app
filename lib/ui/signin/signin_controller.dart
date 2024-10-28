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
import 'package:rent_house/services/auth_service.dart';
import 'package:rent_house/ui/home/bottom_nav_bar/bottom_navigation_bar.dart';
import 'package:rent_house/untils/response_error_util.dart';
import 'package:rent_house/untils/shared_pref_helper.dart';
import 'package:rent_house/untils/toast_until.dart';
import 'package:rent_house/untils/validate_util.dart';

class SignInController extends BaseController {
  TextEditingController emailEditingController = TextEditingController();
  Rx<ErrorInputModel> emailErrorInputObject = ErrorInputModel().obs;

  TextEditingController phoneEditingController = TextEditingController();
  Rx<ErrorInputModel> phoneErrorInputObject = ErrorInputModel().obs;

  TextEditingController otpEditingController = TextEditingController();
  Rx<ErrorInputModel> otpErrorInputObject = ErrorInputModel().obs;

  RxBool isSendOTP = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxString verificationId = ''.obs;

  @override
  void onInit() {
    emailEditingController.text = "example@gmail.com";
    otpEditingController.text = "000000";
    phoneEditingController.text = "0869330512";
    super.onInit();
    //validateGoogleToken();
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
      if (token != null) {
        saveToken(token);
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

  Future<void> validateGoogleToken() async {
    String? token = await _auth.currentUser?.getIdToken();
    if (token != null && JwtDecoder.isExpired(token)) {
      saveToken(token);
      moveToNextPage();
      return;
    }
    ToastUntil.toastNotification('Có lỗi xảy ra', "Phiên đăng nhập của bạn đã hết hạn. Vui lòng đăng nhập lại để tiếp tục.", ToastStatus.warning);
    return;
  }

  Future<void> generateOTPByEmail() async {
    isSendOTP.value = true;
    final email = emailEditingController.text.trim();
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

  Future<void> signInWithEmail() async {
    verifyOtp();
    /*if (emailErrorInputObject.value.isError == true || otpErrorInputObject.value.isError == true) {
      return;
    }
    final email = emailEditingController.text.trim();
    final response = await AuthService.generateOTPByEmail({"email": email});

    final errorMessage = ResponseErrorUtil.handleErrorResponse(response.statusCode, response.body);

    if (errorMessage != null) {
      ToastUntil.toastNotification('Có lỗi xảy ra', errorMessage, ToastStatus.error);
      return;
    }

    final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
    ResponseModel<UserModel> model = ResponseModel.fromJson(decodedResponse, parseData: (data) => UserModel.fromJson(data));
    if (model.success == true) {
      String accessToken = model.data?.accessToken ?? "";
      saveToken(accessToken);
      moveToNextPage();
    } else {
      ToastUntil.toastNotification('Có lỗi xảy ra', model.message ?? 'Unknown error', ToastStatus.error);
    }*/
  }

  void onChangeSignInEmail(String value) {
    if (value.isEmpty) {
      emailErrorInputObject.value.isError = true;
      emailErrorInputObject.value.message = "Đây là trường bắt buộc";
    } else {
      bool isValidEmail = false;
      if (ValidateUtil.isValidEmail(value)) {
        isValidEmail = true;
      }
      if (isValidEmail) {
        emailErrorInputObject.value.isError = false;
      } else {
        emailErrorInputObject.value.isError = true;
        emailErrorInputObject.value.message = "Dữ liệu nhập vào của bạn không đúng định dạng, vui lòng kiểm tra lại";
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
        phoneNumber: phoneEditingController.text.trim().replaceFirst('0', '+84'),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);

          print("accessTokenfff ${credential.accessToken}");

          print("tokenINd ${credential.token}");
          Get.snackbar("Success", "Logged in successfully!");
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Verification failed: $e");
        },
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId.value = verificationId;
          print("VerifiedId: $verificationId");

        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId.value = verificationId;
        },
        timeout: const Duration(seconds: 120),
      );
    } catch (e) {
      Get.snackbar("Error", "Failed to verify phone number.");
    }
  }

  void verifyOtp() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId.value, smsCode: otpEditingController.text);
      await _auth.signInWithCredential(credential);
      _getToken();
      Get.snackbar("Success", "Logged in successfully!");
    } catch (e) {
      Get.snackbar("Error", "Invalid OTP.");
    }
  }
  void _getToken() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        String? token = await user.getIdToken();
        log("Token: $token");
        if (!JwtDecoder.isExpired(token!)) {
          print("kkfkfk");
        }
      }
    } catch (e) {
      print("Failed to get token: $e");
    }
  }


  void saveToken(String accessToken) {
    TokenSingleton.instance.setAccessToken(accessToken);
    SharedPrefHelper.instance.saveString(ConstantString.prefToken, accessToken);
  }

   void moveToNextPage() {
     Get.off(() => BottomNavigationBarView());
   }
}
