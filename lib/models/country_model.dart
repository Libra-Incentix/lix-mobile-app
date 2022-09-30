class Country {
  int? id;
  String? name;
  String? dail_code;
  int? dial_min_length;
  int? dial_max_length;
  String? flag;
  //String? code;
  //String? currency_name;
  //String? currency_code;
  //String? currency_symbol;

  Country({
    this.id,
    this.name,
    this.flag,
    this.dail_code,
    this.dial_min_length,
    this.dial_max_length,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      flag: json['flag'] ?? '',
      dail_code: json['dail_code'] ?? '',
      dial_min_length: json['dial_min_length'] ?? '',
      dial_max_length: json['dial_max_length'] ?? '',
    );
  }
}
