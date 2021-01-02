// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// 📦 Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// 🌎 Project imports:
import 'package:Quiz_Guru/exceptions/network_exception.dart';
import 'package:Quiz_Guru/models/user_model.dart';
import 'package:Quiz_Guru/repositories/user_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit({@required this.repository}) : super(const UserState.loading());

  final UserRepository repository;

  Future<void> fetchUser() async {
    emit(const UserState.loading());
    try {
      final user = await repository.getUserInfo();
      user.fold((l) => throw NetworkException("No internet connection"),
          (r) => emit(UserState.success(r)));
    } on NetworkException catch (e) {
      emit(UserState.failure(e.message));
    }
  }
}
