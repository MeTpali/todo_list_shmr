// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
// import 'package:todo_list_shmr/common/converters/server_convert.dart';
import 'package:todo_list_shmr/common/core/task_repository.dart';
import 'package:todo_list_shmr/common/navigation/navigation.dart';
import 'package:todo_list_shmr/common/task_model/task_configuration.dart';

import 'package:todo_list_shmr/ui/theme/theme.dart';

class TaskWidget extends StatelessWidget {
  final TaskWidgetConfiguration configuration;
  final bool first;
  const TaskWidget({
    Key? key,
    required this.configuration,
    required this.first,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TaskListBloc>();
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: first ? const Radius.circular(10) : Radius.zero,
        topRight: first ? const Radius.circular(10) : Radius.zero,
      ),
      child: Dismissible(
        background: const _BackgroundWidget(),
        secondaryBackground: const _SecondaryBackgroundWidget(),
        key: ValueKey(configuration.id),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            bloc.analytics.logEvent(
              name: 'complete_task',
              parameters: {'id': configuration.id},
            );
            bloc.add(TaskListChangeTaskState(id: configuration.id));
            return false;
          } else {
            await bloc.analytics.logEvent(
              name: 'delete_from_main_screen',
              parameters: {'id': configuration.id},
            );
            bloc.add(TaskListDeleteTask(id: configuration.id));
            return false;
          }
        },
        movementDuration: Duration.zero,
        child: _TaskWidget(configuration: configuration),
      ),
    );
  }
}

class _BackgroundWidget extends StatelessWidget {
  const _BackgroundWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.greenAccent,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 27),
          Icon(
            Icons.check,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}

class _SecondaryBackgroundWidget extends StatelessWidget {
  const _SecondaryBackgroundWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.redAccent,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          SizedBox(width: 27),
        ],
      ),
    );
  }
}

class _TaskWidget extends StatelessWidget {
  const _TaskWidget({
    required this.configuration,
  });

  final TaskWidgetConfiguration configuration;

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<TaskListBloc>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(19, 15, 0, 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            configuration.isCompleted
                ? Icons.check_box
                : Icons.check_box_outline_blank,
            color: configuration.isCompleted
                ? ToDoListTheme.taskRowCheckBoxCompletedColor
                : configuration.relevance == Relevance.high
                    ? bloc.redColor
                    : ToDoListTheme.taskRowCheckBoxSimpleColor,
          ),
          SizedBox(
            width: configuration.relevance == Relevance.high ? 10 : 15,
          ),
          if (configuration.relevance == Relevance.high)
            const SizedBox(
              width: 10,
              child: Icon(
                Icons.priority_high_rounded,
                color: Colors.red,
              ),
            ),
          if (configuration.relevance == Relevance.high)
            const Icon(
              Icons.priority_high_rounded,
              color: Colors.red,
            ),
          if (configuration.relevance == Relevance.low)
            Icon(
              Icons.arrow_downward_rounded,
              color: ToDoListTheme.taskRowLowRelevanceColor,
              size: 20,
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    configuration.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: configuration.isCompleted
                          ? ToDoListTheme.completedTextColor
                          : ToDoListTheme.textColor,
                      decoration: configuration.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (configuration.date != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      configuration.date!,
                      style: TextStyle(color: ToDoListTheme.taskRowDateColor),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          IconButton(
            padding: const EdgeInsets.only(right: 18),
            constraints: const BoxConstraints(),
            onPressed: () {
              final index = bloc.state.tasks
                  .indexWhere((element) => element.id == configuration.id);
              GetIt.I<NavigationManager>().openTaskForm(index);
            },
            icon: Icon(
              Icons.info_outline,
              color: ToDoListTheme.taskRowCheckBoxInfoButtonColor,
            ),
          ),
        ],
      ),
    );
  }
}
