import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rent_house/constants/access_token_singleton.dart';
import 'package:rent_house/constants/web_service.dart';

enum HttpMethod { get, post, put, delete, patch }

class BaseService {
  static const int _timeoutDuration = 20; // Timeout duration in seconds

  static Future<http.Response> requestApi({
    required String endpoint,
    dynamic params,
    required HttpMethod httpMethod,
    bool auth = false,
    Map<String, String>? headers,
  }) async {
    http.Response? response;
    headers ??= <String, String>{};
    headers["accept"] = "application/json";

    if (auth) {
      AccessTokenSingleton.instance.token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjIyMjA3ODc2LWEzYmEtNDI3ZC04ODBlLTFjZGQ0YjIzMTQwNCIsImVtYWlsIjoiZXhhbXBsZUBnbWFpbC5jb20iLCJwYXNzd29yZCI6IiQyYiQxMCRicFl3TEF5ektMaUJhRXRyRkRNc3AuQ0pTandQS0N5SURySTFrR3UyN1pzRUl4SW1GenNCVyIsInJvbGUiOiJ1c2VyIiwic3RhdHVzIjoxLCJpYXQiOjE3Mjc3OTMwNDMsImV4cCI6MTcyNzc5NjY0M30.qigGo7all_D4Yly8vqeXqSm3ESeo2S3E63ZrilNC9JA';
      String? token = AccessTokenSingleton.instance.token;
      headers["Authorization"] = "Bearer $token";
      if (kDebugMode) {
        print('Token: $token');
      }
    }

    final uri = Uri.parse('${WebService.baseUrl}$endpoint');

    try {
      switch (httpMethod) {
        case HttpMethod.get:
          response = await http.get(uri, headers: headers).timeout(
            const Duration(seconds: _timeoutDuration),
          );
          break;
        case HttpMethod.post:
          response = await http.post(uri, headers: headers, body: jsonEncode(params)).timeout(
            const Duration(seconds: _timeoutDuration),
          );
          break;
        case HttpMethod.put:
          response = await http.put(uri, headers: headers, body: jsonEncode(params)).timeout(
            const Duration(seconds: _timeoutDuration),
          );
          break;
        case HttpMethod.delete:
          response = await http.delete(uri, headers: headers, body: jsonEncode(params)).timeout(
            const Duration(seconds: _timeoutDuration),
          );
          break;
        case HttpMethod.patch:
          response = await http.patch(uri, headers: headers, body: jsonEncode(params)).timeout(
            const Duration(seconds: _timeoutDuration),
          );
          break;
      }
    } on SocketException {
      response = http.Response('Không có kết nối internet...', 522);
    } on TimeoutException {
      response = http.Response('Yêu cầu đã hết thời gian chờ...', 408);
    } catch (e) {
      debugPrint("======= Lỗi try catch api =====");
      debugPrint("ERROR: $e");
      debugPrint("===============================");
      response = http.Response('Có lỗi xảy ra...', 0000);
    }

    if (response.statusCode == 401) {
      // Handle unauthorized access, e.g., token expiration
      if (jsonDecode(response.body)["message"] != null) {
        // Process the message
      }
    }
    if (kDebugMode) {
      log("=============Response===================");
      print(response.body);
    }

    return response;
  }
}
