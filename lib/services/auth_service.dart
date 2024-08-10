import 'package:http/http.dart' as http;
import 'package:rent_house/base/base_service.dart';

class AuthService{
  static Future<http.Response> loginWithPassword(Map<String, dynamic> data){
    String endpoint = '';
    return BaseService.requestApi(endpoint: endpoint, params: data,
        httpMethod: HttpMethod.post,auth: false);
  }

  /*TODO
  static Future<http.Response> loginWithGoogleToken(token) async {}*/

  static Future<http.Response> signUp(Map<String, dynamic> data) async {
    String endpoint = '';
    return BaseService.requestApi(endpoint: endpoint, params: data,
        httpMethod: HttpMethod.post,auth: false);
  }

  static Future<http.Response> generateForgotPasswordOtpByEmail(String email) async {
    String endpoint = 'users/forgotPassword';
    return BaseService.requestApi(endpoint: endpoint, params: {"email: $email"},
        httpMethod: HttpMethod.post,auth: false);
  }

  static Future<http.Response> verifyEmailPByOTP(Map<String, dynamic> data) async {
    String endpoint = 'users/verifyAccount';
    return BaseService.requestApi(endpoint: endpoint, params: data,
        httpMethod: HttpMethod.post,auth: false);
  }

  static Future<http.Response> updatePasswordWithToken(Map<String, dynamic> data) async {
    String endpoint = 'users/updatePassword';
    return BaseService.requestApi(endpoint: endpoint, params: data,
        httpMethod: HttpMethod.put,auth: true);
  }

  static Future<http.Response> resendCode(Map<String, dynamic> data) async {
    String endpoint = 'users/resendCode';
    return BaseService.requestApi(endpoint: endpoint, params: data,
        httpMethod: HttpMethod.put,auth: false);
  }

  static Future<http.Response> resetPassword(Map<String, dynamic> data) async {
    String endpoint = 'users/resetPassword';
    return BaseService.requestApi(endpoint: endpoint, params: data,
        httpMethod: HttpMethod.post,auth: false);
  }

  static Future<http.Response> firstLogin() async {
    String endpoint = 'users/firstLogin';
    return BaseService.requestApi(endpoint: endpoint,
        httpMethod: HttpMethod.put,auth: true);
  }
}