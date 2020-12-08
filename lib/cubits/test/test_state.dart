part of 'test_cubit.dart';

enum TestStatus { loading, success, failure, started }

class TestState extends Equatable {
  const TestState._(
      {this.status = TestStatus.loading,
      this.tests = const <TestModel>[],
      this.user,
      this.message,
      this.test});

  const TestState.loading() : this._();

  const TestState.success(List<TestModel> tests, UserModel user)
      : this._(status: TestStatus.success, tests: tests, user: user);

  const TestState.started(TestModel test)
      : this._(status: TestStatus.started, test: test);

  TestState.failure(String message,
      {List<TestModel> tests = const [], UserModel user})
      : this._(
            status: TestStatus.failure,
            message: message,
            tests: tests,
            user: user);

  final TestStatus status;
  final List<TestModel> tests;
  final String message;
  final TestModel test;
  final UserModel user;

  @override
  List<Object> get props => [status, tests, message, test, user];
}
