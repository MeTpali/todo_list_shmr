import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:todo_list_shmr/task_model/task_configuration.dart';
import 'package:todo_list_shmr/ui/utility/logger/logging.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  String taskTable = 'task_table';
  String id = 'id';
  String isCompleted = 'isCompleted';
  String description = 'description';
  String relevance = 'relevance';
  String date = 'date';

  DatabaseHelper._();

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}taskList.db';

    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    try {
      await db.execute(
          'CREATE TABLE $taskTable($id TEXT PRIMARY KEY, $description TEXT, '
          '$relevance INTEGER, $isCompleted INTEGER, $date TEXT)');
    } catch (e) {
      final log = logger(DatabaseHelper);
      log.e(e);
    }
  }

  Future<List<Map<String, dynamic>>> getTaskMapList() async {
    List<Map<String, dynamic>> result = [];
    try {
      Database db = await database;
      result = await db.query(taskTable, orderBy: '$id ASC');
    } catch (e) {
      final log = logger(DatabaseHelper);
      log.e(e);
    }
    return result;
  }

  Future<int> insertTask(TaskWidgetConfiguration task) async {
    Map<String, dynamic> map = {};
    map[id] = task.id;
    map[description] = task.description;
    map[relevance] = task.relevance == Relevance.none
        ? 0
        : task.relevance == Relevance.low
            ? 1
            : 2;
    map[isCompleted] = task.isCompleted ? 1 : 0;
    if (task.date != null) {
      map[date] = task.date;
    }
    int result = 0;
    try {
      Database db = await database;
      result = await db.insert(taskTable, map);
    } catch (e) {
      final log = logger(DatabaseHelper);
      log.e(e);
    }
    return result;
  }

  Future<int> updateTask(TaskWidgetConfiguration task) async {
    Map<String, dynamic> map = {};
    map[id] = task.id;
    map[description] = task.description;
    map[relevance] = task.relevance == Relevance.none
        ? 0
        : task.relevance == Relevance.low
            ? 1
            : 2;
    map[isCompleted] = task.isCompleted ? 1 : 0;
    if (task.date != null) {
      map[date] = task.date;
    }
    int result = 0;
    try {
      var db = await database;
      result = await db.update(
        taskTable,
        map,
        where: '$id = ?',
        whereArgs: [task.id],
      );
    } catch (e) {
      final log = logger(DatabaseHelper);
      log.e(e);
    }
    return result;
  }

  Future<int> deleteTask(String id) async {
    int result = 0;
    try {
      var db = await database;
      result = await db
          .rawDelete('DELETE FROM $taskTable WHERE ${this.id} = \'$id\'');
    } catch (e) {
      final log = logger(DatabaseHelper);
      log.e(e);
    }
    return result;
  }

  Future<int?> getCount() async {
    int? result;
    try {
      Database db = await database;
      List<Map<String, dynamic>> x =
          await db.rawQuery('SELECT COUNT (*) from $taskTable');
      result = Sqflite.firstIntValue(x);
    } catch (e) {
      final log = logger(DatabaseHelper);
      log.e(e);
    }
    return result;
  }

  Future<List<TaskWidgetConfiguration>> getTaskList() async {
    var taskMapList = await getTaskMapList();
    int count = taskMapList.length;

    List<TaskWidgetConfiguration> taskList = [];
    for (int i = 0; i < count; i++) {
      TaskWidgetConfiguration curTask = TaskWidgetConfiguration(
        id: taskMapList[i][id],
        isCompleted: taskMapList[i][isCompleted] == 1 ? true : false,
        relevance: taskMapList[i][relevance] == 0
            ? Relevance.none
            : taskMapList[i][relevance] == 1
                ? Relevance.low
                : Relevance.high,
        description: taskMapList[i][description],
        date: taskMapList[i][date],
      );
      taskList.add(curTask);
    }
    return taskList;
  }
}
