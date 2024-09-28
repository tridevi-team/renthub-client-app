import 'package:json_annotation/json_annotation.dart';

part 'generated/address_model.g.dart';

@JsonSerializable()
class Address {
  final String city;
  final String district;
  final String ward;
  final String street;

  Address({
    required this.city,
    required this.district,
    required this.ward,
    required this.street,
  });

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
