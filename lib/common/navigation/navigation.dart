import 'package:todo_list_shmr/common/utility/logger/logging.dart';
import 'package:todo_list_shmr/common/navigation/navigation_state.dart';
import 'package:todo_list_shmr/common/navigation/router_delegate.dart';
import 'package:todo_list_shmr/ui/widgets/main_screen/main_screen_widget.dart';
import 'package:todo_list_shmr/ui/widgets/task_form/task_form_widget.dart';
import 'package:todo_list_shmr/ui/widgets/unknown_screen_widget.dart/unknown_screen.dart';

class NavigationManager {
  final MyRouterDelegate _routerDelegate;

  NavigationManager(this._routerDelegate);

  void openPage(NavigationState state) {
    final log = logger(UnknownScreen);
    log.i('open uknown screen');
    _routerDelegate.setNewRoutePath(state);
  }

  void openMainScreen() {
    _routerDelegate.setNewRoutePath(NavigationState.mainScreen());
    final log = logger(MainScreenWidget);
    log.i('open');
  }

  void openTaskForm([int? taskId]) {
    if (taskId == null) {
      final log = logger(TaskFormWidget);
      log.i('open');
    } else {
      final log = logger(TaskFormWidget);
      log.i('open task ($taskId)');
    }
    _routerDelegate.setNewRoutePath(NavigationState.taskForm(taskId));
  }
}
