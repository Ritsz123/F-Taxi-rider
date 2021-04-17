import 'package:dartz/dartz.dart';
import 'package:uber_clone/auth/entities/User.dart';
import 'package:uber_clone/core/error/error.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> userRegister({String name, String email, String password, String mobile});
  Future<Either<Failure, User>> userLogin({String email, String password});
  Future<Either<Failure, User>> getUserProfile();
}
