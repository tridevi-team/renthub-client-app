import 'package:json_annotation/json_annotation.dart';

part 'generated/response_model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ResponseModel<T> {
  final bool success;
  final String code;
  final String message;
  final T data;

  ResponseModel({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory ResponseModel.fromJson(
      Map<String, dynamic> json,
      T Function(Object? json) fromJsonT,
      ) => _$ResponseModelFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(
      Object Function(T value) toJsonT,
      ) => _$ResponseModelToJson(this, toJsonT);
}