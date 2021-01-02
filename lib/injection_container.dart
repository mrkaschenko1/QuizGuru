// 📦 Package imports:
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

// 🌎 Project imports:
import 'package:Quiz_Guru/network/network_info.dart';
import 'package:Quiz_Guru/repositories/test_repository.dart';
import 'package:Quiz_Guru/repositories/user_repository.dart';
import 'package:Quiz_Guru/state_management/blocs/lang/lang_bloc.dart';
import 'package:Quiz_Guru/state_management/blocs/login/login_bloc.dart';
import 'package:Quiz_Guru/state_management/blocs/theme/theme_bloc.dart';
import 'package:Quiz_Guru/state_management/cubits/question/question_cubit.dart';
import 'package:Quiz_Guru/state_management/cubits/rating/rating_cubit.dart';
import 'package:Quiz_Guru/state_management/cubits/test/test_cubit.dart';
import 'package:Quiz_Guru/state_management/cubits/user/user_cubit.dart';

final sl = GetIt.instance;

void init() {
  //bloc
  sl.registerFactory(() => LoginBloc(userRepository: sl()));
  sl.registerFactory(() => ThemeBloc());
  sl.registerFactory(() => LangBloc());
  sl.registerFactory(
      () => TestCubit(testRepository: sl(), userRepository: sl()));
  sl.registerFactory(() => RatingCubit(repository: sl()));
  sl.registerFactory(() => UserCubit(repository: sl()));
  sl.registerFactory(() => QuestionCubit(repository: sl()));

  //repository
  sl.registerLazySingleton<UserRepository>(() => UserRepository(
        firebaseDatabase: sl(),
        firebaseAuth: sl(),
        googleSignIn: sl(),
        networkInfo: sl(),
      ));

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
  sl.registerLazySingleton(() => GoogleSignIn());
  sl.registerSingleton(FirebaseDatabase.instance);
  sl.registerSingleton(FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseMessaging());
  sl.registerLazySingleton(() => DataConnectionChecker());
}
