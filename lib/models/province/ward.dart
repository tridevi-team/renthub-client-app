class Ward {
  String? name;
  int? code;
  String? codename;
  String? divisionType;
  String? shortCodename;

  Ward({
    this.name,
    this.code,
    this.codename,
    this.divisionType,
    this.shortCodename,
  });

  Ward.fromJson(Map<String, dynamic> json) {
      name = json['name'];
      code = json['code'];
      codename = json['codename'];
      divisionType = json['division_type'];
      shortCodename = json['short_codename'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'codename': codename,
      'division_type': divisionType,
      'short_codename': shortCodename,
    };
  }
}


