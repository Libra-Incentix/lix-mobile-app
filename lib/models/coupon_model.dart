class CouponModel {
  int? id;
  String? coupon;
  String? description;
  String? couponQRCode;
  String? couponBarcode;
  int? isUsed;
  int? isActive;
  String? status;
  String? usedDate;
  Map<String, dynamic>? user;
  Map<String, dynamic>? market;
  String? cancelledAt;
  String? createdAt;
  String? updatedAt;

  CouponModel({
    this.id,
    this.user,
    this.market,
    this.coupon,
    this.description,
    this.couponQRCode,
    this.couponBarcode,
    this.isUsed,
    this.isActive,
    this.status,
    this.usedDate,
    this.cancelledAt,
    this.createdAt,
    this.updatedAt,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['id'],
      user: json['redeemer_user_details'],
      market: json['market'],
      coupon: json['coupon'],
      description: json['description'],
      couponQRCode: json['coupon_qrcode'],
      couponBarcode: json['coupon_barcode'],
      isActive: json['is_active'],
      isUsed: json['is_used'],
      status: json['status'],
      usedDate: json['used_date'],
      cancelledAt: json['cancelled_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
