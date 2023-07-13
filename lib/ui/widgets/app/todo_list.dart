import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_list_shmr/common/core/task_repository.dart';
import 'package:todo_list_shmr/common/domain/api_client.dart';
import 'package:todo_list_shmr/common/domain/database_helper.dart';
import 'package:todo_list_shmr/common/navigation/navigation.dart';
import 'package:todo_list_shmr/common/navigation/route_information_parser.dart';
import 'package:todo_list_shmr/common/navigation/router_delegate.dart';
import 'package:todo_list_shmr/ui/utility/localization/s.dart';

class TodoList extends StatelessWidget {
  final _routerDelegate = MyRouterDelegate();
  final _routeInformationParser = MyRouteInformationParser();
  final _apiClient = ApiClient();
  final _databaseHelper = DatabaseHelper.instance;

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
      create: (_) => TaskListBloc(
        const TaskListState.inital(),
        _apiClient,
        _databaseHelper,
      ),
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
