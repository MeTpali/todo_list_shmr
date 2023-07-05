import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_list_shmr/ui/widgets/task_form/date.dart';
import 'package:todo_list_shmr/ui/widgets/task_row/task_row_widget.dart';

class TaskFormState {
  TaskWidgetConfiguration configuration;
  bool isChanging;
  TaskFormState({
    required this.configuration,
    required this.isChanging,
  });

  TaskFormState copyWith({
    TaskWidgetConfiguration? configuration,
    bool? isChanging,
  }) {
    return TaskFormState(
      configuration: configuration ?? this.configuration,
      isChanging: isChanging ?? this.isChanging,
    );
  }

  @override
  bool operator ==(covariant TaskFormState other) {
    if (identical(this, other)) return true;

    return other.configuration == configuration &&
        other.isChanging == isChanging;
  }

  @override
  int get hashCode => configuration.hashCode ^ isChanging.hashCode;
}

class TaskFormCubit extends Cubit<TaskFormState> {
  TaskFormCubit(TaskFormState initialState) : super(initialState);

  void updateText(String description) {
    final newConfig = state.configuration
        .copyWith(description: description, date: state.configuration.date);
    emit(state.copyWith(configuration: newConfig));
  }

  void updateRelevance(Relevance relevance) {
    final newConfig = state.configuration
        .copyWith(relevance: relevance, date: state.configuration.date);
    emit(state.copyWith(configuration: newConfig));
  }

  void updateDate(DateTime? date) {
    if (date != null) {
      final newConfig = state.configuration.copyWith(
          date: '${date.day} ${Date.getMonth(date.month)} ${date.year}');
      emit(state.copyWith(configuration: newConfig));
    } else {
      final newConfig = state.configuration.copyWith(date: null);
      emit(state.copyWith(configuration: newConfig));
    }
  }
}

// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:bloc_concurrency/bloc_concurrency.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:todo_list_shmr/db/database_helper.dart';
// import 'package:todo_list_shmr/domain/api_client/api_client.dart';
// // import 'package:todo_list_shmr/navigation/navigation.dart';
// import 'package:todo_list_shmr/ui/widgets/task_form/date.dart';
// import 'package:todo_list_shmr/ui/widgets/task_row/task_row_widget.dart';

// abstract class TaskFormEvent {}

// class TaskFormPickDate extends TaskFormEvent {
//   DateTime? date;
//   TaskFormPickDate({
//     required this.date,
//   });
// }

// class TaskFormPickRelevance extends TaskFormEvent {
//   Relevance relevance;
//   TaskFormPickRelevance({
//     required this.relevance,
//   });
// }

// class TaskFormUpdateDescription extends TaskFormEvent {
//   String description;
//   TaskFormUpdateDescription({
//     required this.description,
//   });
// }

// class TaskFormDeleteTask extends TaskFormEvent {}

// class TaskFormSaveTask extends TaskFormEvent {}

// class TaskFormUpdateTask extends TaskFormEvent {}

// class TaskFormState {
//   final int id;
//   final bool isCompleted;
//   final String taskDescription;
//   final Relevance relevance;
//   final String? date;
//   final bool isChanging;

//   const TaskFormState.initial()
//       : id = 0,
//         isCompleted = false,
//         taskDescription = '',
//         relevance = Relevance.none,
//         isChanging = false,
//         date = null;

//   TaskFormState({
//     required this.id,
//     required this.isCompleted,
//     required this.taskDescription,
//     required this.relevance,
//     required this.date,
//     required this.isChanging,
//   });

//   TaskFormState copyWith({
//     int? id,
//     bool? isCompleted,
//     String? taskDescription,
//     Relevance? relevance,
//     bool? isDated,
//     String? date,
//     bool? isChanging,
//   }) {
//     return TaskFormState(
//       id: id ?? this.id,
//       isCompleted: isCompleted ?? this.isCompleted,
//       taskDescription: taskDescription ?? this.taskDescription,
//       relevance: relevance ?? this.relevance,
//       isChanging: isChanging ?? this.isChanging,
//       date: id != null ||
//               isCompleted != null ||
//               taskDescription != null ||
//               relevance != null
//           ? this.date
//           : date,
//     );
//   }

//   @override
//   bool operator ==(covariant TaskFormState other) {
//     if (identical(this, other)) return true;

//     return other.id == id &&
//         other.isCompleted == isCompleted &&
//         other.taskDescription == taskDescription &&
//         other.relevance == relevance &&
//         other.date == date &&
//         other.isChanging == isChanging;
//   }

