import 'package:todo_list_shmr/task_model/task_config.dart';

const deviceId = '1';

const TaskWidgetConfiguration mockServerTask = TaskWidgetConfiguration(
  id: '48450adf-9103-44c9-a5f7-1d838c54caa1',
  description: 'mock task',
  isCompleted: true,
  relevance: Relevance.low,
  date: '1 марта 2021',
);

const TaskWidgetConfiguration mockServerTask2 = TaskWidgetConfiguration(
  id: '6a9e9454-efce-49fa-8bcf-137bd66653a2',
  description: 'second task',
  isCompleted: false,
  relevance: Relevance.high,
  date: null,
);

final Map<String, dynamic> mockServerMapTask = {
  "element": {
    "id": '48450adf-9103-44c9-a5f7-1d838c54caa1',
    "text": 'mock task',
    "importance": "low",
    "deadline": DateTime(2021, 3, 1).millisecondsSinceEpoch,
    "done": true,
    "color": null,
    "created_at": DateTime.now().toUtc().millisecondsSinceEpoch,
    "changed_at": DateTime.now().toUtc().millisecondsSinceEpoch,
    "last_updated_by": deviceId,
  },
};

// final Map<String, dynamic> mockDBMapTask2 = {
//   'id': '6a9e9454-efce-49fa-8bcf-137bd66653a2',
//   'isCompleted': 0,
//   'description': 'second task',
//   'relevance': 2,
// };

final Map<String, List<Map<String, Object?>>> mockServerTaskMapList = {
  "list": [
    {
      "id": '48450adf-9103-44c9-a5f7-1d838c54caa1',
      "text": 'mock task',
      "importance": "low",
      "deadline": DateTime(2021, 3, 1).millisecondsSinceEpoch,
      "done": true,
      "color": null,
      "created_at": DateTime.now().toUtc().millisecondsSinceEpoch,
      "changed_at": DateTime.now().toUtc().millisecondsSinceEpoch,
      "last_updated_by": deviceId,
    },
    {
      "id": '6a9e9454-efce-49fa-8bcf-137bd66653a2',
      "text": 'second task',
      "importance": "important",
      "deadline": null,
      "done": false,
      "color": null,
      "created_at": DateTime.now().toUtc().millisecondsSinceEpoch,
      "changed_at": DateTime.now().toUtc().millisecondsSinceEpoch,
      "last_updated_by": deviceId,
    },
  ],
};

final List<TaskWidgetConfiguration> mockServerTaskListConvert = [
  mockServerTask,
  mockServerTask2,
];
