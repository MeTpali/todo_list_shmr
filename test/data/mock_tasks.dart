import 'package:todo_list_shmr/common/core/task_repository.dart';
import 'package:todo_list_shmr/common/task_model/task_configuration.dart';

final TaskWidgetConfiguration firstTask = TaskWidgetConfiguration(
  id: '48450adf-9103-44c9-a5f7-1d838c54caa1',
  description: 'First task',
  isCompleted: true,
  relevance: Relevance.none,
  date: null,
);

final TaskWidgetConfiguration secondTask = TaskWidgetConfiguration(
  id: '6a9e9454-efce-49fa-8bcf-137bd66653a2',
  description: 'Second task',
  isCompleted: false,
  relevance: Relevance.low,
  date: '1 марта 2023',
);

final TaskWidgetConfiguration thirdTask = TaskWidgetConfiguration(
  id: '086bc8a2-255d-4e9d-bb6f-456c5e6fe9a3',
  description: 'Third task',
  isCompleted: true,
  relevance: Relevance.high,
  date: null,
);

final TaskWidgetConfiguration secondTaskChanged = TaskWidgetConfiguration(
  id: '6a9e9454-efce-49fa-8bcf-137bd66653a2',
  description: 'Second task changed',
  isCompleted: false,
  relevance: Relevance.high,
  date: '2 марта 2023',
);

final TaskWidgetConfiguration thirdTaskChanged = TaskWidgetConfiguration(
  id: '086bc8a2-255d-4e9d-bb6f-456c5e6fe9a3',
  description: 'Third task',
  isCompleted: false,
  relevance: Relevance.high,
  date: null,
);

final List<TaskWidgetConfiguration> mockDBTaskList = [
  firstTask,
  secondTask,
];

final List<TaskWidgetConfiguration> mockList1 = [
  firstTask,
];

final List<TaskWidgetConfiguration> mockList2 = [
  firstTask,
  secondTask,
];

final List<TaskWidgetConfiguration> mockList3 = [
  firstTask,
  secondTask,
  thirdTask,
];

final List<TaskWidgetConfiguration> mockList2Changed = [
  firstTask,
  secondTaskChanged,
];

final List<TaskWidgetConfiguration> mockList3Changed = [
  firstTask,
  secondTask,
  thirdTaskChanged,
];

TaskListState mockState = TaskListState(tasks: mockDBTaskList);

TaskListState mockState1 = TaskListState(tasks: mockList1);
TaskListState mockState2 = TaskListState(tasks: mockList2);
TaskListState mockState3 = TaskListState(tasks: mockList3);

TaskListState mockState2Changed = TaskListState(tasks: mockList2Changed);
TaskListState mockState3Changed = TaskListState(tasks: mockList3Changed);
