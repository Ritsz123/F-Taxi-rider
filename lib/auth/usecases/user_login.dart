import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone/auth/entities/User.dart';
import 'package:uber_clone/auth/repository/auth_repository.dart';
import 'package:uber_clone/core/error/error.dart';
import 'package:uber_clone/core/usecases/usecase.dart';

class UserLogin extends UseCase<User, UserLoginParams> {
  final AuthRepository _authRepository;

  UserLogin(this._authRepository);

  @override
  Future<Either<Failure, User>> call(UserLoginParams params) {
    return _authRepository.userLogin(email: params.email, password: params.password);
  }
}

class UserLoginParams extends Equatable {
  final String email;
  final String password;

  UserLoginParams({
    @required this.email,
    @required this.password,
  });

  @override
  List<Object> get props => [email, password];
}
