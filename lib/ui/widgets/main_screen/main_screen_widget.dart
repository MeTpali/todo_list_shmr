import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_list_shmr/core/task_repository.dart';
import 'package:todo_list_shmr/navigation/navigation.dart';
import 'package:todo_list_shmr/utility/localization/s.dart';

import 'package:todo_list_shmr/ui/theme/theme.dart';
import 'package:todo_list_shmr/ui/widgets/main_screen/main_screen_cubit.dart';
import 'package:todo_list_shmr/ui/widgets/task_row/task_row_widget.dart';

class MainScreenWidget extends StatelessWidget {
  const MainScreenWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainScreenCubit(TaskListVisibility.visibilityOff),
      child: const _MainScreenBody(),
    );
  }
}

class _MainScreenBody extends StatefulWidget {
  const _MainScreenBody();

  @override
  State<_MainScreenBody> createState() => _MainScreenBodyState();
}

class _MainScreenBodyState extends State<_MainScreenBody> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TaskListBloc>();
    return Scaffold(
      backgroundColor: ToDoListTheme.mainScreenScaffoldColor,
      body: const CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: _CustomSliverAppBarDelegate(expandedHeight: 120),
            pinned: true,
          ),
          _CompletedWidget(),
          _TasksWidget(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await bloc.analytics.logEvent(name: 'open_task_form');
          GetIt.I<NavigationManager>().openTaskForm();
        },
        backgroundColor: ToDoListTheme.floatingActionButtonBackgroundColor,
        child: Icon(
          Icons.add,
          color: ToDoListTheme.floatingActionButtonIconColor,
        ),
      ),
    );
  }
}

class _CompletedWidget extends StatelessWidget {
  const _CompletedWidget();

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

class _TasksWidget extends StatelessWidget {
  const _TasksWidget();

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<TaskListBloc>();
    final cubit = context.watch<MainScreenCubit>();
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
                onPressed: () async {
                  await bloc.analytics.logEvent(name: 'open_task_form');
                  GetIt.I<NavigationManager>().openTaskForm();
                },
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
}

class _CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  const _CustomSliverAppBarDelegate({required this.expandedHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        _BuildAppBar(shrinkOffset: shrinkOffset, expandedHeight: expandedHeight)
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

class _BuildAppBar extends StatelessWidget {
  const _BuildAppBar(
      {required this.shrinkOffset, required this.expandedHeight});
  final double shrinkOffset;
  final double expandedHeight;

  double appear(double shrinkOffset) => shrinkOffset < 55 ? 0 : 1;

  @override
  Widget build(BuildContext context) {
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
                      : null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
