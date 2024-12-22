import 'package:rent_house/models/room_model.dart';

class Floor {
  String? id;
  String? name;
  List<Room>? rooms;

  Floor({
    this.id,
    this.name,
    this.rooms,
  });

  Floor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['rooms'] != null) {
      rooms = (json['rooms'] as List)
          .map((i) => Room.fromJson(i))
          .toList();
    } else {
      rooms = [];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rooms': rooms?.map((room) => room.toJson()).toList(),
    };
  }
}
