class WalletDetails {
  int? id;
  int? customCurrencyId;
  int? organisationId;
  int? userId;
  String? balance;
  String? accountNumber;
  int? receiveOnlyBalance;
  int? revenueOnlyBalance;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? cashOutRate;

  WalletDetails({
    this.id,
    this.customCurrencyId,
    this.organisationId,
    this.userId,
    this.balance,
    this.accountNumber,
    this.receiveOnlyBalance,
    this.revenueOnlyBalance,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.cashOutRate,
  });

  factory WalletDetails.fromJson(Map<String, dynamic> json) {
    return WalletDetails(
      id: json['id'] ?? 0,
      customCurrencyId: json['custom_currency_id'],
      organisationId: json['organisation_id'],
      userId: json['user_id'],
      balance: json['balance'] ?? '0',
      accountNumber: json['account_number'] ?? '',
      receiveOnlyBalance: json['receive_only_balance'] ?? 0,
      revenueOnlyBalance: json['revenue_only_balance'] ?? 0,
      status: json['status'] ?? 'active',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      cashOutRate: json['cash_out_rate'] ?? 0,
    );
  }
}
