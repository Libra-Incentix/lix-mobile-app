import 'package:lix/models/task_model.dart';

class TaskLinkModel {
  int? id;
  int? views;
  int? signups;
  String? fullLink;
  String? redirectLink;
  String? passPhrase;
  dynamic extraFields;
  String? status;
  dynamic maximumSignups;
  dynamic allowedDomains;
  int? linkableId;
  String? linkableType;
  String? thankYouMessage;
  String? updatedAt;
  String? createdAt;
  int? userId;
  TaskModel? task;

  TaskLinkModel({
    this.id,
    this.views,
    this.signups,
    this.fullLink,
    this.redirectLink,
    this.passPhrase,
    this.extraFields,
    this.status,
    this.maximumSignups,
    this.allowedDomains,
    this.linkableId,
    this.linkableType,
    this.thankYouMessage,
    this.updatedAt,
    this.createdAt,
    this.userId,
    this.task,
  });

  factory TaskLinkModel.fromJson(Map<String, dynamic> json) {
    TaskModel? taskModel;
    if (json['task'] != null) {
      taskModel = TaskModel.fromJson(json['task']);
    }
    return TaskLinkModel(
      id: json['id'],
      views: json['views'],
      signups: json['signups'],
      redirectLink: json['redirect_link'],
      passPhrase: json['task_for_robin'],
      extraFields: json['extra_fields'],
      status: json['status'],
      maximumSignups: json['maximum_signups'],
      allowedDomains: json['allowed_domains'],
      linkableId: json['linkable_id'],
      linkableType: json['linkable_type'],
      thankYouMessage: json['thank_you_message'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      userId: json['user_id'],
      task: taskModel,
    );
  }
}
