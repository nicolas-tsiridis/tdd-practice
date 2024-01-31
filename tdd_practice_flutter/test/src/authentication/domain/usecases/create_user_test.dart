//quesitons:
//what does the class depend on?
//authentication repository
//How can we create a fake version of the dependency?
//use Mocktail!
//How do we control what our dependencies do?
//using the Mocktail APIs

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_practice_flutter/src/authentication/domain/repository/authentication_repository.dart';
import 'package:tdd_practice_flutter/src/authentication/domain/usecases/create_user.dart';

import '../../authentication_repository.mock.dart';

void main() {

  late CreateUser usecase;
  late AuthenticationRepository repository;

  setUp(() {
    repository = MockAuthenticationRepository();
    usecase = CreateUser(repository);
  });

  const params = CreateUserParams.empty();
  test(
    'should call [AuthenticationRepository.createUser]', 
    () async {

      when(() => repository.createUser( //Arrange (STUB)
        createdAt: any(named: 'createdAt'), 
        name: any(named: 'name'), 
        avatar: any(named: 'avatar')
      )).thenAnswer((_) async => const Right(null));

      final result = await usecase(params); //Act

      expect(result, equals(const Right<dynamic, void>(null))); //Assert
      verify(() => repository.createUser(
        createdAt: params.createdAt, 
        name: params.name, 
        avatar: params.avatar
      )).called(1);
      verifyNoMoreInteractions(repository);
    }
  );
}
