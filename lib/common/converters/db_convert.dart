// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:todo_list_shmr/common/task_model/task_configuration.dart';

abstract class DatabaseDataConvert {
  static const String _id = 'id';
  static const String _isCompleted = 'isCompleted';
  static const String _description = 'description';
  static const String _relevance = 'relevance';
  static const String _date = 'date';

  static Map<String, dynamic> mapFromTask(TaskWidgetConfiguration task) {
    Map<String, dynamic> map = {};
    map[_id] = task.id;
    map[_description] = task.description;
    map[_relevance] = task.relevance == Relevance.none
        ? 0
        : task.relevance == Relevance.low
            ? 1
            : 2;
    map[_isCompleted] = task.isCompleted ? 1 : 0;
    if (task.date != null) {
      map[_date] = task.date;
    }
    return map;
  }

  static List<TaskWidgetConfiguration> taskListFromDatabase(
      List<Map<String, dynamic>> taskMapList) {
    int count = taskMapList.length;

    List<TaskWidgetConfiguration> taskList = [];
    for (int i = 0; i < count; i++) {
      TaskWidgetConfiguration curTask = TaskWidgetConfiguration(
        id: taskMapList[i][_id],
        isCompleted: taskMapList[i][_isCompleted] == 1 ? true : false,
        relevance: taskMapList[i][_relevance] == 0
            ? Relevance.none
            : taskMapList[i][_relevance] == 1
                ? Relevance.low
                : Relevance.high,
        description: taskMapList[i][_description],
        date: taskMapList[i][_date],
      );
      taskList.add(curTask);
    }
    return taskList;
  }
}
