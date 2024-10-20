import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:rent_house/base/base_service.dart';

class AuthService{
  static Future<http.Response> generateOTPByEmail(Map<String, dynamic> data){
    String endpoint = '/renters/login';
    return BaseService.requestApi(endpoint: endpoint, params: data,
        httpMethod: HttpMethod.post);
  }

  /*static Future<http.Response> signUp(Map<String, dynamic> data) async {
    String endpoint = '';
    return BaseService.requestApi(endpoint: endpoint, params: data,
        httpMethod: HttpMethod.post);
  }*/

  static Future<http.Response> generateForgotPasswordOtpByEmail(String email) async {
    String endpoint = 'renters/forgotPassword';
    return BaseService.requestApi(endpoint: endpoint, params: {"email: $email"},
        httpMethod: HttpMethod.post);
  }

  static Future<http.Response> verifyEmailByOTP(Map<String, dynamic> data) async {
    String endpoint = 'renters/verify';
    return BaseService.requestApi(endpoint: endpoint, params: data,
        httpMethod: HttpMethod.post);
  }

  static Future<http.Response> updatePasswordWithToken(Map<String, dynamic> data) async {
    String endpoint = 'renters/updatePassword';
    return BaseService.requestApi(endpoint: endpoint, params: data,
        httpMethod: HttpMethod.put,auth: true);
  }

  static Future<http.Response> resendCode(Map<String, dynamic> data) async {
    String endpoint = 'renters/resendCode';
    return BaseService.requestApi(endpoint: endpoint, params: data,
        httpMethod: HttpMethod.put);
  }

  static Future<http.Response> resetPassword(Map<String, dynamic> data) async {
    String endpoint = 'renters/resetPassword';
    return BaseService.requestApi(endpoint: endpoint, params: data,
        httpMethod: HttpMethod.post);
  }

  static Future<http.Response> firstLogin() async {
    String endpoint = 'renters/firstLogin';
    return BaseService.requestApi(endpoint: endpoint,
        httpMethod: HttpMethod.put,auth: true);
  }
}