import 'package:android_guru/exceptions/network_exception.dart';
import 'package:android_guru/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  RatingCubit({@required this.repository}) : super(const RatingState.loading());

  final UserRepository repository;

  Future<void> fetchRating() async {
    emit(RatingState.loading());
    try {
      final rating = await repository.getRating();
      rating.fold(
              (l) => throw NetworkException("No internet connection"),
              (r) => emit(RatingState.success(r))
      );
    } on NetworkException catch (e) {
      emit(RatingState.failure(e.message, rating: state.rating));
    }
  }
}
