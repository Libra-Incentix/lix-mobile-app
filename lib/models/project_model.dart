class ProjectModel {
  int? id;
  String? name;
  String? url;
  dynamic walletSource;
  dynamic totalCoinsFunded;
  String? status;
  int? userId;
  int? organisationId;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? totalCoinsUsed;
  String? privacy;
  dynamic valueEarned;
  dynamic valueLimit;

  ProjectModel({
    this.id,
    this.name,
    this.url,
    this.walletSource,
    this.totalCoinsFunded,
    this.status,
    this.userId,
    this.organisationId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.totalCoinsUsed,
    this.privacy,
    this.valueEarned,
    this.valueLimit,
  });

  ProjectModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    url = json['url'];
    walletSource = json['wallet_source'];
    totalCoinsFunded = json['total_coins_funded'];
    status = json['status'];
    userId = json['user_id'];
    organisationId = json['organisation_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    totalCoinsUsed = json['total_coins_used'];
    privacy = json['privacy'];
    valueEarned = json['value_earned'];
    valueLimit = json['value_limit'];
  }
}
