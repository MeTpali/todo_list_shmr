import 'package:flutter/material.dart';
import 'package:todo_list_shmr/ui/utility/logger/logging.dart';
import 'package:todo_list_shmr/ui/widgets/main_screen/main_screen_widget.dart';
import 'package:todo_list_shmr/ui/widgets/task_form/task_form_widget.dart';
import 'navigation_state.dart';

class Routes {
  static const mainScreen = "";
  static const taskForm = "taskform";
  static const unknown = "unknown";
}

class MyRouteInformationParser extends RouteInformationParser<NavigationState> {
  @override
  Future<NavigationState> parseRouteInformation(
      RouteInformation routeInformation) async {
    final location = routeInformation.location;

    if (location == null) {
      final log = logger(MainScreenWidget);
      log.i('open');
      return NavigationState.mainScreen();
    }

    final uri = Uri.parse(location);

    if (uri.pathSegments.length == 1 &&
        uri.pathSegments[0] == Routes.taskForm) {
      final log = logger(TaskFormWidget);
      log.i('open');
      return NavigationState.taskForm(null);
    }

    return NavigationState.mainScreen();
  }

  @override
  RouteInformation? restoreRouteInformation(NavigationState configuration) {
    if (configuration.isTaskForm) {
      return const RouteInformation(location: '/${Routes.taskForm}');
    }

    if (configuration.isUnknown) {
      return null;
    }

    return const RouteInformation(location: '/');
  }
}
