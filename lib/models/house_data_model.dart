import 'address_model.dart';
import 'floor_model.dart';

class HouseDataModel {
  List<House>? results;
  int? total;
  int? page;
  int? limit;

  HouseDataModel({
    this.results,
    this.total,
    this.page,
    this.limit,
  });

  HouseDataModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      var list = json['results'] as List;
      results = list.map((i) => House.fromJson(i)).toList();
    } else {
      results = [];
    }
    total = json['total'];
    page = json['page'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    return {
      'results': results?.map((house) => house.toJson()).toList(),
      'total': total,
      'page': page,
      'limit': limit,
    };
  }
}

class House {
  String? id;
  String? name;
  Address? address;
  String? description;
  int? collectionCycle;
  int? minRenters;
  int? maxRenters;
  int? minPrice;
  int? maxPrice;
  int? numOfRooms;
  int? minRoomArea;
  int? maxRoomArea;
  String? thumbnail;
  List<Floor>? floors;

  House({
    this.id,
    this.name,
    this.address,
    this.description,
    this.collectionCycle,
    this.minRenters,
    this.maxRenters,
    this.minPrice,
    this.maxPrice,
    this.numOfRooms,
    this.minRoomArea,
    this.maxRoomArea,
    this.thumbnail,
    this.floors,
  });

  House.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? '';
    name = json['name'] ?? '';
    address = json.containsKey('address') && json['address'] != null
        ? Address.fromJson(json['address'])
        : null;
    collectionCycle = json['collectionCycle'];
    description = json['description'] ?? '';
    minRenters = json['minRenters'] ?? 0;
    maxRenters = json['maxRenters'] ?? 0;
    minPrice = json['minPrice'] ?? 0;
    maxPrice = json['maxPrice'] ?? 0;
    numOfRooms = json['numOfRooms'] ?? 0;
    minRoomArea = json['minRoomArea'] ?? 0;
    maxRoomArea = json['maxRoomArea'] ?? 0;
    thumbnail = json['thumbnail'] ?? '';

    if (json['floors'] != null) {
      var floorList = json['floors'] as List;
      floors = floorList.map((i) => Floor.fromJson(i)).toList();
    } else {
      floors = [];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address?.toJson(),
      'description': description,
      'collectionCycle': collectionCycle,
      'minRenters': minRenters,
      'maxRenters': maxRenters,
      'minPrice': minPrice,
      'maxPrice': maxPrice,
      'numOfRooms': numOfRooms,
      'minRoomArea': minRoomArea,
      'maxRoomArea': maxRoomArea,
      'thumbnail': thumbnail,
      'floors': floors?.map((floor) => floor.toJson()).toList(),
    };
  }
}
