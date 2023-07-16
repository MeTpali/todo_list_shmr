import 'package:todo_list_shmr/task_model/task_config.dart';

const TaskWidgetConfiguration mockDBTask = TaskWidgetConfiguration(
  id: '48450adf-9103-44c9-a5f7-1d838c54caa1',
  description: 'mock task',
  isCompleted: true,
  relevance: Relevance.low,
  date: '1 марта 2021',
);

const TaskWidgetConfiguration mockDBTask2 = TaskWidgetConfiguration(
  id: '6a9e9454-efce-49fa-8bcf-137bd66653a2',
  description: 'second task',
  isCompleted: false,
  relevance: Relevance.high,
  date: null,
);

final Map<String, dynamic> mockDBMapTask = {
  'id': '48450adf-9103-44c9-a5f7-1d838c54caa1',
  'isCompleted': 1,
  'description': 'mock task',
  'relevance': 1,
  'date': '1 марта 2021',
};

final Map<String, dynamic> mockDBMapTask2 = {
  'id': '6a9e9454-efce-49fa-8bcf-137bd66653a2',
  'isCompleted': 0,
  'description': 'second task',
  'relevance': 2,
};

final List<Map<String, dynamic>> mockDBTaskMapList = [
  mockDBMapTask,
  mockDBMapTask2,
];

final List<TaskWidgetConfiguration> mockDBTaskListConvert = [
  mockDBTask,
  mockDBTask2,
];
