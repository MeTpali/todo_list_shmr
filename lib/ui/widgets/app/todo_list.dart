import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_list_shmr/core/task_repository.dart';
import 'package:todo_list_shmr/navigation/navigation.dart';
import 'package:todo_list_shmr/navigation/route_information_parser.dart';
import 'package:todo_list_shmr/navigation/router_delegate.dart';
import 'package:todo_list_shmr/ui/utility/localization/s.dart';

class TodoList extends StatelessWidget {
  final _routerDelegate = MyRouterDelegate();
  final _routeInformationParser = MyRouteInformationParser();

  TodoList({super.key}) {
    if (!GetIt.I.isRegistered<NavigationManager>()) {
      GetIt.I.registerSingleton<NavigationManager>(
          NavigationManager(_routerDelegate));
    }
  }

  @override
  Widget build(BuildContext context) {
    final brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return BlocProvider<TaskListBloc>(
      create: (_) => TaskListBloc(const TaskListState.inital()),
      child: MaterialApp.router(
        localizationsDelegates: S.localizationsDelegates,
        supportedLocales: S.supportedLocales,
        debugShowCheckedModeBanner: false,
        theme: brightness == Brightness.light
            ? ThemeData.light()
            : ThemeData.dark(),
        title: "ToDoListSHMR",
        routerDelegate: _routerDelegate,
        routeInformationParser: _routeInformationParser,
      ),
    );
  }
}
