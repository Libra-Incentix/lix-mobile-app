class NotificationModel {
  int? id;
  int? userId;
  String? action;
  String? title;
  String? url;
  String? description;
  int? readStatus;
  int? status;
  String? createdAt;
  String? updatedAt;
  bool? read;

  NotificationModel({
    this.id,
    this.userId,
    this.action,
    this.title,
    this.url,
    this.description,
    this.readStatus,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.read,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    bool rStatus = false;
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["user_id"] is int) {
      userId = json["user_id"];
    }
    if (json["action"] is String) {
      action = json["action"];
    }
    if (json["content"] is String) {
      title = json["content"];
    }
    if (json["url"] is String) {
      url = json["url"];
    }
    if (json["description"] is String) {
      description = json["description"];
    }
    if (json["read_status"] is int) {
      readStatus = json["read_status"];
      rStatus = json['read_status'] == 1;
    }
    if (json["status"] is int) {
      status = json["status"];
    }
    if (json["created_at"] is String) {
      createdAt = json["created_at"];
    }
    if (json["updated_at"] is String) {
      updatedAt = json["updated_at"];
    }
    read = rStatus;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data["id"] = id;
    data["user_id"] = userId;
    data["action"] = action;
    data["content"] = title;
    data["url"] = url;
    data["description"] = description;
    data["read_status"] = readStatus;
    data["status"] = status;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    return data;
  }
}
