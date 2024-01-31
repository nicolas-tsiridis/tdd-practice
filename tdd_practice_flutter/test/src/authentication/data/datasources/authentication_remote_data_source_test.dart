import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tdd_practice_flutter/core/errors/exceptions.dart';
import 'package:tdd_practice_flutter/core/utils/constants.dart';
import 'package:tdd_practice_flutter/src/authentication/data/models/user_model.dart';
import 'package:tdd_practice_flutter/src/authentication/data/datasources/authentication_remote_data_source.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthenticationRemoteDataSource remoteDataSource;

  setUp(() {
    client = MockClient();
    remoteDataSource = AuthenticationRemoteDataSourceImplementation(client);
    registerFallbackValue(Uri());
  });

  group('creatUser', () {
    test('Should complete successfully when the status code is 200 or 201',
        () async {
      when(() => client.post(any(),
              body: any(named: 'body'),
              headers: {'Context-Type': 'application/json'}))
          .thenAnswer(
              (_) async => http.Response('User created successfully', 201));
      final methodCall = remoteDataSource.createUser;
      expect(methodCall(createdAt: 'createdAt', name: 'name', avatar: 'avatar'),
          completes);
      verify(() => client.post(Uri.https(kBaseUrl, kCreateUsersEndpoint),
          body: jsonEncode(
              ({'createdAt': 'createdAt', 'name': 'name', 'avatar': 'avatar'})),
          headers: {'Context-Type': 'application/json'})).called(1);
      verifyNoMoreInteractions(client);
    });

    test('must throw [APIException] when status code is not 200 or 201',
        () async {
      when(() => client.post(any(),
              body: any(named: 'body'),
              headers: {'Context-Type': 'application/json'}))
          .thenAnswer((_) async => http.Response('Invalid email address', 400));
      final methodCall = remoteDataSource.createUser;
      expect(
          () async => methodCall(
              createdAt: 'createdAt', name: 'name', avatar: 'avatar'),
          throwsA(const ApiException(
              message: 'Invalid email address', statusCode: 400)));
      verify(() => client.post(Uri.https(kBaseUrl, kCreateUsersEndpoint),
          body: jsonEncode(
              ({'createdAt': 'createdAt', 'name': 'name', 'avatar': 'avatar'})),
          headers: {'Context-Type': 'application/json'})).called(1);
      verifyNoMoreInteractions(client);
    });
  });

  group('getUsers', () {
    const tUsers = [UserModel.empty()];
    test('Should return [List<User>] when status code is 200 or 201', () async {
      when(() => client.get(any())).thenAnswer((_) async => http.Response(
            jsonEncode([tUsers.first.toMap()]),
            200,
          ));
      final result = await remoteDataSource.getUsers();
      expect(result, equals(tUsers));
      verify(() => client.get(Uri.https(kBaseUrl, kGetUsersEndpoint)))
          .called(1);
      verifyNoMoreInteractions(client);
    });

    test('must throw [ApiException] when status code is not 200 or 201',
        () async {
      const tMessage = 'Server down, certified bad bad';
      when(() => client.get(any())).thenAnswer((_) async => http.Response(
            tMessage,
            500,
          ));
      final methodCall = remoteDataSource.getUsers;
      expect(() => methodCall(),
          throwsA(const ApiException(message: tMessage, statusCode: 500)));
      verify(() => client.get(Uri.https(kBaseUrl, kGetUsersEndpoint)))
          .called(1);
      verifyNoMoreInteractions(client);
    });
  });
}
