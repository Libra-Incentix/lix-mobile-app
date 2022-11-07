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
    int iA = 0;
    int iU = 0;

    if (json['is_active'] != null) {
      if (json['is_active'].runtimeType == bool) {
        iA = json['is_active'] ? 1 : 0;
      } else if (json['is_active'].runtimeType == int) {
        iA = json['is_active'];
      }
    }

    if (json['is_used'] != null) {
      if (json['is_used'].runtimeType == bool) {
        iU = json['is_used'] ? 1 : 0;
      } else if (json['is_used'].runtimeType == int) {
        iU = json['is_used'];
      }
    }
    return CouponModel(
      id: json['id'],
      user: json['redeemer_user_details'],
      market: json['market'],
      coupon: json['coupon'],
      description: json['description'],
      couponQRCode: json['coupon_qrcode'],
      couponBarcode: json['coupon_barcode'],
      isActive: iA,
      isUsed: iU,
      status: json['status'],
      usedDate: json['used_date'],
      cancelledAt: json['cancelled_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
