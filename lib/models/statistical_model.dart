class StatisticalModel {
  List<Turnover>? turnover;
  ServiceCompare? serviceCompare;
  List<ServiceConsumption>? serviceConsumption;

  StatisticalModel({
    this.turnover,
    this.serviceCompare,
    this.serviceConsumption,
  });

  StatisticalModel.fromJson(Map<String, dynamic> json) {
    var turnoverList = (json['turnover'] as List).map((item) => Turnover.fromJson(item)).toList();

    var serviceCompare = ServiceCompare.fromJson(json['serviceCompare']);

    var serviceConsumptionList = (json['serviceConsumption'] as List).map((item) => ServiceConsumption.fromJson(item)).toList();

    turnover = turnoverList;
    this.serviceCompare = serviceCompare;
    serviceConsumption = serviceConsumptionList;
  }
}

class Turnover {
  String? month;
  int? totalPrice;

  Turnover({
    this.month,
    this.totalPrice,
  });

  Turnover.fromJson(Map<String, dynamic> json) {
    month = json['month'];
    totalPrice = json['totalPrice'];
  }
}

class ServiceCompare {
  List<ServiceCompareData>? data;
  ServiceConfig? config;

  ServiceCompare({
    this.data,
    this.config,
  });

  ServiceCompare.fromJson(Map<String, dynamic> json) {
    var dataList = (json['data'] as List).map((item) => ServiceCompareData.fromJson(item)).toList();

    var config = ServiceConfig.fromJson(json['config']);

    data = dataList;
    this.config = config;
  }
}

class ServiceCompareData {
  String? month;
  Map<String, int>? services;

  ServiceCompareData({
    this.month,
    this.services,
  });

  ServiceCompareData.fromJson(Map<String, dynamic> json) {
    var services = <String, int>{};
    month = json['month'];

    json.forEach((key, value) {
      if (key != 'month') {
        services[key] = (value is int) ? value : int.tryParse(value.toString()) ?? 0;
      }
    });

    this.services = services;
  }
}

class ServiceConfig {
  Map<String, ServiceConfigItem>? configItems;

  ServiceConfig({
    this.configItems,
  });

  ServiceConfig.fromJson(Map<String, dynamic> json) {
    var configItems = <String, ServiceConfigItem>{};

    json.forEach((key, value) {
      configItems[key] = ServiceConfigItem.fromJson(value);
    });

    this.configItems = configItems;
  }
}

class ServiceConfigItem {
  String? label;
  String? color;

  ServiceConfigItem({
    this.label,
    this.color,
  });

  ServiceConfigItem.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    color = json['color'];
  }
}

class ServiceConsumption {
  String? name;
  int? totalPrice;

  ServiceConsumption({
    this.name,
    this.totalPrice,
  });

  ServiceConsumption.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    totalPrice = json['totalPrice'];
  }
}
