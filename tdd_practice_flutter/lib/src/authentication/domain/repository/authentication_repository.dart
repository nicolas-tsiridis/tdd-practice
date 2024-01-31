import 'package:tdd_practice_flutter/core/utils/typedef.dart';
import 'package:tdd_practice_flutter/src/authentication/domain/entities/user.dart';

abstract class AuthenticationRepository {
  
  const AuthenticationRepository();

  ResultVoid createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  ResultFuture<List<User>> getUsers();
}