abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> userRegister({String email, String password, String name, String mobile});
  Future<Map<String, dynamic>> userLogin(String email, String password);
  Future<Map<String, dynamic>> getUserProfile(String email);
}
