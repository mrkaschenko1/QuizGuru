import 'package:android_guru/blocs/lang/lang_bloc.dart';
import 'package:android_guru/blocs/login/login_bloc.dart';
import 'package:android_guru/cubits/test/test_cubit.dart';
import 'package:android_guru/network/network_info.dart';
import 'package:android_guru/repositories/test_repository.dart';
import 'package:android_guru/repositories/user_repository.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';

import 'blocs/theme/theme_bloc.dart';

final sl = GetIt.instance;

void init() {
  //bloc
  sl.registerFactory(() => LoginBloc(userRepository: sl()));
  sl.registerFactory(() => ThemeBloc());
  sl.registerFactory(() => LangBloc());
  sl.registerFactory(() => TestCubit(repository: sl()));

  //repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepository(
      firebaseDatabase: sl(),
      firebaseAuth: sl(),
      googleSignIn: sl(),
      networkInfo: sl(),
    )
  );

  sl.registerLazySingleton<TestRepository>(
    () => TestRepository(
      userRepository: sl(),
      firebaseDatabase: sl(),
      networkInfo: sl(),
    ),
  );

  //core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //external
  sl.registerSingleton(FirebaseDatabase.instance);
  sl.registerSingleton(FirebaseAuth.instance);
  sl.registerLazySingleton(() => DataConnectionChecker());
}