//   @override
//   int get hashCode {
//     return id.hashCode ^
//         isCompleted.hashCode ^
//         taskDescription.hashCode ^
//         relevance.hashCode ^
//         date.hashCode ^
//         isChanging.hashCode;
//   }
// }

// class TaskFormBloc extends Bloc<TaskFormEvent, TaskFormState> {
//   final _client = ApiClient();
//   final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

//   TaskFormBloc(TaskFormState initialState) : super(initialState) {
//     on<TaskFormEvent>(
//       (event, emit) {
//         if (event is TaskFormPickDate) {
//           _onTaskFormPickDate(event, emit);
//         } else if (event is TaskFormPickRelevance) {
//           _onTaskFormPickRelevance(event, emit);
//         } else if (event is TaskFormUpdateDescription) {
//           _onTaskFormUpdateDescription(event, emit);
//         } else if (event is TaskFormDeleteTask) {
//           _onTaskFormDeleteTask();
//         } else if (event is TaskFormSaveTask) {
//           _onTaskFormSaveTask();
//         } else if (event is TaskFormUpdateTask) {
//           _onTaskFormUpdateTask();
//         }
//       },
//       transformer: sequential(),
//     );
//   }

//   void _onTaskFormUpdateDescription(
//     TaskFormUpdateDescription event,
//     Emitter<TaskFormState> emit,
//   ) {
//     final newState = state.copyWith(taskDescription: event.description);
//     emit(newState);
//   }

//   void _onTaskFormPickDate(
//     TaskFormPickDate event,
//     Emitter<TaskFormState> emit,
//   ) {
//     final newState = state.copyWith(
//       date: event.date == null
//           ? null
//           : '${event.date!.day} ${Date.getMonth(event.date!.month)} ${event.date!.year}',
//     );

//     emit(newState);
//   }

//   void _onTaskFormPickRelevance(
//     TaskFormPickRelevance event,
//     Emitter<TaskFormState> emit,
//   ) {
//     final newState = state.copyWith(relevance: event.relevance);
//     emit(newState);
//   }

//   void _onTaskFormDeleteTask() async {
//     await _client.deleteTask(state.id);
//     int result = await _databaseHelper.deleteTask(state.id);
//     if (result == 0) {}
//     // NavigationManager.instance.saveTask(true);
//   }

//   Future<void> _onTaskFormSaveTask() async {
//     // TODO
//     // final log = logger(type);
//     // log.i('task saved');
//     await _databaseHelper.insertTask(
//       TaskWidgetConfiguration(
//         id: state.id,
//         isCompleted: state.isCompleted,
//         relevance: state.relevance,
//         description: state.taskDescription,
//         date: state.date,
//       ),
//     );
//     final taskList = await _databaseHelper.getTaskList();
//     int minId = 0;
//     for (int i = 0; i < taskList.length; i++) {
//       minId < taskList[i].id ? minId = taskList[i].id : minId;
//     }
//     await _client.postTask(
//       TaskWidgetConfiguration(
//         id: minId + 1,
//         isCompleted: state.isCompleted,
//         relevance: state.relevance,
//         description: state.taskDescription,
//         date: state.date,
//       ),
//     );
//     // NavigationManager.instance.saveTask(true);
//   }

//   Future<void> _onTaskFormUpdateTask() async {
//     // TODO
//     // final log = logger(type);
//     // log.i('task updated');
//     await _databaseHelper.updateTask(
//       TaskWidgetConfiguration(
//         id: state.id,
//         isCompleted: state.isCompleted,
//         relevance: state.relevance,
//         description: state.taskDescription,
//         date: state.date,
//       ),
//     );
//     final list = await _client.getTaskList();
//     bool flag = false;
//     for (int i = 0; i < list.length; i++) {
//       if (list[i].id == state.id) {
//         flag = true;
//       }
//     }
//     flag
//         ? await _client.updateTask(
//             TaskWidgetConfiguration(
//               id: state.id,
//               isCompleted: state.isCompleted,
//               relevance: state.relevance,
//               description: state.taskDescription,
//               date: state.date,
//             ),
//           )
//         : await _client.postTask(
//             TaskWidgetConfiguration(
//               id: state.id,
//               isCompleted: state.isCompleted,
//               relevance: state.relevance,
//               description: state.taskDescription,
//               date: state.date,
//             ),
//           );
//     // NavigationManager.instance.saveTask(false);
//   }
// }
