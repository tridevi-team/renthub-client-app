import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rent_house/constants/singleton/token_singleton.dart';
import 'package:rent_house/constants/web_service.dart';
import 'package:rent_house/untils/app_util.dart';

enum HttpMethod { get, post, put, delete, patch, multipart }

class BaseService {
  static const int _defaultTimeout = 20;

  static Future<http.Response> requestApi(
      {required String endpoint,
      dynamic params,
      required HttpMethod httpMethod,
      bool auth = false,
      Map<String, String>? additionalHeaders,
      bool useFullUrl = false,
      int timeoutDuration = _defaultTimeout,
      List<File>? files,
      void Function(double progress)? onProgress}) async {
    http.Response response;
    final headers = _buildHeaders(auth, additionalHeaders);
    final uri = _buildUri(endpoint, useFullUrl);

    try {
      switch (httpMethod) {
        case HttpMethod.get:
          response =
              await http.get(uri, headers: headers).timeout(Duration(seconds: timeoutDuration));
          break;
        case HttpMethod.post:
          response = await http
              .post(uri, headers: headers, body: jsonEncode(params))
              .timeout(Duration(seconds: timeoutDuration));
          break;
        case HttpMethod.put:
          response = await http
              .put(uri, headers: headers, body: jsonEncode(params))
              .timeout(Duration(seconds: timeoutDuration));
          break;
        case HttpMethod.delete:
          response = await http
              .delete(uri, headers: headers, body: jsonEncode(params))
              .timeout(Duration(seconds: timeoutDuration));
          break;
        case HttpMethod.patch:
          response = await http
              .patch(uri, headers: headers, body: jsonEncode(params))
              .timeout(Duration(seconds: timeoutDuration));
          break;
        case HttpMethod.multipart:
          response = await _uploadFiles(uri, files, params, headers, timeoutDuration, onProgress);
          break;
        default:
          throw UnsupportedError("Unsupported HTTP method");
      }
    } on SocketException {
      AppUtil.printDebugMode(type: "API Error", message: "No internet connection");
      return http.Response('No internet connection', 522);
    } on TimeoutException {
      AppUtil.printDebugMode(type: "API Error", message: "Request timed out");
      return http.Response('Request timed out', 408);
    } catch (e) {
      AppUtil.printDebugMode(type: "API Error", message: "Unexpected error: $e");
      return http.Response('Something went wrong', 500);
    }

    if (response.statusCode == 401) {
      AppUtil.printDebugMode(
          type: "API Error", message: "Unauthorized request, attempting token refresh...");
      final refreshed = await _handleTokenRefresh();
      if (refreshed) {
        return requestApi(
          endpoint: endpoint,
          params: params,
          httpMethod: httpMethod,
          auth: auth,
          additionalHeaders: additionalHeaders,
          useFullUrl: useFullUrl,
          timeoutDuration: timeoutDuration,
          files: files,
        );
      }
    }

    _logResponse(response, httpMethod, endpoint);
    return response;
  }

  static Future<http.Response> _uploadFiles(
    Uri uri,
    List<File>? files,
    Map<String, dynamic>? params,
    Map<String, String> headers,
    int timeoutDuration,
    void Function(double progress)? onProgress,
  ) async {
    if (files == null || files.isEmpty) {
      return http.Response('No files to upload', 400);
    }

    try {
      final request = http.MultipartRequest('POST', uri);

      for (var file in files) {
        request.files.add(await http.MultipartFile.fromPath('files', file.path));
      }

      if (params != null) {
        params.forEach((key, value) {
          request.fields[key] = value.toString();
        });
      }

      request.headers.addAll(headers);

      final totalLength = request.contentLength;
      int uploaded = 0;

      // Completer để đánh dấu tiến trình hoàn thành
      final Completer<void> progressCompleter = Completer<void>();

      // Stream tiến trình tải lên
      final stream = http.ByteStream(
        request.finalize().transform(
          StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              sink.add(data);
              uploaded += data.length;
              if (onProgress != null && totalLength > 0) {
                onProgress(uploaded / totalLength);
              }
              if (uploaded >= totalLength && !progressCompleter.isCompleted) {
                progressCompleter.complete();
              }
            },
          ),
        ),
      );

      final streamedRequest = http.StreamedRequest('POST', uri)..headers.addAll(request.headers);

      await for (var chunk in stream) {
        streamedRequest.sink.add(chunk);
      }
      streamedRequest.sink.close();

      final streamedResponse =
          await streamedRequest.send().timeout(Duration(seconds: timeoutDuration));

      final responseBytes = await streamedResponse.stream.toBytes();
      final responseString = String.fromCharCodes(responseBytes);

      // Đảm bảo tiến trình tải lên hoàn thành trước khi trả về
      await progressCompleter.future;

      return http.Response(responseString, streamedResponse.statusCode);
    } on TimeoutException {
      return http.Response('Request timed out', 408);
    } catch (e) {
      AppUtil.printDebugMode(type: "File Upload", message: "Error uploading files: $e");
      return http.Response('Error uploading files', 500);
    }
  }

  static Map<String, String> _buildHeaders(bool auth, Map<String, String>? additionalHeaders) {
    final headers = {
      "Content-Type": "application/json",
    };

    if (auth) {
      final token = TokenSingleton.instance.accessToken;
      if (token != null) {
        headers["Authorization"] = "Bearer $token";
      } else {
        AppUtil.printDebugMode(type: "Token", message: "No access token available");
      }
    }

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  static Uri _buildUri(String endpoint, bool useFullUrl) {
    return useFullUrl ? Uri.parse(endpoint) : Uri.parse("${WebService.baseUrl}$endpoint");
  }

  static void _logResponse(http.Response response, HttpMethod method, String endpoint) {
    if (kDebugMode) {
      log("============= API Response =============");
      log("Method: $method");
      log("Endpoint: $endpoint");
      log("Status Code: ${response.statusCode}");
      log("Response Body: ${response.body}");
      log("========================================");
    }
  }

  static Future<bool> _handleTokenRefresh() async {
    try {
      // Implement your token refresh logic here
      // Example:
      // final refreshToken = TokenSingleton.instance.refreshToken;
      // final response = await requestApi(
      //   endpoint: "/auth/refresh",
      //   params: {"refreshToken": refreshToken},
      //   httpMethod: HttpMethod.post,
      //   auth: false,
      // );
      // if (response.statusCode == 200) {
      //   final newToken = jsonDecode(response.body)["accessToken"];
      //   TokenSingleton.instance.updateAccessToken(newToken);
      //   return true;
      // }
    } catch (e) {
      AppUtil.printDebugMode(type: "Token Refresh", message: "Token refresh failed: $e");
    }
    return false;
  }
}
