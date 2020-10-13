part of 'test_cubit.dart';

enum TestStatus { loading, success, failure }

class TestState extends Equatable {
  const TestState._({
    this.status = TestStatus.loading,
    this.items = const <TestModel>[],
  });

  const TestState.loading() : this._();

  const TestState.success(List<TestModel> items)
      : this._(status: TestStatus.success, items: items);

  const TestState.failure() : this._(status: TestStatus.failure);

  final TestStatus status;
  final List<TestModel> items;

  @override
  List<Object> get props => [status, items];
}
