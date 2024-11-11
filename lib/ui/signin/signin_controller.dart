import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  final TextEditingController contactInputController = TextEditingController();
  final TextEditingController otpEditingController = TextEditingController();
  final Rx<ErrorInputModel> contactErrorInputObject = ErrorInputModel().obs;
  final Rx<ErrorInputModel> otpErrorInputObject = ErrorInputModel().obs;
  final RxBool isSendOTP = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId = '';
  String accessToken = '';
  String refreshToken = '';
  Timer? _timer;
  RxInt remainingSeconds = 90.obs;

  static const String defaultErrorMessage = "Có lỗi xảy ra. Vui lòng thử lại.";

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
        _showToast('Quá trình xác thực Google bị hủy bỏ.', ToastStatus.warning);
        return null;
      }
      return await googleUser.authentication;
    } catch (e) {
      _showToast('Đã xảy ra lỗi trong quá trình xác thực Google.', ToastStatus.error);
      return null;
    }
  }

  Future<void> signInWithGoogle() async {
    final googleAuth = await _authenticateWithGoogle();
    if (googleAuth == null) return;

    try {
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      _processLogin(await _auth.currentUser?.getIdToken(), ConstantString.prefTypeEmail);
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e.code);
    } catch (e) {
      _logError('Đăng nhập thất bại', e);
      _showToast('Đã xảy ra lỗi không xác định.', ToastStatus.warning);
    }
  }

  Future<void> generateOTPByEmail() async {
    final email = contactInputController.text.trim();
    final response = await AuthService.generateOTPByEmail({"email": email});

    final errorMessage = ResponseErrorUtil.handleErrorResponse(response.statusCode, response.body);
    if (errorMessage != null) {
      _showToast(errorMessage, ToastStatus.error);
      return;
    }
    final model = ResponseModel.fromJson(jsonDecode(response.body));
    if (model.success != true) {
      _showToast(model.message ?? defaultErrorMessage, ToastStatus.error);
    } else {
      _showToast('Mã xác thực đã gửi đến email của bạn.', ToastStatus.success);
      startCountdown();
    }
  }

  Future<void> onLogin() async {
    if (contactErrorInputObject.value.isError || otpErrorInputObject.value.isError) return;
    contactInputController.text.isPhoneNumber ? signInWithPhone() : signInWithEmail();
  }

  Future<void> signInWithEmail() async {
    final email = contactInputController.text.trim();
    final otp = otpEditingController.text.trim();
    final response = await AuthService.verifyEmailByOTP({"email": email, "code": otp});

    final errorMessage = ResponseErrorUtil.handleErrorResponse(response.statusCode, response.body);
    if (errorMessage != null) {
      _showToast(errorMessage, ToastStatus.error);
      return;
    }

    final model = ResponseModel<UserModel>.fromJson(
      jsonDecode(response.body),
      parseData: (data) => UserModel.fromJson(data),
    );

    if (model.success == true) {
      //_processLogin(model.data?.token, model.data?.refreshToken, ConstantString.prefTypeServer);
    } else {
      _showToast(model.message ?? defaultErrorMessage, ToastStatus.error);
    }
  }

  void onChangeContactInput(String value) {
    if (value.isEmpty) {
      _setContactError("Đây là trường bắt buộc");
    } else if (ValidateUtil.isValidEmail(value) || ValidateUtil.isValidPhone(value)) {
      _clearContactError();
    } else {
      _setContactError("Dữ liệu nhập vào của bạn không đúng định dạng, vui lòng kiểm tra lại");
    }
  }

  void onChangeOTP(String value) {
    if (value.isEmpty) {
      _setOtpError("Đây là trường bắt buộc");
    } else if (!ValidateUtil.isValidOTP(value)) {
      _setOtpError("Dữ liệu nhập vào của bạn không đúng định dạng, vui lòng kiểm tra lại");
    } else {
      otpErrorInputObject.value.isError = false;
    }
  }

  void sendOTP() async {
    if (contactInputController.text.isPhoneNumber) {
      await _sendOTPByPhone();
    } else {
      generateOTPByEmail();
    }
  }

  Future<void> _sendOTPByPhone() async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: contactInputController.text.trim().replaceFirst('0', '+84'),
        verificationCompleted: (PhoneAuthCredential credential) async {
          startCountdown();
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          _showToast(defaultErrorMessage, ToastStatus.error);
        },
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId = verificationId;
        },
        timeout: const Duration(seconds: 120),
      );
    } catch (e) {
      _showToast("Không xác minh được số điện thoại", ToastStatus.error);
    }
  }

  void signInWithPhone() async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpEditingController.text,
      );
      await _auth.signInWithCredential(credential);
      _processLogin(await _auth.currentUser?.getIdToken(), ConstantString.prefTypePhone);
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e.code);
    } catch (e) {
      _showToast(defaultErrorMessage, ToastStatus.error);
    }
  }

  void _processLogin(String? token, String type, {String? refreshToken}) {
    if (token != null) {
      accessToken = token;
      this.refreshToken = refreshToken ?? '';
      saveToken(type);
      moveToNextPage();
    }
  }

  void saveToken(String type) {
    TokenSingleton.instance.setAccessToken(accessToken);
    TokenSingleton.instance.setRefreshToken(refreshToken);
    SharedPrefHelper.instance.saveString(ConstantString.prefAccessToken, accessToken);
    SharedPrefHelper.instance.saveString(ConstantString.prefRefreshToken, refreshToken);
    SharedPrefHelper.instance.saveString(ConstantString.prefAppType, type);
  }

  void moveToNextPage() {
    Get.off(() => BottomNavigationBarView());
  }

  void _showToast(String message, ToastStatus status) {
    ToastUntil.toastNotification(description: message, status: status);
  }

  void _setContactError(String message) {
    contactErrorInputObject.value.isError = true;
    contactErrorInputObject.value.message = message;
  }

  void _clearContactError() {
    contactErrorInputObject.value.isError = false;
    contactErrorInputObject.value.message = "";
  }

  void _setOtpError(String message) {
    otpErrorInputObject.value.isError = true;
    otpErrorInputObject.value.message = message;
  }

  void _handleAuthError(String code) {
    String message;
    switch (code) {
      case 'user-disabled':
        message = 'Tài khoản đã bị vô hiệu hóa.';
        break;
      case 'invalid-credential':
        message = 'Thông tin xác thực không hợp lệ.';
        break;
      case 'invalid-verification-code':
        message = 'Mã xác minh không hợp lệ. Vui lòng kiểm tra lại.';
        break;
      case 'session-expired':
        message = 'Phiên xác thực đã hết hạn. Vui lòng gửi lại mã OTP.';
        break;
      case 'too-many-requests':
        message = 'Quá nhiều yêu cầu. Vui lòng thử lại sau.';
        break;
      default:
        message = 'Lỗi xác thực';
        break;
    }
    _showToast(message, ToastStatus.warning);
  }

  void startCountdown() {
    if (_timer == null || !_timer!.isActive) {
      isSendOTP.value = true;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (remainingSeconds > 0) {
          remainingSeconds.value--;
        } else {
          isSendOTP.value = false;
          timer.cancel();
          _timer = null;
        }
      });
    }
  }

  String get formattedRemainingTime {
    final minutes = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (remainingSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }


  void _logError(String message, Object e) {
    if (kDebugMode) {
      print('$message: $e');
    }
  }
}
