class Country {
  int? id;
  String? name;
  String? flag;
  String? phoneCode;

  Country({
    this.id,
    this.name,
    this.flag,
    this.phoneCode,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      flag: json['flag'] ?? '',
      phoneCode: json['phone_code'] ?? '',
    );
  }
}
