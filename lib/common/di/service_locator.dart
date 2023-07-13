// import 'package:todo_list_shmr/common/domain/api_client.dart';
// import 'package:todo_list_shmr/common/domain/database_helper.dart';
// import 'package:todo_list_shmr/common/navigation/route_information_parser.dart';
// import 'package:todo_list_shmr/common/navigation/router_delegate.dart';

// class ServiceLocator {
//   final _apiClient = ApiClient();
//   final _localDatabase = DatabaseHelper();
//   final _routerDelegate = MyRouterDelegate();
//   final _routeInformationParser = MyRouteInformationParser();
//   ServiceLocator() {
//     remoteConfig = RemoteConfigService();
//     final _apiClient = ApiClient();
//     final _localDatabase = DatabaseHelper();
//     final _routerDelegate = MyRouterDelegate();
//     final _routeInformationParser = MyRouteInformationParser();

//     final taskNetworkRepository = TaskNetworkRepository(networkTaskBackend);
//     final taskLocalRepository = TaskLocalRepository(localStorageApi);
//     final taskConnectRepository = TaskConnectRepository(
//         taskLocalRepository: taskLocalRepository,
//         taskNetworkRepository: taskNetworkRepository);
//     bloc = TaskListBloc(taskRepository: taskConnectRepository)
//       ..add(const GetListEvent());

//     appNavigator = AppNavigator(
//       task: null,
//       //Task.initial(),
//       tasksStream: bloc.state.when(
//         loaded: (list) => BehaviorSubject.seeded(list),
//         loading: () => BehaviorSubject.seeded([]),
//         error: (_) => BehaviorSubject.seeded([]),
//       ),
//     );
//     register();
//   }

//   void register() {
//     getIt.registerSingleton<DatabaseHelper>(_localDatabase);
//     getIt.registerSingleton<ApiClient>(_apiClient);
//     getIt.registerSingleton<MyRouterDelegate>(_routerDelegate);
//   }
// }
