import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class User extends Equatable {
  final String? id;
  final String? name;
  final String? email;
  final String? mobile;
  final bool? isActive;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.isActive,
  });

  @override
  List<Object?> get props => <Object?>[id, name, email, mobile, isActive];
}
