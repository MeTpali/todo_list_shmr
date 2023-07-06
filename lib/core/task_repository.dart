import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_list_shmr/domain/database_helper.dart';
import 'package:todo_list_shmr/domain/api_client.dart';
import 'package:todo_list_shmr/task_model/task_configuration.dart';
import 'package:todo_list_shmr/ui/utility/logger/logging.dart';

abstract class TaskListEvent {}

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
          tasks == other.tasks &&
          completedTasks == other.completedTasks;

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
  final _client = ApiClient();
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  TaskListBloc(TaskListState initialState) : super(initialState) {
    on<TaskListEvent>(
      (event, emit) async {
        if (event is TaskListUpdate) {
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
    add(TaskListUpdate());
  }

  Future<void> _onTaskListUpdate(
    TaskListUpdate event,
    Emitter<TaskListState> emit,
  ) async {
    final log = logger(TaskListBloc);
    log.i('TaskListUpdate event');
    final clientList = await _client.getTaskList();
    await _databaseHelper.initializeDatabase();
    final dbList = await _databaseHelper.getTaskList();
    if (clientList != dbList) {
      await _client.patchTaskList(dbList);
    }
    final newTaskList = dbList;
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
    newList[index].isCompleted = !newList[index].isCompleted;

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
}
