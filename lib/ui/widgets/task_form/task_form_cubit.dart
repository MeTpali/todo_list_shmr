import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_shmr/task_model/task_config.dart';
import 'package:todo_list_shmr/utility/date.dart';
import 'package:todo_list_shmr/utility/logger/logging.dart';

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
    final log = logger(TaskFormCubit);
    log.i('text update');
    final newConfig = state.configuration
        .copyWith(description: description, date: state.configuration.date);
    emit(state.copyWith(configuration: newConfig));
  }

  void updateRelevance(Relevance relevance) {
    final log = logger(TaskFormCubit);
    log.i('relevance update');
    final newConfig = state.configuration
        .copyWith(relevance: relevance, date: state.configuration.date);
    emit(state.copyWith(configuration: newConfig));
  }

  void updateDate(DateTime? date) {
    final log = logger(TaskFormCubit);
    log.i('date update');
    if (date != null) {
      final newConfig = state.configuration.copyWith(
          date: '${date.day} ${Date.getMonth(date.month)} ${date.year}');
      emit(state.copyWith(configuration: newConfig));
    } else {
      final newConfig = state.configuration.copyWith(date: null);
      emit(state.copyWith(configuration: newConfig));
    }
  }

  void trimDescription() {
    final log = logger(TaskFormCubit);
    log.i('trim description');
    final newConfig = state.configuration
        .copyWith(description: state.configuration.description.trim());
    final newState = state.copyWith(configuration: newConfig);
    emit(newState);
  }
}
