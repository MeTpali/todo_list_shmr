import 'package:dio/dio.dart';
import 'package:todo_list_shmr/common/domain/api_client.dart';
import 'package:todo_list_shmr/common/task_model/task_configuration.dart';
import 'package:todo_list_shmr/common/utility/date.dart';
import 'package:todo_list_shmr/common/utility/logger/logging.dart';

abstract class ServerDataConvert {
  static List<TaskWidgetConfiguration> taskListFromServer(Response response) {
    if (response.data['status'] == 'ok') {
      List<dynamic> newList = response.data['list'];
      List<TaskWidgetConfiguration> taskList = [];
      for (int i = 0; i < newList.length; i++) {
        String? date;
        if (newList[i]['deadline'] != null) {
          final time =
              DateTime.fromMillisecondsSinceEpoch(newList[i]['deadline']);
          date = '${time.day} ${Date.getMonth(time.month)} ${time.year}';
        }
        TaskWidgetConfiguration item = TaskWidgetConfiguration(
          id: newList[i]['id'],
          isCompleted: newList[i]['done'],
          relevance: newList[i]['importance'] == 'basic'
              ? Relevance.none
              : newList[i]['importance'] == 'low'
                  ? Relevance.low
                  : Relevance.high,
          description: newList[i]['text'],
          date: date,
        );
        taskList.add(item);
      }
      return taskList;
    } else {
      final log = logger(ApiClient);
      log.e('get task list error');
      return [];
    }
  }

  static Map<String, Map<String, Object?>> mapFromTask(
      TaskWidgetConfiguration config, String deviceId) {
    int? deadline;
    if (config.date != null) {
      final dateList = config.date!.split(' ').toList();
      final day = int.parse(dateList[0]);
      final month = Date.getNumber(dateList[1]);
      final year = int.parse(dateList[2]);
      deadline = DateTime(year, month, day).millisecondsSinceEpoch;
    }
    return {
      "element": {
        "id": config.id.toString(), // уникальный идентификатор элемента
        "text": config.description,
        "importance": config.relevance == Relevance.none
            ? "basic"
            : config.relevance == Relevance.low
                ? "low"
                : "important", // importance = low | basic | important
        "deadline": deadline, // int64, может отсутствовать, тогда нет
        "done": config.isCompleted,
        "color": null, // может отсутствовать
        "created_at": DateTime.now().toUtc().millisecondsSinceEpoch,
        "changed_at": DateTime.now().toUtc().millisecondsSinceEpoch,
        "last_updated_by": deviceId,
      },
    };
  }

  static TaskWidgetConfiguration? taskFromServer(Response response) {
    if (response.data['status'] == 'ok') {
      String? date;
      if (response.data['deadline'] != null) {
        final time =
            DateTime.fromMillisecondsSinceEpoch(response.data['deadline']);
        date = '${time.day} ${Date.getMonth(time.month)} ${time.year}';
      }
      final config = TaskWidgetConfiguration(
        id: response.data['element']['id'],
        isCompleted: response.data['element']['done'],
        relevance: response.data['element']['importance'] == 'basic'
            ? Relevance.none
            : response.data['element']['importance'] == 'low'
                ? Relevance.low
                : Relevance.high,
        description: response.data['element']['text'],
        date: date,
      );
      return config;
    } else {
      final log = logger(ApiClient);
      log.e('get task error');
      return null;
    }
  }

  static Map<String, List<Map<String, Object?>>> mapFromTaskList(
      List<TaskWidgetConfiguration> list, String deviceId) {
    final List<Map<String, Object?>> taskList = [];
    for (int i = 0; i < list.length; i++) {
      int? deadline;
      if (list[i].date != null) {
        final dateList = list[i].date!.split(' ').toList();
        final day = int.parse(dateList[0]);
        final month = Date.getNumber(dateList[1]);
        final year = int.parse(dateList[2]);
        deadline = DateTime(year, month, day).millisecondsSinceEpoch;
      }
      final map = {
        "id": list[i].id.toString(), // уникальный идентификатор элемента
        "text": list[i].description,
        "importance": list[i].relevance == Relevance.none
            ? "basic"
            : list[i].relevance == Relevance.low
                ? "low"
                : "important", // importance = low | basic | important
        "deadline": deadline, // int64, может отсутствовать, тогда нет
        "done": list[i].isCompleted,
        "color": null, // может отсутствовать
        "created_at": DateTime.now().toUtc().millisecondsSinceEpoch,
        "changed_at": DateTime.now().toUtc().millisecondsSinceEpoch,
        "last_updated_by": deviceId,
      };
      taskList.add(map);
    }
    final Map<String, List<Map<String, Object?>>> input = {"list": taskList};
    return input;
  }
}
