class LinkModel {
  int? id;
  int? views;
  int? signups;
  String? redirectLink;
  String? passPhrase;
  dynamic extraFields;
  String? status;
  int? maximumSignups;
  dynamic allowedDomains;
  int? linkableId;
  String? linkableType;
  String? thankYouMessage;
  int? userId;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  String? uuid;
  String? linkVisibility;
  int? isDefaultLink;

  LinkModel({
    this.id,
    this.views,
    this.signups,
    this.redirectLink,
    this.passPhrase,
    this.extraFields,
    this.status,
    this.maximumSignups,
    this.allowedDomains,
    this.linkableId,
    this.linkableType,
    this.thankYouMessage,
    this.userId,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.uuid,
    this.linkVisibility,
    this.isDefaultLink,
  });

  LinkModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    views = json['views'];
    signups = json['signups'];
    redirectLink = json['redirect_link'];
    passPhrase = json['pass_phrase'];
    extraFields = json['extra_fields'];
    status = json['status'];
    maximumSignups = json['maximum_signups'];
    allowedDomains = json['allowed_domains'];
    linkableId = json['linkable_id'];
    linkableType = json['linkable_type'];
    thankYouMessage = json['thank_you_message'];
    userId = json['user_id'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    uuid = json['uuid'];
    linkVisibility = json['link_visibility'];
    isDefaultLink = json['is_default_link'];
  }
}
