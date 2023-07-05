import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_list_shmr/db/database_helper.dart';
import 'package:todo_list_shmr/domain/api_client/api_client.dart';
import 'package:todo_list_shmr/ui/widgets/task_row/task_row_widget.dart';

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
    final clientList = await _client.getTaskList();
    await _databaseHelper.initializeDatabase();
    final dbList = await _databaseHelper.getTaskList();
    if (clientList != dbList) {
      await _client.patchTaskList(dbList);
    }
    final newTaskList = dbList;
    final newState = state.copyWith(tasks: newTaskList);
    emit(newState);
    // TODO
    // final log = logger(type);
    // log.i('task list updated');
  }

  Future<void> _onTaskListDeleteTask(
    TaskListDeleteTask event,
    Emitter<TaskListState> emit,
  ) async {
    // TODO
    // final log = logger(type);
    // updateTaskList(type);
    await _client.deleteTask(event.id);
    int result = await _databaseHelper.deleteTask(event.id);
    if (result == 0) {
      // log.e('error on task delete');
    } else {
      List<TaskWidgetConfiguration> newList = state.tasks;
      newList.removeWhere((element) => element.id == event.id);
      final newState = state.copyWith(tasks: newList);
      emit(newState);
      // TODO
      // log.i('task deleted (id=$id)');
      // updateTaskList(type);
    }
  }

  Future<void> _onTaskListChangeTaskState(
    TaskListChangeTaskState event,
    Emitter<TaskListState> emit,
  ) async {
    final index = state.tasks.indexWhere((element) => element.id == event.id);

    List<TaskWidgetConfiguration> newList = state.tasks;
    newList[index].isCompleted = !newList[index].isCompleted;

    await _databaseHelper.updateTask(newList[index]);
    await _client.updateTask(newList[index]);

    final newState = state.copyWith(tasks: newList);
    emit(newState);
    // TODO
    // final log = logger(type);
    // log.i('task[$index] isCompleted changed');
  }

  Future<void> _onTaskListUpdateTask(
    TaskListUpdateTask event,
    Emitter<TaskListState> emit,
  ) async {
    // TODO
    // final log = logger(type);
    // log.i('task updated');
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
    // NavigationManager.instance.saveTask(false);
  }

  Future<void> _onTaskListSaveTask(
    TaskListSaveTask event,
    Emitter<TaskListState> emit,
  ) async {
    // TODO
    // final log = logger(type);
    // log.i('task saved');
    await _databaseHelper.insertTask(event.configuration);
    await _client.postTask(event.configuration);
    final newTaskList = state.tasks;
    newTaskList.add(event.configuration);
    final newState = state.copyWith(tasks: newTaskList);
    emit(newState);
  }
}
