class Room {
  String? id;
  String? name;
  int? price;
  int? area;
  int? maxRenters;
  String? status;
  String? description;
  List<String>? images;
  List<Service>? services;

  Room({
   this.id,
   this.name,
   this.price,
   this.area,
   this.maxRenters,
   this.status,
   this.images,
   this.description,
   this.services,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    var imageList = List<String>.from(json['images']);
    var serviceList = json['services'] as List;
    List<Service> services = serviceList.map((i) => Service.fromJson(i)).toList();
    return Room(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      area: json['area'] ?? 0,
      maxRenters: json['maxRenters'] ?? 1,
      status: json['status'] ?? '',
      description: json['description'] ?? '',
      images: imageList,
      services: services,
    );
  }
}

class Service {
  String id;
  String? name;
  int? price;
  String? description;

  Service({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      description: json['description'],
    );
  }
}