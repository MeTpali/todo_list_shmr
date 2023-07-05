import 'package:flutter/material.dart';
import 'package:todo_list_shmr/ui/widgets/main_screen/main_screen_widget.dart';
import 'package:todo_list_shmr/ui/widgets/task_form/task_form_widget.dart';
// import 'package:todo_list_shmr/ui/widgets/task_form/task_form_widget.dart';
import 'package:todo_list_shmr/ui/widgets/unknown_screen_widget.dart/unknown_screen.dart';

import 'navigation_state.dart';

class MyRouterDelegate extends RouterDelegate<NavigationState>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<NavigationState> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  MyRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  NavigationState? _state;

  @override
  NavigationState get currentConfiguration {
    return _state ?? NavigationState.mainScreen();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [];

    if (_state == null) {
      screens.add(const UnknownScreen());
    } else if (_state != null) {
      screens.add(const MainScreenWidget());

      if (_state!.isTaskForm) {
        screens.add(TaskFormWidget(taskId: _state!.selectedTaskId));
      }
    }

    return Navigator(
      key: navigatorKey,
      pages: screens.map<Page>((page) => MaterialPage(child: page)).toList(),
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;

        _state = NavigationState.mainScreen();

        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(NavigationState configuration) async {
    _state = configuration;
    notifyListeners();
  }
}

// class MyRouterDelegate extends RouterDelegate<NavigationState>
//     with ChangeNotifier, PopNavigatorRouterDelegateMixin<NavigationState> {
//   @override
//   final GlobalKey<NavigatorState> navigatorKey;

//   MyRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

//   NavigationState? state;

//   @override
//   NavigationState get currentConfiguration {
//     return state ?? NavigationState.mainScreen();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Navigator(
//       key: navigatorKey,
//       pages: [
//         // if (state?.isMainScreen == true)
//         MaterialPage(
//           child: MainScreenWidget(
//             onChangeTask: _changeTask,
//             onTaskForm: _showTaskForm,
//           ),
//         ),
//         if (state?.isTaskForm == true || state?.isChangeTaskScreen == true)
//           MaterialPage(
//             child: TaskFormWidget(
//               onMainScreen: _returnToMainScreen,
//               config: state!.configuration,
//               bloc: state!.bloc!,
//             ),
//           ),
//         if (state?.isUnknown == true)
//           const MaterialPage(
//             child: UnknownPage(),
//           ),
//       ],
//       onPopPage: (route, result) {
//         if (!route.didPop(result)) {
//           return true;
//         }

//         state = NavigationState.mainScreen();

//         notifyListeners();
//         return true;
//       },
//     );
//   }

//   @override
//   Future<void> setNewRoutePath(NavigationState configuration) async {
//     state = configuration;
//     notifyListeners();
//   }

//   void _changeTask(
//       String itemId, TaskWidgetConfiguration? config, MainScreenBloc bloc) {
//     state = NavigationState.changeTaskScreen(itemId, config, bloc);
//     notifyListeners();
//   }

//   void _showTaskForm(MainScreenBloc bloc) {
//     state = NavigationState.taskForm(bloc);
//     notifyListeners();
//   }

//   void _returnToMainScreen() {
//     state = NavigationState.mainScreen();
//     notifyListeners();
//   }
// }