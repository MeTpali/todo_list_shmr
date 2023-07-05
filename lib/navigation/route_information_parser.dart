import 'package:flutter/material.dart';
// import 'package:todo_list_shmr/db/database_helper.dart';
import 'navigation_state.dart';

class Routes {
  static const mainScreen = "";
  static const taskForm = "taskform";
  static const unknown = "unknown";
}

/// URI <> NavigationState
class MyRouteInformationParser extends RouteInformationParser<NavigationState> {
  // final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  @override
  Future<NavigationState> parseRouteInformation(
      RouteInformation routeInformation) async {
    final location = routeInformation.location;

    // TODO logger

    if (location == null) {
      return NavigationState.mainScreen();
    }

    final uri = Uri.parse(location);

    if (uri.pathSegments.length == 1 &&
        uri.pathSegments[0] == Routes.taskForm) {
      return NavigationState.mainScreen();
    }

    return NavigationState.mainScreen();
  }
  // final location = routeInformation.location;
  // if (location == null) {
  //   return NavigationState.unknown();
  // }

  // final uri = Uri.parse(location);

  // if (uri.pathSegments.isEmpty) {
  //   return NavigationState.mainScreen();
  // }

  // if (uri.pathSegments.length == 2) {
  //   final itemId = uri.pathSegments[1];
  //   MainScreenBloc bloc = MainScreenBloc(MainScreenState.inital());
  //   final List<TaskWidgetConfiguration> taskList =
  //       await _databaseHelper.getTaskList();
  //   TaskWidgetConfiguration? config;
  //   if (uri.pathSegments[0] == Routes.taskForm &&
  //       taskList.any((item) {
  //         if (item.id.toString() == itemId) {
  //           config = item;
  //           return true;
  //         } else {
  //           return false;
  //         }
  //       })) {
  //     return NavigationState.changeTaskScreen(itemId, config, bloc);
  //   }

  //   return NavigationState.unknown();
  // }

  // if (uri.pathSegments.length == 1) {
  //   MainScreenBloc bloc = MainScreenBloc(MainScreenState.inital());
  //   if (uri.pathSegments[0] == Routes.taskForm) {
  //     return NavigationState.taskForm(bloc);
  //   }

  //   return NavigationState.unknown();
  // }

  // return NavigationState.mainScreen();

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

  // @override
  // RouteInformation? restoreRouteInformation(NavigationState configuration) {
  //   if (configuration.isTaskForm) {
  //     return const RouteInformation(location: '/${Routes.taskForm}');
  //   }

  //   if (configuration.isChangeTaskScreen) {
  //     return RouteInformation(
  //         location: '/${Routes.taskForm}/${configuration.selectedTaskId}');
  //   }

  //   if (configuration.isUnknown) {
  //     return null;
  //   }

  //   return const RouteInformation(location: '/');
  // }
}
