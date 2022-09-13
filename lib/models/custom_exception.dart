class CustomException {
  String code;
  String message;

  CustomException({
    required this.code,
    required this.message,
  });

  factory CustomException.fromJson(Map<String, dynamic> json) {
    return CustomException(
      code: json['code'] ?? '',
      message: json['message'] ?? '',
    );
  }
}
