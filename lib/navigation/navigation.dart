// import 'package:logger/logger.dart';
import 'package:todo_list_shmr/navigation/navigation_state.dart';
// import 'package:todo_list_shmr/navigation/route_information_parser.dart';
import 'package:todo_list_shmr/navigation/router_delegate.dart';

class NavigationManager {
  // TODO add loggers
  final MyRouterDelegate _routerDelegate;

  NavigationManager(this._routerDelegate);

  void openPage(NavigationState state) {
    _routerDelegate.setNewRoutePath(state);
  }

  void openMainScreen() {
    _routerDelegate.setNewRoutePath(NavigationState.mainScreen());
  }

  void openTaskForm([int? taskId]) {
    if (taskId == null) {
      //logger
    } else {
//logger
    }
    _routerDelegate.setNewRoutePath(NavigationState.taskForm(taskId));
  }
}

// import 'package:flutter/material.dart';

// import '../ui/widgets/task_row/task_row_widget.dart';
// import 'observer.dart';
// import 'routes.dart';

// class NavigationManager {
//   NavigationManager._();

//   static final instance = NavigationManager._();

//   final key = GlobalKey<NavigatorState>();

//   final observers = <NavigatorObserver>[
//     NavigationLogger(),
//   ];

//   NavigatorState get _navigator => key.currentState!;

//   // void openTaskForm() {
//   //   _navigator.pushNamed(RouteNames.taskForm);
//   // }

//   Future<bool?> openInfo(TaskWidgetConfiguration? configuration) {
//     return _navigator.pushNamed<bool?>(
//       RouteNames.taskForm,
//       arguments: configuration,
//     );
//   }

//   Future<bool?> openTaskForm() {
//     return _navigator.pushNamed<bool?>(
//       RouteNames.taskForm,
//     );
//   }

//   void maybePop<T extends Object>([T? result]) {
//     _navigator.maybePop(result);
//   }

//   void pop<T extends Object>() {
//     _navigator.pop();
//   }

//   void saveTask<T extends Object>([T? result]) {
//     _navigator.pop(result);
//   }

//   void popToHome() {
//     _navigator.popUntil(ModalRoute.withName(RouteNames.home));
//   }
// }
