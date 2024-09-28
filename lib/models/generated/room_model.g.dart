// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Room _$RoomFromJson(Map<String, dynamic> json) => Room(
      id: json['id'] as String,
      floorId: json['floorId'] as String,
      name: json['name'] as String,
      maxRenters: (json['maxRenters'] as num).toInt(),
      roomArea: (json['roomArea'] as num).toInt(),
      price: (json['price'] as num).toInt(),
      description: json['description'] as String,
      status: json['status'] as String,
      createdBy: json['createdBy'] as String,
      createdAt: json['createdAt'] as String,
      updatedBy: json['updatedBy'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      'id': instance.id,
      'floorId': instance.floorId,
      'name': instance.name,
      'maxRenters': instance.maxRenters,
      'roomArea': instance.roomArea,
      'price': instance.price,
      'description': instance.description,
      'status': instance.status,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt,
      'updatedBy': instance.updatedBy,
      'updatedAt': instance.updatedAt,
    };
