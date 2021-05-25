import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String? id;
  String? fullName;
  String? phone;
  String? email;

  UserModel({this.id, this.email, this.phone, this.fullName});

  UserModel.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    phone = snapshot.value['phone'];
    email = snapshot.value['email'];
    fullName = snapshot.value['fullname'];
  }
}
