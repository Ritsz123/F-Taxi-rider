import 'package:uber_clone/auth/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> userRegister({String? email, String? password, String? name, String? mobile});
  Future<Map<String, dynamic>> userLogin(String email, String password);
  Future<UserModel> getUserProfile(String email);
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  @override
  Future<UserModel> getUserProfile(String email) {
    // TODO: implement getUserProfile
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> userLogin(String email, String password) {
    // TODO: implement userLogin
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> userRegister({String? email, String? password, String? name, String?   mobile}) {
    // TODO: implement userRegister
    throw UnimplementedError();
  }

}
