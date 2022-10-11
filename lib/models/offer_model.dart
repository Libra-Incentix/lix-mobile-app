import 'package:lix/models/user.dart';

class OfferModel {
  int? id;
  String? fullLink;
  String? paymentMethod;
  CreatedByOrganisation? createdByOrganisation;
  User? user;
  dynamic tradeLimit;
  dynamic rate;
  int? currencyId;
  int? fee;
  String? benefit;
  String? couponPrefix;
  dynamic couponCode;
  String? couponGenerationType;
  String? instructions;
  dynamic redirectLink;
  dynamic phoneNumber;
  String? offerImage;
  bool? autoApprove;
  String? supportedCountries;
  dynamic supportedStates;
  dynamic supportedCities;
  String? status;
  String? approvalStatus;
  dynamic expiresAt;
  String? createdAt;
  String? updatedAt;

  OfferModel({
    this.id,
    this.paymentMethod,
    this.createdByOrganisation,
    this.user,
    this.tradeLimit,
    this.rate,
    this.currencyId,
    this.fee,
    this.benefit,
    this.couponPrefix,
    this.couponCode,
    this.couponGenerationType,
    this.instructions,
    this.redirectLink,
    this.phoneNumber,
    this.offerImage,
    this.autoApprove,
    this.supportedCountries,
    this.supportedStates,
    this.supportedCities,
    this.status,
    this.approvalStatus,
    this.expiresAt,
    this.createdAt,
    this.updatedAt,
  });

  OfferModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    paymentMethod = json["payment_method"];
    createdByOrganisation = json["created_by_organisation"] == null
        ? null
        : CreatedByOrganisation.fromJson(json["created_by_organisation"]);
    user = json["user"] == null ? null : User.fromJson(json["user"]);
    tradeLimit = json["trade_limit"];
    rate = json["rate"];
    currencyId = json["currency_id"];
    fee = json["fee"];
    benefit = json["benefit"];
    couponPrefix = json["coupon_prefix"];
    couponCode = json["coupon_code"];
    couponGenerationType = json["coupon_generation_type"];
    instructions = json["instructions"];
    redirectLink = json["redirect_link"];
    phoneNumber = json["phone_number"];
    offerImage = json["offer_image"];
    autoApprove = json["auto_approve"];
    supportedCountries = json["supported_countries"];
    supportedStates = json["supported_states"];
    supportedCities = json["supported_cities"];
    status = json["status"];
    approvalStatus = json["approval_status"];
    expiresAt = json["expires_at"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }
}

class CreatedByOrganisation {
  int? id;
  String? name;
  dynamic industryType;
  int? industryId;
  int? categoryId;
  dynamic parentId;
  dynamic email;
  dynamic unifiedPaymentIdentifier;
  int? userId;
  dynamic url;
  String? status;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  dynamic remoteId;
  dynamic color;
  String? avatar;
  dynamic importedFrom;
  dynamic tokenName;
  dynamic tokenRate;
  dynamic defaultCurrency;
  dynamic address;
  dynamic countryId;
  dynamic stateId;
  dynamic cityId;
  dynamic latitude;
  dynamic longitude;
  dynamic defaultCurrencyName;
  dynamic defaultCurrencySymbol;
  dynamic phone;
  dynamic accountNo;
  dynamic themeId;

  CreatedByOrganisation({
    this.id,
    this.name,
    this.industryType,
    this.industryId,
    this.categoryId,
    this.parentId,
    this.email,
    this.unifiedPaymentIdentifier,
    this.userId,
    this.url,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.remoteId,
    this.color,
    this.avatar,
    this.importedFrom,
    this.tokenName,
    this.tokenRate,
    this.defaultCurrency,
    this.address,
    this.countryId,
    this.stateId,
    this.cityId,
    this.latitude,
    this.longitude,
    this.defaultCurrencyName,
    this.defaultCurrencySymbol,
    this.phone,
    this.accountNo,
    this.themeId,
  });

  CreatedByOrganisation.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    industryType = json["industry_type"];
    industryId = json["industry_id"];
    categoryId = json["category_id"];
    parentId = json["parent_id"];
    email = json["email"];
    unifiedPaymentIdentifier = json["unified_payment_identifier"];
    userId = json["user_id"];
    url = json["url"];
    status = json["status"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    deletedAt = json["deleted_at"];
    remoteId = json["remote_id"];
    color = json["color"];
    avatar = json["avatar"];
    importedFrom = json["imported_from"];
    tokenName = json["token_name"];
    tokenRate = json["token_rate"];
    defaultCurrency = json["default_currency"];
    address = json["address"];
    countryId = json["country_id"];
    stateId = json["state_id"];
    cityId = json["city_id"];
    latitude = json["latitude"];
    longitude = json["longitude"];
    defaultCurrencyName = json["default_currency_name"];
    defaultCurrencySymbol = json["default_currency_symbol"];
    phone = json["phone"];
    accountNo = json["account_no"];
    themeId = json["theme_id"];
  }
}
