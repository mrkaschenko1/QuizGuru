part of 'test_cubit.dart';

enum TestStatus { loading, success, failure, started}

class TestState extends Equatable {
  const TestState._({
    this.status = TestStatus.loading,
    this.tests = const <TestModel>[],
    this.message,
    this.test
  });

  const TestState.loading() : this._();

  const TestState.success(List<TestModel> tests)
      : this._(status: TestStatus.success, tests: tests);

  const TestState.started(TestModel test) : this._(status: TestStatus.started, test: test);

  TestState.failure(String message, {List<TestModel> tests = const []}) : this._(
      status: TestStatus.failure,
      message: message,
      tests: tests
  );

  final TestStatus status;
  final List<TestModel> tests;
  final String message;
  final TestModel test;

  @override
  List<Object> get props => [status, tests, message, test];
}
