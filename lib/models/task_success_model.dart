class TaskSuccessModel {
  int? id;
  int? userId;
  int? taskId;
  int? linkId;
  int? coinsEarned;
  String? status;
  String? refUrl;
  String? uniqueIdentifier;
  String? approvalStatus;
  String? channel;
  String? proof;
  String? progress;
  dynamic meta;
  dynamic balance;
  dynamic lifetimeBalance;
  String? createdAt;
  String? updatedAt;

  TaskSuccessModel({
    this.id,
    this.userId,
    this.taskId,
    this.linkId,
    this.coinsEarned,
    this.status,
    this.refUrl,
    this.uniqueIdentifier,
    this.approvalStatus,
    this.channel,
    this.meta,
    this.balance,
    this.lifetimeBalance,
    this.createdAt,
    this.updatedAt,
  });

  factory TaskSuccessModel.fromJson(Map<String, dynamic> json) {
    return TaskSuccessModel(
      id: json['id'],
      userId: json['user_id'],
      taskId: json['task_id'],
      linkId: json['link_id'],
      coinsEarned: json['coins_earned'],
      status: json['status'],
      refUrl: json['ref_url'],
      uniqueIdentifier: json['unique_identifier'],
      approvalStatus: json['approval_status'],
      channel: json['channel'],
      meta: json['meta'],
      balance: json['balance'],
      lifetimeBalance: json['lifetime_balance'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
