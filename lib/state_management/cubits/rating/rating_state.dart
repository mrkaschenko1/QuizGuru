part of 'rating_cubit.dart';

enum RatingStatus { loading, success, failure, refreshed }

class RatingState extends Equatable {
  const RatingState._({
    this.status = RatingStatus.loading,
    this.rating = const <dynamic>[],
    this.message,
  });

  const RatingState.loading() : this._();

  const RatingState.success(List<dynamic> rating)
      : this._(
          status: RatingStatus.success,
          rating: rating,
        );

  const RatingState.failure(String message,
      {List<dynamic> rating = const <dynamic>[]})
      : this._(
          status: RatingStatus.failure,
          message: message,
          rating: rating,
        );

  const RatingState.refreshed(String message,
      {List<dynamic> rating = const <dynamic>[]})
      : this._(
          status: RatingStatus.refreshed,
          message: message,
          rating: rating,
        );

  final RatingStatus status;
  final List<dynamic> rating;
  final String message;

  @override
  List<Object> get props => [
        status,
        rating,
        message,
      ];
}
