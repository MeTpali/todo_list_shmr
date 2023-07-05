// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_list_shmr/core/task_repository.dart';
import 'package:todo_list_shmr/navigation/navigation.dart';

// import 'package:todo_list_shmr/navigation/navigation.dart';
import 'package:todo_list_shmr/ui/localization/s.dart';
import 'package:todo_list_shmr/ui/theme/theme.dart';
import 'package:todo_list_shmr/ui/widgets/main_screen/main_screen_bloc.dart';
import 'package:todo_list_shmr/ui/widgets/task_row/task_row_widget.dart';

class MainScreenWidget extends StatelessWidget {
  const MainScreenWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final model = _model;
    return BlocProvider(
      create: (_) => MainScreenCubit(TaskListVisibility.visibilityOff),
      child: const MainScreenBody(),
    );
  }
}

class MainScreenBody extends StatefulWidget {
  const MainScreenBody({super.key});

  @override
  State<MainScreenBody> createState() => _MainScreenBodyState();
}

class _MainScreenBodyState extends State<MainScreenBody> {
  @override
  Widget build(BuildContext context) {
    // final funcs = context.read<MainScreenFunctionsProvider>();
    return Scaffold(
      backgroundColor: ToDoListTheme.mainScreenScaffoldColor,
      body: const CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: CustomSliverAppBarDelegate(expandedHeight: 120),
            pinned: true,
          ),
          CompletedWidget(),
          TasksWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: GetIt.I<NavigationManager>().openTaskForm,
        backgroundColor: ToDoListTheme.floatingActionButtonBackgroundColor,
        child: Icon(
          Icons.add,
          color: ToDoListTheme.floatingActionButtonIconColor,
        ),
      ),
    );
  }
}

class CompletedWidget extends StatelessWidget {
  const CompletedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<TaskListBloc>();
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          SizedBox(
            height: 38,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(60, 6, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "${S.of(context).get("done")} — ${bloc.state.completedTasks}",
                        style: TextStyle(
                          color: ToDoListTheme.mainScreenCompletedColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<MainScreenCubit, TaskListVisibility>(
                  builder: (context, state) {
                    return IconButton(
                      padding: const EdgeInsets.only(right: 25),
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        state == TaskListVisibility.visibilityOff
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      color: ToDoListTheme.mainScreenEyeColor,
                      splashColor: Colors.transparent,
                      onPressed: () {
                        final cubit = context.read<MainScreenCubit>();
                        cubit.switchVisibile();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TasksWidget extends StatelessWidget {
  const TasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<TaskListBloc>();
    final cubit = context.watch<MainScreenCubit>();
    // final tasks = cubit.state == TaskListVisibility.visibilityOff
    //     ? bloc.state.uncompletedTasks
    //     : bloc.state.allTasks;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 15),
        child: Material(
          color: ToDoListTheme.mainScreenTaskListColor,
          elevation: 2,
          borderRadius: BorderRadius.circular(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cubit.state == TaskListVisibility.visibilityOff
                    ? bloc.state.uncompletedTasks.length
                    : bloc.state.allTasks.length,
                itemBuilder: (context, index) {
                  final tasks = cubit.state == TaskListVisibility.visibilityOff
                      ? bloc.state.uncompletedTasks
                      : bloc.state.allTasks;
                  return TaskWidget(
                    configuration: tasks[index],
                    first: index == 0,
                  );
                },
              ),
              TextButton(
                onPressed: GetIt.I<NavigationManager>().openTaskForm,
                child: Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Row(
                    children: [
                      Text(
                        S.of(context).get("new"),
                        style: TextStyle(
                          color: ToDoListTheme.mainScreenNewColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> _openTaskForm(MainScreenBloc bloc) async {
  //   bool? update = await NavigationManager.instance.openTaskForm();
  //   if (update != null && update) {
  //     bloc.add(MainScreenTaskListUpdate());
  //   }
  // }
}

class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  const CustomSliverAppBarDelegate({required this.expandedHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        BuildAppBar(shrinkOffset: shrinkOffset, expandedHeight: expandedHeight)
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight + 30;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class BuildAppBar extends StatelessWidget {
  const BuildAppBar(
      {super.key, required this.shrinkOffset, required this.expandedHeight});
  final double shrinkOffset;
  final double expandedHeight;

  double appear(double shrinkOffset) => shrinkOffset < 55 ? 0 : 1;

  @override
  Widget build(BuildContext context) {
    // final bloc = context.watch<MainScreenBloc>();
    return Material(
      color: ToDoListTheme.mainScreenAppBarColor,
      elevation: 4 * shrinkOffset / expandedHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              60 - 44 * shrinkOffset / expandedHeight,
              0,
              0,
              16 * shrinkOffset / expandedHeight,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  S.of(context).get("myBusiness"),
                  style: TextStyle(
                    fontSize: 32 - 12 * shrinkOffset / expandedHeight,
                    fontWeight: FontWeight.bold,
                    color: ToDoListTheme.textColor,
                  ),
                ),
              ],
            ),
          ),
          Opacity(
            opacity: appear(shrinkOffset),
            child: BlocBuilder<MainScreenCubit, TaskListVisibility>(
              builder: (context, state) {
                return IconButton(
                  padding: const EdgeInsets.fromLTRB(0, 0, 19, 14),
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    state == TaskListVisibility.visibilityOff
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  color: ToDoListTheme.mainScreenEyeColor,
                  splashColor: Colors.transparent,
                  onPressed: appear(shrinkOffset) == 1
                      ? () {
                          final cubit = context.read<MainScreenCubit>();
                          cubit.switchVisibile();
                        }
                      // bloc.add(
                      //     MainScreenSwitchCompleted()) // model.changeTaskList(BuildAppBar)
                      : () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// class MainScreenFunctionsProvider {
//   final void Function(MainScreenBloc bloc) onTaskForm;
//   final void Function(String itemId, TaskWidgetConfiguration? configuration,
//       MainScreenBloc bloc) onChangeTask;
//   MainScreenFunctionsProvider({
//     required this.onTaskForm,
//     required this.onChangeTask,
//   });
// }
