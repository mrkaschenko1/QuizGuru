part of 'rating_cubit.dart';

enum RatingStatus { loading, success, failure }

class RatingState extends Equatable {
  const RatingState._({
    this.status = RatingStatus.loading,
    this.rating = const <dynamic>[],
    this.message,
  });

  const RatingState.loading() : this._();

  const RatingState.success(List<dynamic> rating)
      : this._(status: RatingStatus.success, rating: rating);

  RatingState.failure(String message, {List<dynamic> rating = const []}) : this._(
      status: RatingStatus.failure,
      message: message,
      rating: rating
  );

  final RatingStatus status;
  final List<dynamic> rating;
  final String message;

  @override
  List<Object> get props => [status, rating, message];
}

