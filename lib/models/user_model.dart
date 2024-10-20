class UserModel {
  String? id;
  String? roomId;
  String? name;
  String? citizenId;
  DateTime? birthday;
  String? gender;
  String? email;
  String? phoneNumber;
  String? address;
  int? tempReg;
  DateTime? moveInDate;
  int? represent;
  String? note;
  String? createdBy;
  DateTime? createdAt;
  String? updatedBy;
  DateTime? updatedAt;
  String? accessToken;
  String? refreshToken;

  UserModel({
    this.id,
    this.roomId,
    this.name,
    this.citizenId,
    this.birthday,
    this.gender,
    this.email,
    this.phoneNumber,
    this.address,
    this.tempReg,
    this.moveInDate,
    this.represent,
    this.note,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.accessToken,
    this.refreshToken,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
      id = json['id'];
      roomId = json['roomId'];
      name = json['name'];
      citizenId = json['citizenId'];
      birthday = json['birthday'] != null ? DateTime.parse(json['birthday']) : null;
      gender = json['gender'];
      email = json['email'];
      phoneNumber = json['phoneNumber'];
      address = json['address'];
      tempReg = json['tempReg'];
      moveInDate = json['moveInDate'] != null ? DateTime.parse(json['moveInDate']) : null;
      represent = json['represent'];
      note = json['note'];
      createdBy = json['createdBy'];
      createdAt = json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
      updatedBy = json['updatedBy'];
      updatedAt = json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null;
      accessToken = json['accessToken'];
      refreshToken = json['refreshToken'];
  }
}
