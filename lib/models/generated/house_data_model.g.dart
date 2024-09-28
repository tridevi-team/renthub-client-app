// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../house_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HouseDataModel _$HouseDataModelFromJson(Map<String, dynamic> json) =>
    HouseDataModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
      contractDefault: json['contractDefault'] as String,
      description: json['description'] as String,
      collectionCycle: (json['collectionCycle'] as num).toInt(),
      invoiceDate: (json['invoiceDate'] as num).toInt(),
      numCollectDays: (json['numCollectDays'] as num).toInt(),
      status: (json['status'] as num).toInt(),
      createdBy: json['createdBy'] as String,
      createdAt: json['createdAt'] as String,
      updatedBy: json['updatedBy'] as String,
      updatedAt: json['updatedAt'] as String,
      floors: (json['floors'] as List<dynamic>)
          .map((e) => Floor.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HouseDataModelToJson(HouseDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address.toJson(),
      'contractDefault': instance.contractDefault,
      'description': instance.description,
      'collectionCycle': instance.collectionCycle,
      'invoiceDate': instance.invoiceDate,
      'numCollectDays': instance.numCollectDays,
      'status': instance.status,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt,
      'updatedBy': instance.updatedBy,
      'updatedAt': instance.updatedAt,
      'floors': instance.floors.map((e) => e.toJson()).toList(),
    };
