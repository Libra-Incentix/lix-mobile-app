class BuyOfferSuccess {
  String? coupon;
  String? currentUser;
  String? benefit;
  String? organisationName;
  String? currency;
  int? amount;
  int? marketId;

  BuyOfferSuccess({
    this.coupon,
    this.currentUser,
    this.benefit,
    this.organisationName,
    this.currency,
    this.amount,
    this.marketId,
  });

  factory BuyOfferSuccess.fromJson(Map<String, dynamic> json) {
    return BuyOfferSuccess(
      coupon: json['coupon'],
      currentUser: json['current_user'],
      benefit: json['benefit'],
      organisationName: json['organisation_name'],
      currency: json['currency'],
      amount: json['amount'],
      marketId: json['market_id'],
    );
  }
}
