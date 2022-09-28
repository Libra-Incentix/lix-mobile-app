class Country {
  int? id;
  String? name;
  String? niceName;
  String? iso;
  String? iso3;
  dynamic numCode;
  String? phoneCode;

  Country({
    this.id,
    this.name,
    this.niceName,
    this.iso,
    this.iso3,
    this.numCode,
    this.phoneCode,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      niceName: json['niceName'] ?? '',
      iso: json['iso'],
      iso3: json['iso3'],
      numCode: json['numcode'] ?? '',
      phoneCode: json['phone_code'] ?? '',
    );
  }
}
