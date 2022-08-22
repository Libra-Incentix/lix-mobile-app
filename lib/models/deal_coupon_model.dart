class DealCouponModel {
  //simple Model class
  String title;
  bool checked;
  bool hasOffer;
  String couponAmount;
  String reducedAmount;

  DealCouponModel({
    required this.title,
    required this.checked,
    required this.hasOffer,
    required this.couponAmount,
    required this.reducedAmount,
  });
}
