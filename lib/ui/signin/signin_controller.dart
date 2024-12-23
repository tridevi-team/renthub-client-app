import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rent_house/base/base_controller.dart';
import 'package:rent_house/constants/constant_string.dart';
import 'package:rent_house/constants/singleton/token_singleton.dart';
import 'package:rent_house/constants/singleton/user_singleton.dart';
import 'package:rent_house/models/error_input_model.dart';
import 'package:rent_house/models/response_model.dart';
import 'package:rent_house/models/user_model.dart';
import 'package:rent_house/services/auth_service.dart';
import 'package:rent_house/ui/account/customer/customer_controller.dart';
import 'package:rent_house/ui/home/bottom_nav_bar/bottom_navigation_bar.dart';
import 'package:rent_house/utils/app_util.dart';
import 'package:rent_house/utils/dialog_util.dart';
import 'package:rent_house/utils/response_error_util.dart';
import 'package:rent_house/utils/shared_pref_helper.dart';
import 'package:rent_house/utils/toast_until.dart';
import 'package:rent_house/utils/validate_util.dart';
import 'package:local_auth/local_auth.dart';

class SignInController extends BaseController {
  final CustomerController customerController = Get.put(CustomerController());
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
  int initialSeconds = 90;
  RxInt remainingSeconds = 0.obs;

  bool isSupportBiometrics = false;
  final LocalAuthentication localAuth = LocalAuthentication();

  @override
  void onInit() {
    if (kDebugMode) {
      otpEditingController.text = "123456";
      contactInputController.text = "0395327016";
    }
    _checkBiometrics();
    super.onInit();
  }

