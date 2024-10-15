class ResponseModel<T> {
  final bool? success;
  final String? code;
  final String? message;
  final T? data;

  ResponseModel({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json, T Function(dynamic) parseData) {

    return ResponseModel<T>(
      success: json['success'] ?? false,
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null ? parseData(json['data']) : null,
    );
  }

}
