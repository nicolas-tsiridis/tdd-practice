import 'package:tdd_practice_flutter/core/usecase/usecase.dart';
import 'package:tdd_practice_flutter/core/utils/typedef.dart';
import 'package:tdd_practice_flutter/src/authentication/domain/entities/user.dart';
import 'package:tdd_practice_flutter/src/authentication/domain/repository/authentication_repository.dart';

class GetUsers extends UsecaseWithoutParams<List<User>> {

  const GetUsers(this._repository);

  final AuthenticationRepository _repository;

  @override
  ResultFuture<List<User>> call() async => _repository.getUsers();
}