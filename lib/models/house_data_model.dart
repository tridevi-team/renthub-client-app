import 'address_model.dart';
import 'floor_model.dart';

class HouseDataModel {
  final List<House>? results;
  final int? total;
  final int? page;
  final int? limit;

  HouseDataModel({
    this.results,
    this.total,
    this.page,
    this.limit,
  });

  factory HouseDataModel.fromJson(Map<String, dynamic> json) {
    var list = json['results'] as List;
    List<House> houseList = list.map((i) => House.fromJson(i)).toList();
    return HouseDataModel(
      results: houseList,
      total: json['total'],
      page: json['page'],
      limit: json['limit'],
    );
  }
}

class House {
  final String? id;
  final String? name;
  final Address? address;
  final String? description;
  final int? collectionCycle;
  final int? minRenters;
  final int? maxRenters;
  final int? minPrice;
  final int? maxPrice;
  final int? numOfRooms;
  final int? minRoomArea;
  final int? maxRoomArea;
  final String? thumbnail;
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

  factory House.fromJson(Map<String, dynamic> json) {
    var floors = <Floor>[];
    if (json.containsKey('floors') && json['floors'] != null) {
      var floorList = json['floors'] as List;
      floors = floorList.map((i) => Floor.fromJson(i)).toList();
    }

    return House(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json.containsKey('address') && json['address'] != null
          ? Address.fromJson(json['address'])
          : null,
      collectionCycle: json.containsKey('collectionCycle') ? json['collectionCycle'] : null,
      description: json['description'] ?? '',
      minRenters: json['minRenters'] ?? 0,
      maxRenters: json['maxRenters'] ?? 0,
      minPrice: json['minPrice'] ?? 0,
      maxPrice: json['maxPrice'] ?? 0,
      numOfRooms: json['numOfRooms'] ?? 0,
      minRoomArea: json['minRoomArea'] ?? 0,
      maxRoomArea: json['maxRoomArea'] ?? 0,
      thumbnail: json['thumbnail'] ?? '',
      floors: floors.isNotEmpty ? floors : [],
    );
  }
}
