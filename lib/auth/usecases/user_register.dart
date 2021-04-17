import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:uber_clone/auth/entities/User.dart';
import 'package:uber_clone/auth/repository/auth_repository.dart';
import 'package:uber_clone/core/error/error.dart';
import 'package:uber_clone/core/usecases/usecase.dart';

class UserRegister extends UseCase<User, UserRegisterParams> {
  final AuthRepository _authRepository;

  UserRegister(this._authRepository);

  @override
  Future<Either<Failure, User>> call(UserRegisterParams params) {
    return _authRepository.userRegister(
      email: params.email,
      password: params.password,
      mobile: params.mobile,
      name: params.name,
    );
  }
}

class UserRegisterParams extends Equatable {
  final String email;
  final String password;
  final String mobile;
  final String name;

  UserRegisterParams(this.email, this.password, this.mobile, this.name);

  @override
  List<Object> get props => [email, password, mobile, name];
}
