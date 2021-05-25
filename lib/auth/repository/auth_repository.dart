import 'package:dartz/dartz.dart';
import 'package:uber_clone/auth/datasource/auth_remote_data_source.dart';
import 'package:uber_clone/auth/entities/User.dart';
import 'package:uber_clone/core/error/error.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> userRegister({String? name, String? email, String? password, String? mobile});
  Future<Either<Failure, User>> userLogin({String? email, String? password});
  Future<Either<Failure, User>> getUserProfile();
}

class AuthRepositoryImpl extends AuthRepository {

  final AuthRemoteDataSource? remoteDataSource;

  AuthRepositoryImpl({this.remoteDataSource});

  @override
  Future<Either<Failure, User>> getUserProfile() {
    // TODO: implement getUserProfile
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> userLogin({String? email, String? password}) {
    // TODO: implement userLogin
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, User>> userRegister({String? name, String? email, String? password, String? mobile}) {
    // TODO: implement userRegister
    throw UnimplementedError();
  }

}
