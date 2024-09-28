// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      city: json['city'] as String,
      district: json['district'] as String,
      ward: json['ward'] as String,
      street: json['street'] as String,
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'city': instance.city,
      'district': instance.district,
      'ward': instance.ward,
      'street': instance.street,
    };
