import 'package:rent_house/models/room_model.dart';

class Floor {
  String? id;
  String? name;
  List<Room>? rooms;

  Floor({
    required this.id,
    required this.name,
    required this.rooms,
  });

  factory Floor.fromJson(Map<String, dynamic> json) {
    var roomList = json['rooms'] as List;
    List<Room> rooms = roomList.map((i) => Room.fromJson(i)).toList();
    return Floor(
      id: json['id'],
      name: json['name'],
      rooms: rooms,
    );
  }
}
