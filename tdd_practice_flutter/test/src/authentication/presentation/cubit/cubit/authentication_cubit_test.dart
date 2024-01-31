import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tdd_practice_flutter/core/errors/failure.dart';
import 'package:tdd_practice_flutter/src/authentication/domain/entities/user.dart';
import 'package:tdd_practice_flutter/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_practice_flutter/src/authentication/domain/usecases/get_users.dart';
import 'package:tdd_practice_flutter/src/authentication/presentation/cubit/cubit/authentication_cubit.dart';

class MockGetUsers extends Mock implements GetUsers {}

class MockCreateUser extends Mock implements CreateUser {}

void main() {
  late GetUsers getUsers;
  late CreateUser createUser;
  late AuthenticationCubit cubit;

  const tCreateUserParams = CreateUserParams.empty();
  const tApiFailure = ApiFailure(message: 'message', statusCode: 400);
  const tUserList = [User.empty()];

  setUp(() {
    getUsers = MockGetUsers();
    createUser = MockCreateUser();
    cubit = AuthenticationCubit(createUser: createUser, getUsers: getUsers);
    registerFallbackValue(tCreateUserParams);
  });

  tearDown(() => cubit.close());

  test('initial state must be [AuthenticationInitial]', () async {
    expect(cubit.state, const AuthenticationInitial());
  });

  group('createUser', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
        'must emit [creatingUser, UserCreated] when successful',
        build: () {
          when(() => createUser(any()))
              .thenAnswer((_) async => const Right(null));
          return cubit;
        },
        act: (cubit) => cubit.createUser(
            createdAt: tCreateUserParams.createdAt,
            name: tCreateUserParams.name,
            avatar: tCreateUserParams.avatar),
        expect: () => const [CreatingUser(), UserCreated()],
        verify: (_) {
          verify(() => createUser(tCreateUserParams)).called(1);
          verifyNoMoreInteractions(createUser);
        });

    blocTest<AuthenticationCubit, AuthenticationState>(
        'must emit [CreatingUser, AuthenticationError] when unsuccessful',
        build: () {
          when(() => createUser(any()))
              .thenAnswer((_) async => const Left(tApiFailure));
          return cubit;
        },
        act: (cubit) => cubit.createUser(
            createdAt: tCreateUserParams.createdAt,
            name: tCreateUserParams.name,
            avatar: tCreateUserParams.avatar),
        expect: () => [
              const CreatingUser(),
              AuthenticationError(tApiFailure.errorMessage)
            ],
        verify: (_) {
          verify(() => createUser(tCreateUserParams)).called(1);
          verifyNoMoreInteractions(createUser);
        });
  });
  group('getUsers', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
        'must emit [GettingUsers, UsersLoaded] when successful',
        build: () {
          when(() => getUsers())
              .thenAnswer((_) async => const Right(tUserList));
          return cubit;
        },
        act: (cubit) => cubit.getUsers(),
        expect: () => const [GettingUsers(), UsersLoaded(tUserList)],
        verify: (_) {
          verify(() => getUsers()).called(1);
          verifyNoMoreInteractions(getUsers);
        });

    blocTest<AuthenticationCubit, AuthenticationState>(
        'must emit [GettingUsers, AuthenticationError] when unsuccessful',
        build: () {
          when(() => getUsers())
              .thenAnswer((_) async => const Left(tApiFailure));
          return cubit;
        },
        act: (cubit) => cubit.getUsers(),
        expect: () => [
              const GettingUsers(),
              AuthenticationError(tApiFailure.errorMessage)
            ],
        verify: (_) {
          verify(() => getUsers()).called(1);
          verifyNoMoreInteractions(getUsers);
        });
  });
}
