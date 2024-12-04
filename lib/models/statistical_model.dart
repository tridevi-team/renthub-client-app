class StatisticalModel {
  String? month;
  int? totalPrice;

  StatisticalModel({
     this.month,
     this.totalPrice,
  });

  StatisticalModel.fromJson(Map<String, dynamic> json) {
      month = json['month'] as String;
      totalPrice = json['totalPrice'] as int;
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'totalPrice': totalPrice,
    };
  }
}