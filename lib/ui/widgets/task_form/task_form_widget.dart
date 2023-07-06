import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_list_shmr/core/task_repository.dart';
import 'package:todo_list_shmr/navigation/navigation.dart';
import 'package:todo_list_shmr/task_model/task_configuration.dart';
import 'package:todo_list_shmr/ui/utility/localization/s.dart';
import 'package:todo_list_shmr/ui/theme/theme.dart';
import 'package:todo_list_shmr/ui/widgets/task_form/task_form_cubit.dart';

class TaskFormWidget extends StatelessWidget {
  final int? taskId;
  const TaskFormWidget({
    Key? key,
    this.taskId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskFormCubit(
        taskId != null
            ? TaskFormState(
                configuration:
                    context.read<TaskListBloc>().state.tasks[taskId!],
                isChanging: true,
              )
            : TaskFormState(
                configuration: TaskWidgetConfiguration.initial(),
                isChanging: false,
              ),
      ),
      child: const _TaskFormBody(),
    );
  }
}

class _TaskFormBody extends StatefulWidget {
  const _TaskFormBody();

  @override
  State<_TaskFormBody> createState() => _TaskFormBodyState();
}

class _TaskFormBodyState extends State<_TaskFormBody> {
  double offset = 0;
  final _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        offset = _controller.positions.isEmpty ? 0 : _controller.offset;
      });
    });
  }

  @override
  void dispose() {
    _controller.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TaskListBloc>();
    final cubit = context.watch<TaskFormCubit>();
    return Scaffold(
      backgroundColor: ToDoListTheme.taskFormScaffoldColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: ToDoListTheme.taskFormAppBarIconColor),
        backgroundColor: ToDoListTheme.taskFormAppBarColor,
        elevation: offset < 100 ? 4 * offset / 100 : 4,
        actions: [
          TextButton(
            onPressed: cubit.state.configuration.description.isNotEmpty
                ? cubit.state.isChanging
                    ? () {
                        bloc.add(TaskListUpdateTask(
                            configuration: cubit.state.configuration));
                        GetIt.I<NavigationManager>().openMainScreen();
                      }
                    : () {
                        bloc.add(TaskListSaveTask(
                            configuration: cubit.state.configuration));
                        GetIt.I<NavigationManager>().openMainScreen();
                      }
                : null,
            child: Text(
              S.of(context).get("save").toUpperCase(),
              style: TextStyle(
                color: ToDoListTheme.taskFormAppBarSaveColor,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _controller,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _TaskFieldWidget(),
                  const SizedBox(height: 28),
                  Text(
                    S.of(context).get("relevance"),
                    style: TextStyle(
                      color: ToDoListTheme.textColor,
                    ),
                  ),
                  const _RelevancePoPup(),
                  const Divider(height: 32),
                  const _DatePicker(),
                ],
              ),
            ),
            const Divider(height: 26),
            const _DeleteWidget(),
            const SizedBox(height: 45),
          ],
        ),
      ),
    );
  }
}

class _TaskFieldWidget extends StatefulWidget {
  const _TaskFieldWidget();

  @override
  State<_TaskFieldWidget> createState() => _TaskFieldWidgetState();
}

class _TaskFieldWidgetState extends State<_TaskFieldWidget> {
  final textController = TextEditingController();
  @override
  void initState() {
    super.initState();
    textController.addListener(() {
      _updateDescription(context, textController.text);
    });
  }

