// UserMeModel - Asosiy model
class UserMeModel {
  final int id;
  final String firstName;
  final String lastName;
  final String login;
  final String phone;
  final String code;
  UserMeModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.login,
    required this.phone,
    required this.code,
  });
  factory UserMeModel.fromJson(Map<String, dynamic> json) {
    return UserMeModel(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      login: json['login'] as String,
      phone: json['phone'] as String,
      code: json['code'] as String,
    );
  }
}
