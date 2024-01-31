import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_practice_flutter/core/utils/typedef.dart';
import 'package:tdd_practice_flutter/src/authentication/data/models/user_model.dart';
import 'package:tdd_practice_flutter/src/authentication/domain/entities/user.dart';

import '../../../../fixtures/fixture_reader.dart';

main () {

  const tModel = UserModel.empty();
  test(
    'must be subclass of [User] entity', ()  {

      expect(tModel, isA<User>());
    }
  );

  final tJson = fixture('user.json');
  final tMap = jsonDecode(tJson) as DataMap;
  group('fromMap', () {

    test('must return [UserModel] with correct data', () {

      final result = UserModel.fromMap(tMap);
      expect(result, equals(tModel));
    });
  });

  group('fromJson', () {

    test('must return [UserModel] with correct data', () {

      final result = UserModel.fromJson(tJson);
      expect(result, equals(tModel));
    });
  });

  group('toMap', () { 
    test(
      'must return [DataMap] with correct data', () {

        final result = tModel.toMap();
        expect(result, equals(tMap));
      }
    );
  });

  group('copyWith', () { 
    test(
      'must return [UserModel] with copied data', () {

        final result = tModel.copyWith();
        expect(result, equals(const UserModel.empty()));
      }
    );

    test(
      'must return [UserModel] entity with updated name', () {

        final result = tModel.copyWith(name: 'jan');
        expect(result.name, equals('jan'));
      }
    );
  });
}