  void _updateDescription(BuildContext context, String value) {
    final cubit = context.read<TaskFormCubit>();
    cubit.updateText(value);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TaskFormCubit>();
    textController.text = cubit.state.configuration.description;
    return Material(
      color: ToDoListTheme.taskFormTextFieldColor,
      elevation: 2,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        child: TextField(
          controller: textController,
          minLines: 4,
          maxLines: 30,
          style: TextStyle(
            color: ToDoListTheme.taskFormTextColor,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: S.of(context).get("smthShouldBeDone"),
            hintStyle: TextStyle(color: ToDoListTheme.taskFormHintTextColor),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    textController.removeListener(() {});
    textController.dispose();
    super.dispose();
  }
}

class _RelevancePoPup extends StatelessWidget {
  const _RelevancePoPup();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TaskFormCubit>();
    return Theme(
      data: Theme.of(context).copyWith(
        highlightColor: Colors.transparent,
      ),
      child: PopupMenuButton(
        elevation: 3,
        color: ToDoListTheme.taskFormPopupMenuColor,
        surfaceTintColor: Colors.transparent,
        initialValue: cubit.state.configuration.relevance,
        onSelected: (Relevance item) => cubit.updateRelevance(item),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Relevance>>[
          PopupMenuItem<Relevance>(
            value: Relevance.none,
            child: Text(
              S.of(context).get("none"),
              style: TextStyle(color: ToDoListTheme.textColor),
            ),
          ),
          PopupMenuItem<Relevance>(
            value: Relevance.low,
            child: Text(
              S.of(context).get("low"),
              style: TextStyle(color: ToDoListTheme.textColor),
            ),
          ),
          PopupMenuItem<Relevance>(
            value: Relevance.high,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 10,
                  child: Icon(
                    Icons.priority_high_rounded,
                    color: Colors.red,
                    size: 16,
                  ),
                ),
                const Icon(
                  Icons.priority_high_rounded,
                  color: Colors.red,
                  size: 16,
                ),
                Text(
                  S.of(context).get("high"),
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: cubit.state.configuration.relevance == Relevance.none
              ? Text(
                  S.of(context).get('none'),
                  style: TextStyle(
                    color: ToDoListTheme.taskFormNoneRelevanceColor,
                  ),
                )
              : cubit.state.configuration.relevance == Relevance.low
                  ? Text(
                      S.of(context).get("low"),
                      style: TextStyle(
                        color: ToDoListTheme.taskFormLowRelevanceColor,
                      ),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(
                          height: 20,
                          width: 10,
                          child: Icon(
                            Icons.priority_high_rounded,
                            color: Colors.red,
                            size: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                          child: Icon(
                            Icons.priority_high_rounded,
                            color: Colors.red,
                            size: 18,
                          ),
                        ),
                        Text(
                          S.of(context).get('high'),
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}

class _DatePicker extends StatelessWidget {
  const _DatePicker();

  void _showDatePicker(BuildContext context) {
    showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor:
                ToDoListTheme.taskFormDatePickerDialogBackgroundColor,
            colorScheme: ColorScheme.light(
              primary: ToDoListTheme.taskFormDatePickerPrimaryColor,
              onSurface: ToDoListTheme.textColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(
                  ToDoListTheme.taskFormDatePickerButtonsColor,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2031),
      cancelText: S.of(context).get("cancel").toUpperCase(),
      confirmText: S.of(context).get("ok").toUpperCase(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    ).then((value) {
      final cubit = context.read<TaskFormCubit>();
      cubit.updateDate(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TaskFormCubit>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 7),
              child: Text(
                S.of(context).get('makeTo'),
                style: TextStyle(
                  color: ToDoListTheme.textColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: FittedBox(
                child: cubit.state.configuration.date != null
                    ? Text(
                        cubit.state.configuration.date!,
                        style:
                            TextStyle(color: ToDoListTheme.taskFormDateColor),
                      )
                    : null,
              ),
            ),
          ],
        ),
        Switch(
          value: cubit.state.configuration.date != null,
          trackColor: cubit.state.configuration.date != null
              ? MaterialStateProperty.all(
                  ToDoListTheme.taskFormTrackActiveSwitchColor)
              : MaterialStateProperty.all(
                  ToDoListTheme.taskFormTrackSwitchColor),
          inactiveThumbColor: ToDoListTheme.taskFormInactiveThumbSwitchColor,
          activeColor: ToDoListTheme.taskFormActiveSwitchColor,
          onChanged: (bool value) {
            if (value) {
              _showDatePicker(context);
            } else {
              cubit.updateDate(null);
            }
          },
        ),
      ],
    );
  }
}

class _DeleteWidget extends StatelessWidget {
  const _DeleteWidget();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TaskFormCubit>();
    final bloc = context.read<TaskListBloc>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: TextButton(
        onPressed: cubit.state.isChanging
            ? () {
                bloc.add(TaskListDeleteTask(id: cubit.state.configuration.id));
                GetIt.I<NavigationManager>().openMainScreen();
              }
            : null,
        child: Row(
          children: [
            Icon(
              Icons.delete,
              color: cubit.state.isChanging
                  ? ToDoListTheme.taskFormDeleteColor
                  : ToDoListTheme.taskFormDisableDeleteColor,
            ),
            const SizedBox(width: 10),
            Text(
              S.of(context).get('delete'),
              style: TextStyle(
                color: cubit.state.isChanging
                    ? ToDoListTheme.taskFormDeleteColor
                    : ToDoListTheme.taskFormDisableDeleteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
