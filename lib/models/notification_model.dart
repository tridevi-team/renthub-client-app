class NotificationModel {
  int? total;
  int? page;
  int? pageCount;
  int? pageSize;
  List<NotificationItem>? results;

  NotificationModel({
    this.total,
    this.page,
    this.pageCount,
    this.pageSize,
    this.results,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    page = json['page'];
    pageCount = json['pageCount'];
    pageSize = json['pageSize'];
    if (json['results'] != null) {
      results = (json['results'] as List)
          .map((item) => NotificationItem.fromJson(item))
          .toList();
    } else {
      results = [];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'page': page,
      'pageCount': pageCount,
      'pageSize': pageSize,
      'results': results?.map((item) => item.toJson()).toList(),
    };
  }
}

class NotificationItem {
  String? id;
  String? title;
  String? content;
  String? imageUrl;
  String? type;
  Map<String, dynamic>? data;
  String? createdBy;
  DateTime? createdAt;

  NotificationItem({
    this.id,
    this.title,
    this.content,
    this.imageUrl,
    this.type,
    this.data,
    this.createdBy,
    this.createdAt,
  });

  NotificationItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    imageUrl = json['imageUrl'];
    type = json['type'];
    data = json['data'] ?? {};
    createdBy = json['createdBy'];
    createdAt = json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'type': type,
      'data': data,
      'createdBy': createdBy,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
