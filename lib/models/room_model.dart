import 'package:json_annotation/json_annotation.dart';

part 'generated/room_model.g.dart';

@JsonSerializable()
class Room {
  final String id;
  final String floorId;
  final String name;
  final int maxRenters;
  final int roomArea;
  final int price;
  final String description;
  final String status;
  final String createdBy;
  final String createdAt;
  final String updatedBy;
  final String updatedAt;

  Room({
    required this.id,
    required this.floorId,
    required this.name,
    required this.maxRenters,
    required this.roomArea,
    required this.price,
    required this.description,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    required this.updatedBy,
    required this.updatedAt,
  });

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
  Map<String, dynamic> toJson() => _$RoomToJson(this);
}
