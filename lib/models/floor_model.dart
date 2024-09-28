import 'package:json_annotation/json_annotation.dart';
import 'room_model.dart';

part 'generated/floor_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Floor {
  final String id;
  final String houseId;
  final String name;
  final String description;
  final String createdBy;
  final String createdAt;
  final String updatedBy;
  final String updatedAt;
  final List<Room> rooms;

  Floor({
    required this.id,
    required this.houseId,
    required this.name,
    required this.description,
    required this.createdBy,
    required this.createdAt,
    required this.updatedBy,
    required this.updatedAt,
    required this.rooms,
  });

  factory Floor.fromJson(Map<String, dynamic> json) => _$FloorFromJson(json);
  Map<String, dynamic> toJson() => _$FloorToJson(this);
}
