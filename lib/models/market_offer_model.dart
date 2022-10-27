class MarketOffer {
  int? id;
  int? marketId;
  Organisation? organisation;
  int? userId;
  int? amount;
  String? paymentMethod;
  int? tradeLimit;
  int? fee;
  dynamic benefit;
  String? couponPrefix;
  String? couponCode;
  String? couponGenerationType;
  String? instructions;
  String? supportedCountries;
  String? redirectLink;
  String? offerImage;
  String? status;
  String? approvalStatus;
  String? createdAt;
  String? updatedAt;

  MarketOffer(
      {this.id,
      this.marketId,
      this.organisation,
      this.userId,
      this.amount,
      this.paymentMethod,
      this.tradeLimit,
      this.fee,
      this.benefit,
      this.couponPrefix,
      this.couponCode,
      this.couponGenerationType,
      this.instructions,
      this.redirectLink,
      this.offerImage,
      this.status,
      this.approvalStatus,
      this.createdAt,
      this.updatedAt,
      this.supportedCountries});

  MarketOffer.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      marketId = json['market_id'];
      userId = json['user_id'];
      amount = json['amount'];
      paymentMethod = json['payment_method'];
      tradeLimit = json['trade_limit'];
      fee = json['fee'];
      benefit = json['benefit'];
      couponPrefix = json['coupon_prefix'];
      couponCode = json['coupon_code'];
      couponGenerationType = json['coupon_generation_type'];
      supportedCountries = json['supported_countries'];
      instructions = json['instructions'];
      redirectLink = json['redirect_link'];
      offerImage = json['offer_image'];
      status = json['status'];
      approvalStatus = json['approval_status'];
      createdAt = json['created_at'];
      updatedAt = json['updated_at'];
      organisation = json['created_by_organisation'] != null
          ? Organisation.fromJson(json['created_by_organisation'])
          : null;
    } on Exception catch (_, e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['market_id'] = marketId;
    if (organisation != null) {
      data['organisation'] = organisation!.toJson();
    }
    data['user_id'] = userId;
    data['amount'] = amount;
    data['payment_method'] = paymentMethod;
    data['trade_limit'] = tradeLimit;
    data['fee'] = fee;
    data['benefit'] = benefit;
    data['coupon_prefix'] = couponPrefix;
    data['coupon_code'] = couponCode;
    data['coupon_generation_type'] = couponGenerationType;
    data['instructions'] = instructions;
    data['redirect_link'] = redirectLink;
    data['offer_image'] = offerImage;
    data['status'] = status;
    data['approval_status'] = approvalStatus;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Organisation {
  int? id;
  String? name;
  dynamic industryType;
  int? industryId;
  int? categoryId;
  int? parentId;
  String? email;
  int? totalCoinsFunded;
  dynamic unifiedPaymentIdentifier;
  int? userId;
  String? url;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? totalCoinsUsed;
  int? totalCoinsUsedEver;
  int? totalCoinsFundedEver;
  int? remoteId;
  String? color;
  String? avatar;
  String? importedFrom;
  String? tokenName;
  String? tokenRate;
  String? defaultCurrency;
  String? address;
  int? countryId;
  int? stateId;
  int? cityId;
  int? latitude;
  int? longitude;
  String? defaultCurrencyName;
  String? defaultCurrencySymbol;
  String? phone;
  String? accountNo;
  String? privateWalletAddress;
  String? publicWalletAddress;
  int? themeId;
  String? stripeAccountId;

  Organisation({
    this.id,
    this.name,
    this.industryType,
    this.industryId,
    this.categoryId,
    this.parentId,
    this.email,
    this.totalCoinsFunded,
    this.unifiedPaymentIdentifier,
    this.userId,
    this.url,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.totalCoinsUsed,
    this.totalCoinsUsedEver,
    this.totalCoinsFundedEver,
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
    this.privateWalletAddress,
    this.publicWalletAddress,
    this.themeId,
    this.stripeAccountId,
  });

  Organisation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    industryType = json['industry_type'];
    industryId = json['industry_id'];
    categoryId = json['category_id'];
    parentId = json['parent_id'];
    email = json['email'];
    totalCoinsFunded = json['total_coins_funded'];
    unifiedPaymentIdentifier = json['unified_payment_identifier'];
    userId = json['user_id'];
    url = json['url'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    totalCoinsUsed = json['total_coins_used'];
    totalCoinsUsedEver = json['total_coins_used_ever'];
    totalCoinsFundedEver = json['total_coins_funded_ever'];
    remoteId = json['remote_id'];
    color = json['color'];
    avatar = json['avatar'];
    importedFrom = json['imported_from'];
    tokenName = json['token_name'];
    tokenRate = json['token_rate'];
    defaultCurrency = json['default_currency'];
    address = json['address'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    defaultCurrencyName = json['default_currency_name'];
    defaultCurrencySymbol = json['default_currency_symbol'];
    phone = json['phone'];
    accountNo = json['account_no'];
    privateWalletAddress = json['private_wallet_address'];
    publicWalletAddress = json['public_wallet_address'];
    themeId = json['theme_id'];
    stripeAccountId = json['stripe_account_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['industry_type'] = industryType;
    data['industry_id'] = industryId;
    data['category_id'] = categoryId;
    data['parent_id'] = parentId;
    data['email'] = email;
    data['total_coins_funded'] = totalCoinsFunded;
    data['unified_payment_identifier'] = unifiedPaymentIdentifier;
    data['user_id'] = userId;
    data['url'] = url;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['total_coins_used'] = totalCoinsUsed;
    data['total_coins_used_ever'] = totalCoinsUsedEver;
    data['total_coins_funded_ever'] = totalCoinsFundedEver;
    data['remote_id'] = remoteId;
    data['color'] = color;
    data['avatar'] = avatar;
    data['imported_from'] = importedFrom;
    data['token_name'] = tokenName;
    data['token_rate'] = tokenRate;
    data['default_currency'] = defaultCurrency;
    data['address'] = address;
    data['country_id'] = countryId;
    data['state_id'] = stateId;
    data['city_id'] = cityId;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['default_currency_name'] = defaultCurrencyName;
    data['default_currency_symbol'] = defaultCurrencySymbol;
    data['phone'] = phone;
    data['account_no'] = accountNo;
    data['private_wallet_address'] = privateWalletAddress;
    data['public_wallet_address'] = publicWalletAddress;
    data['theme_id'] = themeId;
    data['stripe_account_id'] = stripeAccountId;
    return data;
  }
}
