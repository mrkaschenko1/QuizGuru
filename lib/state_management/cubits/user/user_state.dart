part of 'user_cubit.dart';

enum UserStatus {
  loading,
  success,
  failure,
}

class UserState extends Equatable {
  const UserState._({
    this.status = UserStatus.loading,
    this.user,
    this.message,
  });

  const UserState.loading() : this._();

  const UserState.success(UserModel user)
      : this._(
          status: UserStatus.success,
          user: user,
        );

  const UserState.failure(String message)
      : this._(
          status: UserStatus.failure,
          message: message,
        );

  final UserStatus status;
  final UserModel user;
  final String message;

  @override
  List<Object> get props => [
        status,
        user,
        message,
      ];
}
