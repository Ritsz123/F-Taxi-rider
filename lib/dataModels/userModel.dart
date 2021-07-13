
class UserModel {
  String id;
  String fullName;
  String phone;
  String email;

  UserModel({
    required this.id,
    required this.email,
    required this.phone,
    required this.fullName
  });

  static UserModel fromJson(Map<String, dynamic> json){
    return UserModel(
      id: json['_id'].toString(),
      email: json['email'].toString(),
      phone: json['phone'].toString(),
      fullName: json['name'].toString(),
    );
  }
}
