import 'package:json_annotation/json_annotation.dart';
import 'address_model.dart';
import 'floor_model.dart';

part 'generated/house_data_model.g.dart';

@JsonSerializable(explicitToJson: true)
class HouseDataModel {
  final String id;
  final String name;
  final Address address;
  final String contractDefault;
  final String description;
  final int collectionCycle;
  final int invoiceDate;
  final int numCollectDays;
  final int status;
  final String createdBy;
  final String createdAt;
  final String updatedBy;
  final String updatedAt;
  final List<Floor> floors;

  HouseDataModel({
    required this.id,
    required this.name,
    required this.address,
    required this.contractDefault,
    required this.description,
    required this.collectionCycle,
    required this.invoiceDate,
    required this.numCollectDays,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    required this.updatedBy,
    required this.updatedAt,
    required this.floors,
  });

  factory HouseDataModel.fromJson(Map<String, dynamic> json) => _$HouseDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$HouseDataModelToJson(this);
}
