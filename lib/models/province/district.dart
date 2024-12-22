import 'package:rent_house/models/province/ward.dart';

class District {
  String? name;
  int? code;
  String? codename;
  String? divisionType;
  String? shortCodename;
  List<Ward>? wards;

  District({
    this.name,
    this.code,
    this.codename,
    this.divisionType,
    this.shortCodename,
    this.wards,
  });

  District.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    codename = json['codename'];
    divisionType = json['division_type'];
    shortCodename = json['short_codename'];
    wards = (json['wards'] as List<dynamic>).map((ward) => Ward.fromJson(ward)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'codename': codename,
      'division_type': divisionType,
      'short_codename': shortCodename,
      'wards': wards?.map((ward) => ward.toJson()).toList(),
    };
  }
}
