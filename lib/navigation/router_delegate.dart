import 'package:flutter/material.dart';
import 'package:todo_list_shmr/ui/widgets/main_screen/main_screen_widget.dart';
import 'package:todo_list_shmr/ui/widgets/task_form/task_form_widget.dart';

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
      screens.add(const CircularProgressScreen());
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

class CircularProgressScreen extends StatelessWidget {
  const CircularProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator.adaptive()),
    );
  }
}
