// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// 📦 Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// 🌎 Project imports:
import '../../../exceptions/network_exception.dart';
import '../../../repositories/user_repository.dart';

part 'rating_state.dart';

class RatingCubit extends Cubit<RatingState> {
  RatingCubit({@required this.repository}) : super(const RatingState.loading());

  final UserRepository repository;

  Future<void> fetchRating() async {
    emit(RatingState.loading());
    try {
      final rating = await repository.getRating();
      rating.fold((l) => throw NetworkException("No internet connection"),
          (r) => emit(RatingState.success(r)));
    } on NetworkException catch (e) {
      emit(RatingState.failure(e.message, rating: state.rating));
    }
  }

  Future<void> refreshRating() async {
    try {
      final rating = await repository.getRating();
      var ratingList = [];
      rating.fold((l) => throw NetworkException("No internet connection"),
          (r) => {ratingList = r});
      emit(RatingState.success(ratingList));
      emit(RatingState.refreshed("successfully refreshed rating",
          rating: ratingList));
    } on NetworkException catch (e) {
      emit(RatingState.failure(e.message, rating: state.rating));
    }
  }
}
