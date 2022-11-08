class User {
  int? id;
  String? socialId;
  String? name;
  String? email;
  String? password;
  String? phone;
  String? avatar;
  String? gender;
  String? dateOfBirth;
  int? cityId;
  int? stateId;
  int? countryId;
  String? createdAt;
  String? updatedAt;
  String? emailVerifiedAt;
  String? userToken;

  User({
    this.id,
    this.socialId,
    this.name,
    this.email,
    this.password,
    this.phone,
    this.avatar,
    this.gender,
    this.dateOfBirth,
    this.cityId,
    this.stateId,
    this.countryId,
    this.createdAt,
    this.updatedAt,
    this.emailVerifiedAt,
    this.userToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      socialId: json['socialId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      phone: json['phone'] ?? '',
      avatar: json['avatar'] ?? '',
      gender: json['gender'] ?? 'male',
      dateOfBirth: json['date_of_birth'] ?? '',
      cityId: json['cityId'] ?? 0,
      stateId: json['stateId'] ?? 0,
      countryId: json['countryId'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      emailVerifiedAt: json['emailVerifiedAt'] ?? '',
      userToken: json['user-token'] ?? '',
    );
  }
}
