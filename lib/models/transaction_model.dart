class TransactionModel {
  int? id;
  String? tnxId;
  int? amount;
  String? commissionCharge;
  String? currency;
  int? userId;
  int? senderId;
  int? receiverId;
  String? senderType;
  String? receiverType;
  String? type;
  String? description;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? fiatAmount;
  int? fiatCurrencyId;
  dynamic fiatConversionRate;
  dynamic sender;
  ReceiverModel? receiver;
  CreatedByUserModel? createdByUser;

  TransactionModel({
    this.id,
    this.tnxId,
    this.amount,
    this.commissionCharge,
    this.currency,
    this.userId,
    this.senderId,
    this.receiverId,
    this.senderType,
    this.receiverType,
    this.type,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.fiatAmount,
    this.fiatCurrencyId,
    this.fiatConversionRate,
    this.sender,
    this.receiver,
    this.createdByUser,
  });

  TransactionModel.fromJson(Map<String, dynamic> json) {
    ReceiverModel? receiverModel;
    if (json["receiver"] != null) {
      receiverModel = ReceiverModel.fromJson(json["receiver"]);
    }
    CreatedByUserModel? createdByUserModel;
    if (json["created_by_user"] != null) {
      createdByUserModel = CreatedByUserModel.fromJson(json["created_by_user"]);
    }

    id = json["id"];
    tnxId = json["tnx_id"];
    amount = json["amount"];
    commissionCharge = json["commission_charge"];
    currency = json["currency"];
    userId = json["user_id"];
    senderId = json["sender_id"];
    receiverId = json["receiver_id"];
    senderType = json["sender_type"];
    receiverType = json["receiver_type"];
    type = json["type"];
    description = json["description"];
    status = json["status"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    fiatAmount = json["fiat_amount"];
    fiatCurrencyId = json["fiat_currency_id"];
    fiatConversionRate = json["fiat_conversion_rate"];
    sender = json["sender"];
    receiver = receiverModel;
    createdByUser = createdByUserModel;
  }
}

class CreatedByUserModel {
  int? id;
  String? name;
  String? emailVerifiedAt;
  String? phone;
  int? cityId;
  int? stateId;
  int? countryId;
  int? industryId;
  int? categoryId;
  String? gender;
  String? dateOfBirth;
  String? createdAt;
  String? updatedAt;
  dynamic invitedBy;
  dynamic avatar;
  String? altEmail;
  String? address;
  int? emailNotify;
  int? pushNotify;
  String? status;
  dynamic adminCommissionSettings;
  int? cookieConsentStatus;
  int? isFirstOrganisationCreated;
  int? isFirstProjectCreated;
  int? isFirstTaskCreated;
  int? isFirstTeamCreated;
  int? isFirstActivityCreated;
  int? isFirstLinkCreated;
  int? themeId;
  int? isFirstFundWallet;
  int? isTermsAccepted;
  int? isPrivacyPolicyAccepted;

  CreatedByUserModel({
    this.id,
    this.name,
    this.emailVerifiedAt,
    this.phone,
    this.cityId,
    this.stateId,
    this.countryId,
    this.industryId,
    this.categoryId,
    this.gender,
    this.dateOfBirth,
    this.createdAt,
    this.updatedAt,
    this.invitedBy,
    this.avatar,
    this.altEmail,
    this.address,
    this.emailNotify,
    this.pushNotify,
    this.status,
    this.adminCommissionSettings,
    this.cookieConsentStatus,
    this.isFirstOrganisationCreated,
    this.isFirstProjectCreated,
    this.isFirstTaskCreated,
    this.isFirstTeamCreated,
    this.isFirstActivityCreated,
    this.isFirstLinkCreated,
    this.themeId,
    this.isFirstFundWallet,
    this.isTermsAccepted,
    this.isPrivacyPolicyAccepted,
  });

  CreatedByUserModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    emailVerifiedAt = json["email_verified_at"];
    phone = json["phone"];
    cityId = json["city_id"];
    stateId = json["state_id"];
    countryId = json["country_id"];
    industryId = json["industry_id"];
    categoryId = json["category_id"];
    gender = json["gender"];
    dateOfBirth = json["date_of_birth"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    invitedBy = json["invited_by"];
    avatar = json["avatar"];
    altEmail = json["altemail"];
    address = json["address"];
    emailNotify = json["email_notify"];
    pushNotify = json["push_notify"];
    status = json["status"];
    adminCommissionSettings = json["admin_commission_settings"];
    cookieConsentStatus = json["cookie_consent_status"];
    isFirstOrganisationCreated = json["is_first_organisation_created"];
    isFirstProjectCreated = json["is_first_project_created"];
    isFirstTaskCreated = json["is_first_task_created"];
    isFirstTeamCreated = json["is_first_team_created"];
    isFirstActivityCreated = json["is_first_activity_created"];
    isFirstLinkCreated = json["is_first_link_created"];
    themeId = json["theme_id"];
    isFirstFundWallet = json["is_first_fund_wallet"];
    isTermsAccepted = json["is_terms_accepted"];
    isPrivacyPolicyAccepted = json["is_privacy_policy_accepted"];
  }
}

class ReceiverModel {
  int? id;
  String? name;
  String? emailVerifiedAt;
  String? phone;
  int? cityId;
  int? stateId;
  int? countryId;
  int? industryId;
  int? categoryId;
  String? gender;
  String? dateOfBirth;
  String? createdAt;
  String? updatedAt;
  dynamic invitedBy;
  dynamic avatar;
  String? altEmail;
  String? address;
  int? emailNotify;
  int? pushNotify;
  String? status;
  dynamic adminCommissionSettings;
  int? cookieConsentStatus;
  int? isFirstOrganisationCreated;
  int? isFirstProjectCreated;
  int? isFirstTaskCreated;
  int? isFirstTeamCreated;
  int? isFirstActivityCreated;
  int? isFirstLinkCreated;
  int? themeId;
  int? isFirstFundWallet;
  int? isTermsAccepted;
  int? isPrivacyPolicyAccepted;

  ReceiverModel({
    this.id,
    this.name,
    this.emailVerifiedAt,
    this.phone,
    this.cityId,
    this.stateId,
    this.countryId,
    this.industryId,
    this.categoryId,
    this.gender,
    this.dateOfBirth,
    this.createdAt,
    this.updatedAt,
    this.invitedBy,
    this.avatar,
    this.altEmail,
    this.address,
    this.emailNotify,
    this.pushNotify,
    this.status,
    this.adminCommissionSettings,
    this.cookieConsentStatus,
    this.isFirstOrganisationCreated,
    this.isFirstProjectCreated,
    this.isFirstTaskCreated,
    this.isFirstTeamCreated,
    this.isFirstActivityCreated,
    this.isFirstLinkCreated,
    this.themeId,
    this.isFirstFundWallet,
    this.isTermsAccepted,
    this.isPrivacyPolicyAccepted,
  });

  ReceiverModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    emailVerifiedAt = json["email_verified_at"];
    phone = json["phone"];
    cityId = json["city_id"];
    stateId = json["state_id"];
    countryId = json["country_id"];
    industryId = json["industry_id"];
    categoryId = json["category_id"];
    gender = json["gender"];
    dateOfBirth = json["date_of_birth"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    invitedBy = json["invited_by"];
    avatar = json["avatar"];
    altEmail = json["altemail"];
    address = json["address"];
    emailNotify = json["email_notify"];
    pushNotify = json["push_notify"];
    status = json["status"];
    adminCommissionSettings = json["admin_commission_settings"];
    cookieConsentStatus = json["cookie_consent_status"];
    isFirstOrganisationCreated = json["is_first_organisation_created"];
    isFirstProjectCreated = json["is_first_project_created"];
    isFirstTaskCreated = json["is_first_task_created"];
    isFirstTeamCreated = json["is_first_team_created"];
    isFirstActivityCreated = json["is_first_activity_created"];
    isFirstLinkCreated = json["is_first_link_created"];
    themeId = json["theme_id"];
    isFirstFundWallet = json["is_first_fund_wallet"];
    isTermsAccepted = json["is_terms_accepted"];
    isPrivacyPolicyAccepted = json["is_privacy_policy_accepted"];
  }
}
