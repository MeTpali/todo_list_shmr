import 'package:flutter_bloc/flutter_bloc.dart';

enum TaskListVisibility { visibilityOn, visibilityOff }

class MainScreenCubit extends Cubit<TaskListVisibility> {
  MainScreenCubit(TaskListVisibility initialState) : super(initialState);

  void switchVisibile() {
    // TODO logger
    final newVisible = state == TaskListVisibility.visibilityOn
        ? TaskListVisibility.visibilityOff
        : TaskListVisibility.visibilityOn;
    emit(newVisible);
  }
}

// import 'package:bloc_concurrency/bloc_concurrency.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:todo_list_shmr/db/database_helper.dart';
// import 'package:todo_list_shmr/domain/api_client/api_client.dart';
// import 'package:todo_list_shmr/ui/widgets/task_row/task_row_widget.dart';

// abstract class MainScreenEvent {}

// class MainScreenTaskListUpdate extends MainScreenEvent {}

// class MainScreenDeleteTask extends MainScreenEvent {
//   int id;
//   MainScreenDeleteTask({
//     required this.id,
//   });
// }

// class MainScreenChangeTaskState extends MainScreenEvent {
//   int id;
//   MainScreenChangeTaskState({
//     required this.id,
//   });
// }

// class MainScreenSwitchCompleted extends MainScreenEvent {}

// class TaskListContainer {
//   final List<TaskWidgetConfiguration> tasks;
//   // TODO = 0?
//   final int completedTasks;

//   const TaskListContainer.inital()
//       : tasks = const <TaskWidgetConfiguration>[],
//         completedTasks = 0;

//   TaskListContainer({
//     required this.tasks,
//     required this.completedTasks,
//   });

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is TaskListContainer &&
//           runtimeType == other.runtimeType &&
//           tasks == other.tasks &&
//           completedTasks == other.completedTasks;

//   @override
//   int get hashCode => tasks.hashCode ^ completedTasks.hashCode;

//   TaskListContainer copyWith({
//     List<TaskWidgetConfiguration>? tasks,
//     int? completedTasks,
//     int? totalPage,
//   }) {
//     return TaskListContainer(
//       tasks: tasks ?? this.tasks,
//       completedTasks: completedTasks ?? this.completedTasks,
//     );
//   }
// }

// class MainScreenState {
//   final TaskListContainer taskListContainer;
//   final bool showCompleted;

//   //TODO
//   // bool get isSearchMode => showCompleted.isNotEmpty;
//   List<TaskWidgetConfiguration> get taskList => showCompleted
//       ? taskListContainer.tasks
//       : taskListContainer.tasks
//           .where((element) => element.isCompleted == false)
//           .toList();

//   const MainScreenState.inital()
//       : taskListContainer = const TaskListContainer.inital(),
//         showCompleted = false;

//   MainScreenState({
//     required this.taskListContainer,
//     required this.showCompleted,
//   });

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is MainScreenState &&
//           runtimeType == other.runtimeType &&
//           taskListContainer == other.taskListContainer &&
//           showCompleted == other.showCompleted;

//   @override
//   int get hashCode => taskListContainer.hashCode ^ showCompleted.hashCode;

//   MainScreenState copyWith({
//     TaskListContainer? taskListContainer,
//     bool? showCompleted,
//   }) {
//     return MainScreenState(
//       taskListContainer: taskListContainer ?? this.taskListContainer,
//       showCompleted: showCompleted ?? this.showCompleted,
//     );
//   }
// }

// class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
//   final _client = ApiClient();
//   final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

//   MainScreenBloc(MainScreenState initialState) : super(initialState) {
//     on<MainScreenEvent>(
//       (event, emit) async {
//         if (event is MainScreenTaskListUpdate) {
//           await _onTaskListUpdate(event, emit);
//         } else if (event is MainScreenDeleteTask) {
//           await _onTaskListDeleteTask(event, emit);
//           add(MainScreenTaskListUpdate());
//         } else if (event is MainScreenChangeTaskState) {
//           await _onTaskListChangeTaskState(event, emit);
//         } else if (event is MainScreenSwitchCompleted) {
//           bool newCompleted = !state.showCompleted;
//           final newState = state.copyWith(showCompleted: newCompleted);
//           emit(newState);
//         }
//       },
//       transformer: sequential(),
//     );
//     add(MainScreenTaskListUpdate());
//   }

//   Future<void> _onTaskListUpdate(
//     MainScreenTaskListUpdate event,
//     Emitter<MainScreenState> emit,
//   ) async {
//     final clientList = await _client.getTaskList();
//     await _databaseHelper.initializeDatabase();
//     final dbList = await _databaseHelper.getTaskList();
//     if (clientList != dbList) {
//       await _client.patchTaskList(dbList);
//     }
//     final newTaskList = dbList;
//     newTaskList.sort((a, b) => a.id.compareTo(b.id));
//     int newCompletedTasks = 0;
//     for (var e in newTaskList) {
//       if (e.isCompleted) {
//         newCompletedTasks++;
//       }
//     }
//     final newContainer = TaskListContainer(
//         tasks: newTaskList, completedTasks: newCompletedTasks);
//     final newState = state.copyWith(taskListContainer: newContainer);
//     emit(newState);
//     // TODO
//     // final log = logger(type);
//     // log.i('task list updated');
//   }

//   Future<void> _onTaskListDeleteTask(
//     MainScreenDeleteTask event,
//     Emitter<MainScreenState> emit,
//   ) async {
//     // TODO
//     // final log = logger(type);
//     // updateTaskList(type);
//     await _client.deleteTask(event.id);
//     int result = await _databaseHelper.deleteTask(event.id);
//     if (result == 0) {
//       // log.e('error on task delete');
//     } else {
//       List<TaskWidgetConfiguration> newList = state.taskListContainer.tasks;
//       int newCompletedTasks = state.taskListContainer.completedTasks;
//       newList.removeWhere((element) {
//         if (element.id == event.id) {
//           if (element.isCompleted) {
//             newCompletedTasks--;
//           }
//           return true;
//         } else {
//           return false;
//         }
//       });
//       final newContainer = state.taskListContainer
//           .copyWith(tasks: newList, completedTasks: newCompletedTasks);
//       final newState = state.copyWith(taskListContainer: newContainer);
//       emit(newState);
//       // TODO
//       // log.i('task deleted (id=$id)');
//       // updateTaskList(type);
//     }
//   }

//   Future<void> _onTaskListChangeTaskState(
//     MainScreenChangeTaskState event,
//     Emitter<MainScreenState> emit,
//   ) async {
//     final index = state.taskListContainer.tasks
//         .indexWhere((element) => element.id == event.id);

//     int newCompletedTasks = state.taskListContainer.completedTasks;
//     state.taskListContainer.tasks[index].isCompleted
//         ? newCompletedTasks--
//         : newCompletedTasks++;

//     List<TaskWidgetConfiguration> newList = state.taskListContainer.tasks;
//     newList[index].isCompleted = !newList[index].isCompleted;

//     await _databaseHelper.updateTask(newList[index]);
//     await _client.updateTask(newList[index]);

//     final newContainer =
//         TaskListContainer(tasks: newList, completedTasks: newCompletedTasks);
//     final newState = state.copyWith(taskListContainer: newContainer);
//     emit(newState);
//     // TODO
//     // final log = logger(type);
//     // log.i('task[$index] isCompleted changed');
//   }
// }
