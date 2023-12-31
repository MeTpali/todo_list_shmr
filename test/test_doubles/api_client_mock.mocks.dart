// Mocks generated by Mockito 5.4.2 from annotations
// in todo_list_shmr/test/test_doubles/api_client_mock.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:todo_list_shmr/domain/api_client.dart' as _i2;
import 'package:todo_list_shmr/task_model/task_config.dart' as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [ApiClient].
///
/// See the documentation for Mockito's code generation for more information.
class MockApiClient extends _i1.Mock implements _i2.ApiClient {
  MockApiClient() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<_i4.TaskWidgetConfiguration>> getTaskList() =>
      (super.noSuchMethod(
        Invocation.method(
          #getTaskList,
          [],
        ),
        returnValue: _i3.Future<List<_i4.TaskWidgetConfiguration>>.value(
            <_i4.TaskWidgetConfiguration>[]),
      ) as _i3.Future<List<_i4.TaskWidgetConfiguration>>);
  @override
  _i3.Future<void> postTask(_i4.TaskWidgetConfiguration? config) =>
      (super.noSuchMethod(
        Invocation.method(
          #postTask,
          [config],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<_i4.TaskWidgetConfiguration?> getTask(String? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #getTask,
          [id],
        ),
        returnValue: _i3.Future<_i4.TaskWidgetConfiguration?>.value(),
      ) as _i3.Future<_i4.TaskWidgetConfiguration?>);
  @override
  _i3.Future<void> patchTaskList(List<_i4.TaskWidgetConfiguration>? list) =>
      (super.noSuchMethod(
        Invocation.method(
          #patchTaskList,
          [list],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<void> updateTask(_i4.TaskWidgetConfiguration? config) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateTask,
          [config],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
  @override
  _i3.Future<void> deleteTask(String? id) => (super.noSuchMethod(
        Invocation.method(
          #deleteTask,
          [id],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}
