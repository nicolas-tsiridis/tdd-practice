import 'package:get_it/get_it.dart';
import 'package:tdd_practice_flutter/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:tdd_practice_flutter/src/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:tdd_practice_flutter/src/authentication/domain/repository/authentication_repository.dart';
import 'package:tdd_practice_flutter/src/authentication/domain/usecases/create_user.dart';
import 'package:tdd_practice_flutter/src/authentication/domain/usecases/get_users.dart';
import 'package:tdd_practice_flutter/src/authentication/presentation/cubit/cubit/authentication_cubit.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  sl
    //app logic
    ..registerFactory(
        () => AuthenticationCubit(createUser: sl(), getUsers: sl()))
    //use cases
    ..registerLazySingleton(() => CreateUser(sl()))
    ..registerLazySingleton(() => GetUsers(sl()))
    //repositories
    ..registerLazySingleton<AuthenticationRepository>(
        () => AuthenticationRepositoryImplementation(sl()))
    //data sources
    ..registerLazySingleton<AuthenticationRemoteDataSource>(
        () => AuthenticationRemoteDataSourceImplementation(sl()))
    //external dependencies
    ..registerLazySingleton(http.Client.new); //equivalent to () => http.Client
}
