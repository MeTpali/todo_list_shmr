import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_list_shmr/domain/database_helper.dart';
import 'package:todo_list_shmr/domain/api_client.dart';
import 'package:todo_list_shmr/task_model/task_config.dart';
import 'package:todo_list_shmr/utility/logger/logging.dart';

abstract class TaskListEvent {}

class TaskListInit extends TaskListEvent {}

class TaskListUpdate extends TaskListEvent {}

class TaskListUpdateTask extends TaskListEvent {
  TaskWidgetConfiguration configuration;
  TaskListUpdateTask({
    required this.configuration,
  });
}

class TaskListSaveTask extends TaskListEvent {
  TaskWidgetConfiguration configuration;
  TaskListSaveTask({
    required this.configuration,
  });
}

class TaskListDeleteTask extends TaskListEvent {
  String id;
  TaskListDeleteTask({
    required this.id,
  });
}

class TaskListChangeTaskState extends TaskListEvent {
  String id;
  TaskListChangeTaskState({
    required this.id,
  });
}

class TaskListState {
  final List<TaskWidgetConfiguration> tasks;
  final int completedTasks;

  List<TaskWidgetConfiguration> get allTasks => tasks;

  List<TaskWidgetConfiguration> get uncompletedTasks =>
      tasks.where((element) => element.isCompleted == false).toList();

  const TaskListState.inital()
      : tasks = const <TaskWidgetConfiguration>[],
        completedTasks = 0;

  TaskListState({
    required this.tasks,
  }) : completedTasks =
            tasks.where((element) => element.isCompleted == true).length;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskListState &&
          runtimeType == other.runtimeType &&
          completedTasks == other.completedTasks &&
          tasks == other.tasks;

  @override
  int get hashCode => tasks.hashCode ^ completedTasks.hashCode;

  TaskListState copyWith({
    List<TaskWidgetConfiguration>? tasks,
    int? totalPage,
  }) {
    return TaskListState(
      tasks: tasks ?? this.tasks,
    );
  }
}

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final ApiClient _client;
  final DatabaseHelper _databaseHelper;
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  FirebaseAnalytics get analytics => FirebaseAnalytics.instance;
  Color get redColor => Color.fromARGB(
        _remoteConfig.getInt('a_color'),
        _remoteConfig.getInt('r_color'),
        _remoteConfig.getInt('g_color'),
        _remoteConfig.getInt('b_color'),
      );

  TaskListBloc(TaskListState initialState, this._client, this._databaseHelper)
      : super(initialState) {
    on<TaskListEvent>(
      (event, emit) async {
        if (event is TaskListInit) {
          await _onTaskListInit();
        } else if (event is TaskListUpdate) {
          await _onTaskListUpdate(event, emit);
        } else if (event is TaskListDeleteTask) {
          await _onTaskListDeleteTask(event, emit);
          add(TaskListUpdate());
        } else if (event is TaskListChangeTaskState) {
          await _onTaskListChangeTaskState(event, emit);
        } else if (event is TaskListUpdateTask) {
          await _onTaskListUpdateTask(event, emit);
          add(TaskListUpdate());
        } else if (event is TaskListSaveTask) {
          await _onTaskListSaveTask(event, emit);
          add(TaskListUpdate());
        }
      },
      transformer: sequential(),
    );
    add(TaskListInit());
    add(TaskListUpdate());
  }

  Future<void> _onTaskListInit() async {
    final log = logger(TaskListBloc);
    log.i('Firebase init crashlytics');
    FlutterError.onError = (errorDetails) {
      log.e('Caught error in FlutterError.onError');
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      log.e('Caught error in PlatformDispatcher.onError');
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    log.i('Crashlytics initialized');
    log.i('Set up remote config');
    await _remoteConfig.fetchAndActivate();
    log.i('Remote config activated');
  }

  Future<void> _onTaskListUpdate(
    TaskListUpdate event,
    Emitter<TaskListState> emit,
  ) async {
    final log = logger(TaskListBloc);
    log.i('TaskListUpdate event');
    final clientList = await _client.getTaskList();
    final dbList = await _databaseHelper.getTaskList();
    if (clientList != dbList) {
      await _client.patchTaskList(dbList);
    }
    final newTaskList = _sortTaskList(dbList);
    final newState = state.copyWith(tasks: newTaskList);
    emit(newState);
  }

  Future<void> _onTaskListDeleteTask(
    TaskListDeleteTask event,
    Emitter<TaskListState> emit,
  ) async {
    final log = logger(TaskListBloc);
    log.i('TaskListDeleteTask event');
    await _client.deleteTask(event.id);
    int result = await _databaseHelper.deleteTask(event.id);
    if (result == 0) {
      log.e('task with id=${event.id} doesn\'t exist');
    } else {
      List<TaskWidgetConfiguration> newList = state.tasks;
      newList.removeWhere((element) => element.id == event.id);
      final newState = state.copyWith(tasks: newList);
      emit(newState);
      log.i('task deleted (id=${event.id})');
    }
  }

  Future<void> _onTaskListChangeTaskState(
    TaskListChangeTaskState event,
    Emitter<TaskListState> emit,
  ) async {
    final log = logger(TaskListBloc);
    log.i('TaskListChangeTaskState event');
    final index = state.tasks.indexWhere((element) => element.id == event.id);

    List<TaskWidgetConfiguration> newList = state.tasks;
    newList[index] =
        newList[index].copyWith(isCompleted: !newList[index].isCompleted);
    await _databaseHelper.updateTask(newList[index]);
    await _client.updateTask(newList[index]);
    final newState = state.copyWith(tasks: newList);
    emit(newState);
  }

  Future<void> _onTaskListUpdateTask(
    TaskListUpdateTask event,
    Emitter<TaskListState> emit,
  ) async {
    final log = logger(TaskListBloc);
    log.i('TaskListUpdateTask event');
    await _databaseHelper.updateTask(event.configuration);
    final list = await _client.getTaskList();
    bool flag = false;
    for (int i = 0; i < list.length; i++) {
      if (list[i].id == event.configuration.id) {
        flag = true;
      }
    }
    flag
        ? await _client.updateTask(event.configuration)
        : await _client.postTask(event.configuration);
    final newTaskList = state.tasks;
    final index = newTaskList
        .indexWhere((element) => element.id == event.configuration.id);
    newTaskList[index] = event.configuration;
    final newState = state.copyWith(tasks: newTaskList);
    emit(newState);
  }

  Future<void> _onTaskListSaveTask(
    TaskListSaveTask event,
    Emitter<TaskListState> emit,
  ) async {
    final log = logger(TaskListBloc);
    log.i('TaskListUpdateTask event');
    await _databaseHelper.insertTask(event.configuration);
    await _client.postTask(event.configuration);
    final newTaskList = state.tasks;
    newTaskList.add(event.configuration);
    final newState = state.copyWith(tasks: newTaskList);
    emit(newState);
  }

  List<TaskWidgetConfiguration> _sortTaskList(
      List<TaskWidgetConfiguration> list) {
    list.sort((a, b) {
      if (a.relevance == Relevance.high && b.relevance != Relevance.high ||
          a.relevance == Relevance.none && b.relevance == Relevance.low) {
        return -1;
      } else {
        return 1;
      }
    });
    return list;
  }
}
