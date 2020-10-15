import 'package:android_guru/exceptions/network_exception.dart';
import 'package:android_guru/models/user_model.dart';
import 'package:android_guru/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit({@required this.repository}) : super(const UserState.loading());

  final UserRepository repository;

  Future<void> fetchUser() async {
    emit(UserState.loading());
    try {
      final user = await repository.getUserInfo();
      user.fold(
              (l) => throw NetworkException("No internet connection"),
              (r) => emit(UserState.success(r))
      );
    } on NetworkException catch (e) {
      emit(UserState.failure(e.message));
    }
  }
}
