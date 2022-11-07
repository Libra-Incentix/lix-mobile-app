import 'package:lix/models/coupon_model.dart';

class BuyOfferSuccess {
  CouponModel? coupon;
  int? amount;
  String? currency;
  String? benefit;
  String? organisationName;

  BuyOfferSuccess({
    this.coupon,
    this.amount,
    this.currency,
    this.benefit,
    this.organisationName,
  });

  factory BuyOfferSuccess.fromJson(Map<String, dynamic> json) {
    CouponModel? cM;

    if (json['coupon'] != null) {
      cM = CouponModel.fromJson(json['coupon']);
    }

    return BuyOfferSuccess(
      coupon: cM,
      amount: json['amount'],
      currency: json['currency'],
      benefit: json['benefit'],
      organisationName: json['organisation_name'],
    );
  }
}