  Future<GoogleSignInAuthentication?> _authenticateWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        DialogUtil.hideLoading();
        _showToast('Quá trình xác thực Google bị hủy bỏ.', ToastStatus.warning);
        return null;
      }
      return await googleUser.authentication;
    } catch (e) {
      DialogUtil.hideLoading();
      _showToast('Đã xảy ra lỗi trong quá trình xác thực Google.', ToastStatus.error);
      return null;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      DialogUtil.showLoading();
      final googleAuth = await _authenticateWithGoogle();
      if (googleAuth == null) return;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      _processLogin(await _auth.currentUser?.getIdToken(), ConstantString.prefTypeEmail);
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e.code);
    } catch (e) {
      DialogUtil.hideLoading();
      AppUtil.printDebugMode(type: "Đăng nhập thất bại", message: "$e");
      _showToast('Đã xảy ra lỗi không xác định.', ToastStatus.warning);
    }
  }

  Future<void> generateOTPByEmail() async {
    try {
      DialogUtil.showLoading();
      final email = contactInputController.text.trim();
      final response = await AuthService.generateOTPByEmail({"email": email});
      final model = ResponseModel.fromJson(jsonDecode(response.body));
      DialogUtil.hideLoading();
      if (response.statusCode == 200 && model.success == true) {
        _showToast('Mã xác thực đã gửi đến email của bạn.', ToastStatus.success);
        startCountdown();
      } else if (model.success == false && model.code == "RENTER_NOT_FOUND") {
        _showToast(ConstantString.accountNotFoundMessage, ToastStatus.error);
      } else {
        _showToast(ConstantString.tryAgainMessage, ToastStatus.error);
      }
    } catch (e) {
      DialogUtil.hideLoading();
      AppUtil.printDebugMode(type: "Generate OTP", message: "$e");
    }
  }

  Future<void> onLogin() async {
    if (contactErrorInputObject.value.isError || otpErrorInputObject.value.isError) return;
    contactInputController.text.isPhoneNumber ? signInWithPhone() : signInWithEmail();
  }

  Future<void> signInWithEmail() async {
    DialogUtil.showLoading();
    final email = contactInputController.text.trim();
    final otp = otpEditingController.text.trim();

    try {
      final response = await AuthService.verifyEmailByOTP({
        "email": email,
        "code": otp,
      });
      DialogUtil.hideLoading();
      final model = ResponseModel<UserModel>.fromJson(
        jsonDecode(response.body),
        parseData: (data) => UserModel.fromJson(data),
      );
      if (model.success == true && model.data != null && response.statusCode == 200) {
        final user = model.data!;
        UserSingleton.instance.setUser(user);
        _processLogin(user.accessToken, ConstantString.prefTypeServer, refreshToken: user.refreshToken);
      } else {
        if (model.code == "INVALID_VERIFICATION_CODE") {
          _showToast(ConstantString.invalidOTPMessage, ToastStatus.error);
        } else {
          _showToast(model.message ?? ConstantString.tryAgainMessage, ToastStatus.error);
        }
        return;
      }
    } catch (e) {
      DialogUtil.hideLoading();
      _showToast(ConstantString.tryAgainMessage, ToastStatus.error);
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
    if (contactErrorInputObject.value.isError) {
      return;
    }
    if (isSendOTP.isTrue) {
      return;
    }
    if (contactInputController.text.isPhoneNumber) {
      await _sendOTPByPhone();
    } else {
      generateOTPByEmail();
    }
  }

  Future<void> _sendOTPByPhone() async {
    try {
      DialogUtil.showLoading();
      await _auth.verifyPhoneNumber(
        phoneNumber: contactInputController.text.trim().replaceFirst('0', '+84'),
        verificationCompleted: (PhoneAuthCredential credential) async {
          startCountdown();
          await _auth.signInWithCredential(credential);
          DialogUtil.hideLoading();
        },
        verificationFailed: (FirebaseAuthException e) {
          DialogUtil.hideLoading();
          _handleAuthError(e.code);
        },
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId = verificationId;
          DialogUtil.hideLoading();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId = verificationId;
          DialogUtil.hideLoading();
        },
        timeout: const Duration(seconds: 120),
      );
    } catch (e) {
      DialogUtil.hideLoading();
      _showToast("Không xác minh được số điện thoại", ToastStatus.error);
    }
  }

  void signInWithPhone() async {
    try {
      DialogUtil.showLoading();
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpEditingController.text,
      );
      await _auth.signInWithCredential(credential);
      String token = await _auth.currentUser?.getIdToken() ?? '';
      _processLogin(token, ConstantString.prefTypePhone);
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e.code);
      DialogUtil.hideLoading();
    } catch (e) {
      DialogUtil.hideLoading();
      _showToast(ConstantString.tryAgainMessage, ToastStatus.error);
    }
  }

  void _processLogin(String? token, String type, {String? refreshToken}) async {
    DialogUtil.hideLoading();
    if (token?.isNotEmpty ?? false) {
      accessToken = token!;
      this.refreshToken = refreshToken ?? '';
      TokenSingleton.instance.setAccessToken(token);
      if (type != ConstantString.prefTypeServer) {
        final isHaveAccount = await customerController.getCustomerInfo();
        if (!isHaveAccount) return;
      }
      saveToken(type);
      moveToNextPage(true);
      return;
    }
    Get.back();
    return;
  }

  void saveToken(String type) async {
    TokenSingleton.instance.setRefreshToken(refreshToken);
    SharedPrefHelper.instance.saveString(ConstantString.prefAccessToken, accessToken);
    SharedPrefHelper.instance.saveString(ConstantString.prefRefreshToken, refreshToken);
    SharedPrefHelper.instance.saveString(ConstantString.prefAppType, type);
    SharedPrefHelper.instance.saveString(ConstantString.prefUserId, UserSingleton.instance.getUser().id ?? "");
  }

  void moveToNextPage(bool isCustomer) {
    Get.offAll(() => BottomNavigationBarView(isCustomer: isCustomer));
  }

  void _showToast(String message, ToastStatus status) async {
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
    _showToast(message, ToastStatus.error);
  }

  void startCountdown() {
    if (remainingSeconds.value == 0) {
      remainingSeconds.value = initialSeconds;
    }
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

  Future<void> loginWithFingerprint() async {
    try {
      DialogUtil.showLoading();
      String token = SharedPrefHelper.instance.getString(ConstantString.prefRefreshToken) ?? "";
      String userId = SharedPrefHelper.instance.getString(ConstantString.prefUserId) ?? "";
      final response = await AuthService.refreshToken(token, userId);
      DialogUtil.hideLoading();
      if (response.statusCode == 200) {
        accessToken = jsonDecode(response.body)["data"]["accessToken"];
        _processLogin(accessToken, "", refreshToken: token);
      } else {
        ToastUntil.toastNotification(description: "Bạn cần đăng nhập bằng gmail để sử dụng chức năng này.", status: ToastStatus.error);
      }
    } catch (e) {
      ToastUntil.toastNotification(description: ConstantString.tryAgainMessage, status: ToastStatus.error);
      AppUtil.printDebugMode(type: "login fingerprint", message: "$e");
    }
  }

  Future<void> _checkBiometrics() async {
    localAuth.isDeviceSupported().then((bool isSupported) => isSupportBiometrics = isSupported);
  }

  Future<void> authenticateFingerprint() async {
    try {
      int? isFirstLogin = SharedPrefHelper.instance.getInt(ConstantString.prefFirstLogin);
      if (isFirstLogin != 1) {
        ToastUntil.toastNotification(description: "Bạn cần đăng nhập lần đầu tiên trước khi sử dụng chức năng này.", status: ToastStatus.error);
        return;
      }

      if (!isSupportBiometrics) {
        ToastUntil.toastNotification(description: "Thiết bị của bạn không hỗ trợ vân tay.", status: ToastStatus.error);
        return;
      }
      bool authenticated = await localAuth.authenticate(
        localizedReason: 'Sử dụng dấu vân tay của bạn để xác minh',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true
        ),
      );
      if (authenticated) {
        loginWithFingerprint();
        return;
      } else {
        ToastUntil.toastNotification(description: "Xác minh thất bại. Vui lòng thử lại hoặc sử dụng phương thức đăng nhập khác.", status: ToastStatus.error);
      }
    } catch (e) {
      AppUtil.printDebugMode(type: "authenticate fingerprint", message: "$e");
      ToastUntil.toastNotification(description: ConstantString.tryAgainMessage, status: ToastStatus.error);
    }
  }
}
