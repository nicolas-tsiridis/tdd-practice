import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_practice_flutter/core/errors/exceptions.dart';
import 'package:tdd_practice_flutter/core/errors/failure.dart';
import 'package:tdd_practice_flutter/src/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:tdd_practice_flutter/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd_practice_flutter/src/authentication/domain/entities/user.dart';

class MockAuthenticationRemoteDateSource extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource remoteDataSource;
  late AuthenticationRepositoryImplementation repositoryImplementation;

  setUp(() {
    remoteDataSource = MockAuthenticationRemoteDateSource();
    repositoryImplementation =
        AuthenticationRepositoryImplementation(remoteDataSource);
  });

  const tException =
      ApiException(message: 'Unknown error occurred', statusCode: 500);

  group('createUser', () {
    const createdAt = '123.createdAt';
    const name = '123.name';
    const avatar = '123.avatar';
    test(
        'Must call [RemoteDataSource.createUser] and return proper data '
        'and complete successfully when remote source is successful', () async {
      when(() => remoteDataSource.createUser(
              createdAt: any(named: 'createdAt'),
              name: any(named: 'name'),
              avatar: any(named: 'avatar')))
          .thenAnswer((_) async => Future.value());

      final result = await repositoryImplementation.createUser(
          createdAt: createdAt, name: name, avatar: avatar);

      expect(result, equals(const Right(null)));

      verify(() => remoteDataSource.createUser(
          createdAt: createdAt, name: name, avatar: avatar)).called(1);

      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        'should returin a [ApiFailure] when the call to the '
        'remote data source is unsuccessful', () async {
      when(() => remoteDataSource.createUser(
          createdAt: any(named: 'createdAt'),
          name: any(named: 'name'),
          avatar: any(named: 'avatar'))).thenThrow(tException);

      final result = await repositoryImplementation.createUser(
          createdAt: createdAt, name: name, avatar: avatar);

      expect(
          result,
          equals(Left(ApiFailure(
              message: tException.message,
              statusCode: tException.statusCode))));

      verify(() => remoteDataSource.createUser(
          createdAt: createdAt, name: name, avatar: avatar)).called(1);

      verifyNoMoreInteractions(remoteDataSource);
    });
  });

  group('getUsers', () {
    test(
        'Must call [RemoteDataSource.getUsers], return proper data, '
        'and return [List<User>] when remote source is successful', () async {
      when(() => remoteDataSource.getUsers()).thenAnswer((_) async => []);

      final result = await repositoryImplementation.getUsers();
      expect(result, isA<Right<dynamic, List<User>>>());
      verify(() => remoteDataSource.getUsers()).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });

    test(
        'should returin a [ApiFailure] when the call to the '
        'remote data source is unsuccessful', () async {
      when(() => remoteDataSource.getUsers()).thenThrow(tException);
      final result = await repositoryImplementation.getUsers();
      expect(result, equals(Left(ApiFailure.fromException(tException))));
      verify(() => remoteDataSource.getUsers()).called(1);
      verifyNoMoreInteractions(remoteDataSource);
    });
  });
}
