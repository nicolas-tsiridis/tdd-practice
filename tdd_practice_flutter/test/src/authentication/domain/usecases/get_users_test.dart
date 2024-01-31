
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_practice_flutter/src/authentication/domain/entities/user.dart';
import 'package:tdd_practice_flutter/src/authentication/domain/repository/authentication_repository.dart';
import 'package:tdd_practice_flutter/src/authentication/domain/usecases/get_users.dart';

import '../../authentication_repository.mock.dart';

void main() {

  late GetUsers usecase;
  late AuthenticationRepository repository;

  setUp(() {
    repository = MockAuthenticationRepository();
    usecase = GetUsers(repository);
  });
  
  final tResponse = [const User.empty()];

  test(
    'should call [AuthenticationRepository.createUser]', 
    () async {
      when(() => repository.getUsers())
      .thenAnswer((_) async  => Right(tResponse));

      final result = await usecase;

      expect(result, equals(Right<dynamic, List<User>>(tResponse)));
      verify(() => repository.getUsers()).called(1);
      verifyNoMoreInteractions(repository);
    }
  );

}