import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_list_shmr/utility/converters/db_convert.dart';
import 'package:todo_list_shmr/utility/converters/server_convert.dart';
import 'package:todo_list_shmr/core/task_repository.dart';
import 'package:todo_list_shmr/domain/api_client.dart';
import 'package:todo_list_shmr/domain/database_helper.dart';

import 'data/mock_db_converters.dart';
import 'data/mock_server_converters.dart';
import 'data/mock_tasks.dart';
import 'test_doubles/api_client_mock.mocks.dart';
import 'test_doubles/database_mock.mocks.dart';

class MockTaskListBloc extends MockBloc<TaskListEvent, TaskListState>
    implements TaskListBloc {}

void main() {
  group('whenListen TaskListBloc', () {
    test("TaskListBloc's stream mock", () {
      final bloc = MockTaskListBloc();

      whenListen(
          bloc, Stream.fromIterable([mockState1, mockState2, mockState3]));

      expectLater(bloc.stream,
          emitsInOrder(<TaskListState>[mockState1, mockState2, mockState3]));
    });
  });

  group('TaskListBloc', () {
    late ApiClient apiClient;
    late DatabaseHelper databaseHelper;

    setUp(() {
      apiClient = MockApiClient();
      databaseHelper = MockDatabaseHelper();
    });
    blocTest<TaskListBloc, TaskListState>(
      'Get task list',
      build: () {
        when(databaseHelper.getTaskList())
            .thenAnswer((_) => Future.value(mockDBTaskList));
        when(apiClient.getTaskList())
            .thenAnswer((_) => Future.value(mockDBTaskList));
        return TaskListBloc(
          const TaskListState.inital(),
          apiClient,
          databaseHelper,
        );
      },
      act: (bloc) {
        bloc.add(TaskListUpdate());
      },
      expect: () => <TaskListState>[mockState],
    );
    blocTest<TaskListBloc, TaskListState>(
      'Delete task',
      build: () {
        when(databaseHelper.deleteTask(thirdTask.id))
            .thenAnswer((_) => Future.value(1));
        when(apiClient.deleteTask(thirdTask.id))
            .thenAnswer((_) => Future.value());
        when(databaseHelper.getTaskList())
            .thenAnswer((_) => Future.value(mockList2));
        when(apiClient.getTaskList())
            .thenAnswer((_) => Future.value(mockList2));
        return TaskListBloc(
          mockState3,
          apiClient,
          databaseHelper,
        );
      },
      act: (bloc) {
        bloc.add(TaskListDeleteTask(id: thirdTask.id));
      },
      expect: () => <TaskListState>[mockState2],
    );
    blocTest<TaskListBloc, TaskListState>(
      'Change task state',
      build: () {
        when(databaseHelper.updateTask(thirdTaskChanged))
            .thenAnswer((_) => Future.value(1));
        when(apiClient.updateTask(thirdTaskChanged))
            .thenAnswer((_) => Future.value());
        when(databaseHelper.getTaskList())
            .thenAnswer((_) => Future.value(mockList3));
        when(apiClient.getTaskList())
            .thenAnswer((_) => Future.value(mockList3));
        return TaskListBloc(
          mockState3,
          apiClient,
          databaseHelper,
        );
      },
      act: (bloc) {
        bloc.add(TaskListChangeTaskState(id: thirdTask.id));
      },
    );
    blocTest<TaskListBloc, TaskListState>(
      'Update task',
      build: () {
        when(databaseHelper.updateTask(secondTaskChanged))
            .thenAnswer((_) => Future.value(1));
        when(apiClient.updateTask(secondTaskChanged))
            .thenAnswer((_) => Future.value());
        when(databaseHelper.getTaskList())
            .thenAnswer((_) => Future.value(mockList2Changed));
        when(apiClient.getTaskList())
            .thenAnswer((_) => Future.value(mockList2Changed));
        when(apiClient.postTask(secondTaskChanged))
            .thenAnswer((_) => Future.value());
        return TaskListBloc(
          mockState2,
          apiClient,
          databaseHelper,
        );
      },
      act: (bloc) {
        bloc.add(TaskListUpdateTask(configuration: secondTaskChanged));
      },
      expect: () => <TaskListState>[mockState2Changed],
    );
    blocTest<TaskListBloc, TaskListState>(
      'Save task',
      build: () {
        when(databaseHelper.insertTask(thirdTask))
            .thenAnswer((_) => Future.value(1));
        when(apiClient.postTask(thirdTask)).thenAnswer((_) => Future.value());
        when(databaseHelper.getTaskList())
            .thenAnswer((_) => Future.value(mockList2));
        when(apiClient.getTaskList())
            .thenAnswer((_) => Future.value(mockList2));
        return TaskListBloc(
          mockState2,
          apiClient,
          databaseHelper,
        );
      },
      act: (bloc) {
        bloc.add(TaskListSaveTask(configuration: thirdTask));
      },
    );
  });
  group(
    'Api client task convert tests',
    () {
      test(
        'Map from task',
        () {
          final serverTask =
              ServerDataConvert.mapFromTask(mockServerTask, deviceId);
          expect(
            serverTask["element"]?["id"],
            mockServerMapTask["element"]?["id"],
          );
          expect(
            serverTask["element"]?["text"],
            mockServerMapTask["element"]?["text"],
          );
          expect(
            serverTask["element"]?["importance"],
            mockServerMapTask["element"]?["importance"],
          );
          expect(
            serverTask["element"]?["deadline"],
            mockServerMapTask["element"]?["deadline"],
          );
          expect(
            serverTask["element"]?["done"],
            mockServerMapTask["element"]?["done"],
          );
          expect(
            serverTask["element"]?["color"],
            mockServerMapTask["element"]?["color"],
          );
          expect(
            serverTask["element"]?["last_updated_by"],
            mockServerMapTask["element"]?["last_updated_by"],
          );
        },
      );

      test(
        'Convert domain task to dto task',
        () {
          final serverTask = ServerDataConvert.mapFromTaskList(
              mockServerTaskListConvert, deviceId);
          for (int i = 0; i < serverTask['list']!.length; i++) {
            expect(
              serverTask["list"]?[i]["id"],
              mockServerTaskMapList["list"]?[i]["id"],
            );
            expect(
              serverTask["list"]?[i]["text"],
              mockServerTaskMapList["list"]?[i]["text"],
            );
            expect(
              serverTask["list"]?[i]["importance"],
              mockServerTaskMapList["list"]?[i]["importance"],
            );
            expect(
              serverTask["list"]?[i]["deadline"],
              mockServerTaskMapList["list"]?[i]["deadline"],
            );
            expect(
              serverTask["list"]?[i]["done"],
              mockServerTaskMapList["list"]?[i]["done"],
            );
            expect(
              serverTask["list"]?[i]["color"],
              mockServerTaskMapList["list"]?[i]["color"],
            );
            expect(
              serverTask["list"]?[i]["last_updated_by"],
              mockServerTaskMapList["list"]?[i]["last_updated_by"],
            );
          }
        },
      );
    },
  );

  group(
    'Database task convert tests',
    () {
      test(
        'Convert map from task',
        () {
          final dbTask = DatabaseDataConvert.mapFromTask(mockDBTask);
          expect(dbTask, mockDBMapTask);
        },
      );

      test(
        'Convert dto task to domain task',
        () {
          final dbTaskList =
              DatabaseDataConvert.taskListFromDatabase(mockDBTaskMapList);
          expect(dbTaskList, mockDBTaskListConvert);
        },
      );
    },
  );
}
