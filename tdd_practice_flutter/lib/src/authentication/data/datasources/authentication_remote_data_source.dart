import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tdd_practice_flutter/core/errors/exceptions.dart';
import 'package:tdd_practice_flutter/core/utils/constants.dart';
import 'package:tdd_practice_flutter/core/utils/typedef.dart';
import 'package:tdd_practice_flutter/src/authentication/data/models/user_model.dart';

abstract class AuthenticationRemoteDataSource {
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  Future<List<UserModel>> getUsers();
}

class AuthenticationRemoteDataSourceImplementation
    implements AuthenticationRemoteDataSource {
  const AuthenticationRemoteDataSourceImplementation(this._client);

  final http.Client _client;

  @override
  Future<void> createUser(
      {required String createdAt,
      required String name,
      required String avatar}) async {
    try {
      final response = await _client.post(
          Uri.https(
            kBaseUrl,
            kCreateUsersEndpoint,
          ),
          body: jsonEncode(
              ({'createdAt': createdAt, 'name': name, 'avatar': avatar})),
          headers: {'Context-Type': 'application/json'});
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ApiException(
            message: response.body, statusCode: response.statusCode);
      }
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response =
          await _client.get(Uri.https(kBaseUrl, kGetUsersEndpoint));
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw (ApiException(
            message: response.body, statusCode: response.statusCode));
      }
      return List<DataMap>.from(jsonDecode(response.body) as List)
          .map((userData) => UserModel.fromMap(userData))
          .toList();
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(message: e.toString(), statusCode: 506);
    }
  }
}
