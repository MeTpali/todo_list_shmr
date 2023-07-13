import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_shmr/ui/utility/logger/logging.dart';

enum TaskListVisibility { visibilityOn, visibilityOff }

class MainScreenCubit extends Cubit<TaskListVisibility> {
  MainScreenCubit(TaskListVisibility initialState) : super(initialState);

  void switchVisibile() {
    final log = logger(MainScreenCubit);
    log.i('switch visibility');
    final newVisible = state == TaskListVisibility.visibilityOn
        ? TaskListVisibility.visibilityOff
        : TaskListVisibility.visibilityOn;
    emit(newVisible);
  }
}
