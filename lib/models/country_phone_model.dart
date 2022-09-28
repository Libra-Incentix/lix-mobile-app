class CountryPhone {
  int? id;
  String? name;
  String? dialCode;
  int? dialMinLength;
  int? dialMaxLength;
  String? code;
  String? currencyName;
  String? currencyCode;
  String? currencySymbol;
  String? flag;
  bool? active;

  CountryPhone({
    this.id,
    this.name,
    this.dialCode,
    this.dialMinLength,
    this.dialMaxLength,
    this.code,
    this.currencyName,
    this.currencyCode,
    this.currencySymbol,
    this.flag,
    this.active,
  });

  CountryPhone.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["dial_code"] is String) {
      dialCode = json["dial_code"];
    }
    if (json["dial_min_length"] is int) {
      dialMinLength = json["dial_min_length"];
    }
    if (json["dial_max_length"] is int) {
      dialMaxLength = json["dial_max_length"];
    }
    if (json["code"] is String) {
      code = json["code"];
    }
    if (json["currency_name"] is String) {
      currencyName = json["currency_name"];
    }
    if (json["currency_code"] is String) {
      currencyCode = json["currency_code"];
    }
    if (json["currency_symbol"] is String) {
      currencySymbol = json["currency_symbol"];
    }
    if (json["flag"] is String) {
      flag = json["flag"];
    }
    if (json["active"] is bool) {
      active = json["active"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data["id"] = id;
    data["name"] = name;
    data["dial_code"] = dialCode;
    data["dial_min_length"] = dialMinLength;
    data["dial_max_length"] = dialMaxLength;
    data["code"] = code;
    data["currency_name"] = currencyName;
    data["currency_code"] = currencyCode;
    data["currency_symbol"] = currencySymbol;
    data["flag"] = flag;
    data["active"] = active;
    return data;
  }
}
