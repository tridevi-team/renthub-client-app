import 'dart:convert';

class IssueModel {
  String? id;
  String? houseId;
  String? floorId;
  String? roomId;
  String? equipmentId;
  String? title;
  String? content;
  String? status;
  String? description;
  Files? files;
  String? assignTo;
  String? createdBy;
  DateTime? createdAt;
  String? updatedBy;
  DateTime? updatedAt;
  String? houseName;
  String? floorName;
  String? roomName;
  String? equipmentName;
  String? createdName;
  String? assigneeName;

  IssueModel({
    this.id,
    this.houseId,
    this.floorId,
    this.roomId,
    this.equipmentId,
    this.title,
    this.content,
    this.status,
    this.description,
    this.files,
    this.assignTo,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.houseName,
    this.floorName,
    this.roomName,
    this.equipmentName,
    this.createdName,
    this.assigneeName,
  });

  IssueModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    houseId = json['houseId'];
    floorId = json['floorId'];
    roomId = json['roomId'];
    equipmentId = json['equipmentId'];
    title = json['title'];
    content = json['content'];
    status = json['status'];
    description = json['description'] ?? '';
    files = json['files'] != null
        ? json['files'] is String
            ? Files.fromJson(jsonDecode(json['files']))
            : Files.fromJson(json['files'])
        : null;
    assignTo = json['assignTo'];
    createdBy = json['createdBy'];
    createdAt = json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null;
    updatedBy = json['updatedBy'];
    updatedAt = json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null;
    houseName = json['houseName'];
    floorName = json['floorName'];
    roomName = json['roomName'];
    equipmentName = json['equipmentName'];
    createdName = json['createdName'];
    assigneeName = json['assigneeName'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'houseId': houseId,
      'floorId': floorId,
      'roomId': roomId,
      'equipmentId': equipmentId,
      'title': title,
      'content': content,
      'status': status,
      'description': description,
      'files': files?.toJson(),
      'assignTo': assignTo,
      'createdBy': createdBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedBy': updatedBy,
      'updatedAt': updatedAt?.toIso8601String(),
      'houseName': houseName,
      'floorName': floorName,
      'roomName': roomName,
      'equipmentName': equipmentName,
      'createdName': createdName,
      'assigneeName': assigneeName,
    };
  }
}

class Files {
  List<String>? image;
  List<String>? video;

  Files({
    this.image,
    this.video,
  });

  Files.fromJson(Map<String, dynamic> json) {
    image = (json['image'] as List?)?.map((e) => e as String).toList();
    video = (json['video'] as List?)?.map((e) => e as String).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'video': video,
    };
  }
}
