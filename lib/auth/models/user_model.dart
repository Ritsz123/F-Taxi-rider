import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone/auth/entities/User.dart';

class UserModel extends User {
  UserModel({
    @required String id,
    @required String name,
    @required String email,
    @required String mobile,
    @required bool isActive,
  }) : super(
          id: id,
          name: name,
          mobile: mobile,
          email: email,
          isActive: isActive,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> tojson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile': mobile,
      'isActive': isActive,
    };
  }
}
