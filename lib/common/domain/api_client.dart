import 'dart:io';

import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:todo_list_shmr/common/converters/server_convert.dart';
import 'package:todo_list_shmr/common/core/server_exceptions/server_exceptions.dart';
import 'package:todo_list_shmr/common/domain/shared_preferences.dart';
import 'package:todo_list_shmr/common/task_model/task_configuration.dart';
import 'package:todo_list_shmr/common/utility/logger/logging.dart';

class ApiClient {
  static const _token = 'preconvincing';
  static const _deviceId = "1";
  final _revisionProvider = RevisionProvider();

  final _log = logger(ApiClient);

  final _dio = Dio(BaseOptions(baseUrl: 'https://beta.mrdekk.ru/todobackend'));

  Future<List<TaskWidgetConfiguration>> getTaskList() async {
    if (await _checkInternet()) {
      Response? response;
      try {
        response = await _dio.get(
          '/list',
          options: Options(
            headers: {
              "Authorization": "Bearer $_token",
            },
          ),
        );
        _errorHandling(response);
        await _revisionProvider.saveValue(response.data['revision']);
        return ServerDataConvert.taskListFromServer(response);
      } on SocketException {
        _log.i('No Internet connection');
        rethrow;
      } on HttpException {
        _log.e("Couldn't find the post");
        rethrow;
      } on FormatException {
        _log.e('Bad response format');
        rethrow;
      } on UnsynchronizedDataException {
        rethrow;
      } catch (e) {
        _log.e(e);
        rethrow;
      }
    } else {
      return [];
    }
  }

  Future<void> postTask(TaskWidgetConfiguration config) async {
    if (await _checkInternet()) {
      var curRevision = await _getCurrentRevision();
      final map = ServerDataConvert.mapFromTask(config, _deviceId);
      Response? response;
      try {
        response = await _dio.post(
          '/list',
          options: Options(
            headers: {
              "Authorization": "Bearer $_token",
              "X-Last-Known-Revision": curRevision,
            },
          ),
          data: map,
        );
        _errorHandling(response);
        await _revisionProvider.saveValue(response.data['revision']);
      } on SocketException {
        _log.i('No Internet connection');
        rethrow;
      } on HttpException {
        _log.e("Couldn't find the post");
        rethrow;
      } on FormatException {
        _log.e('Bad response format');
        rethrow;
      } on UnsynchronizedDataException {
        rethrow;
      } catch (e) {
        _log.e(e);
        rethrow;
      }
    }
  }

  Future<TaskWidgetConfiguration?> getTask(String id) async {
    if (await _checkInternet()) {
      Response? response;
      try {
        response = await _dio.get(
          '/list/$id',
          options: Options(
            headers: {
              "Authorization": "Bearer $_token",
            },
          ),
        );
        _errorHandling(response);
        await _revisionProvider.saveValue(response.data['revision']);
        return ServerDataConvert.taskFromServer(response);
      } on SocketException {
        _log.i('No Internet connection');
        rethrow;
      } on HttpException {
        _log.e("Couldn't find the post");
        rethrow;
      } on FormatException {
        _log.e('Bad response format');
        rethrow;
      } on UnsynchronizedDataException {
        rethrow;
      } catch (e) {
        _log.e(e);
        rethrow;
      }
    } else {
      return null;
    }
  }

  Future<void> patchTaskList(List<TaskWidgetConfiguration> list) async {
    if (await _checkInternet()) {
      var curRevision = await _getCurrentRevision();
      final input = ServerDataConvert.mapFromTaskList(list, _deviceId);
      try {
        final response = await _dio.patch(
          '/list',
          options: Options(
            headers: {
              "Authorization": "Bearer $_token",
              "X-Last-Known-Revision": curRevision,
            },
          ),
          data: input,
        );
        _errorHandling(response);
        await _revisionProvider.saveValue(response.data['revision']);
      } on SocketException {
        _log.i('No Internet connection');
        rethrow;
      } on HttpException {
        _log.e("Couldn't find the post");
        rethrow;
      } on FormatException {
        _log.e('Bad response format');
        rethrow;
      } on UnsynchronizedDataException {
        rethrow;
      } catch (e) {
        _log.e(e);
        rethrow;
      }
    }
  }

  Future<void> updateTask(TaskWidgetConfiguration config) async {
    if (await _checkInternet()) {
      var curRevision = await _getCurrentRevision();
      final map = ServerDataConvert.mapFromTask(config, _deviceId);
      Response? response;
      try {
        response = await _dio.put(
          '/list/${config.id}',
          options: Options(
            headers: {
              "Authorization": "Bearer $_token",
              "X-Last-Known-Revision": curRevision,
            },
          ),
          data: map,
        );
        _errorHandling(response);
        await _revisionProvider.saveValue(response.data['revision']);
      } on SocketException {
        _log.i('No Internet connection');
        rethrow;
      } on HttpException {
        _log.e("Couldn't find the post");
        rethrow;
      } on FormatException {
        _log.e('Bad response format');
        rethrow;
      } on UnsynchronizedDataException {
        rethrow;
      } catch (e) {
        _log.e(e);
        rethrow;
      }
    }
  }

  Future<void> deleteTask(String id) async {
    if (await _checkInternet()) {
      var curRevision = await _getCurrentRevision();
      Response? response;
      try {
        response = await _dio.delete(
          '/list/$id',
          options: Options(
            headers: {
              "Authorization": "Bearer $_token",
              "X-Last-Known-Revision": curRevision,
            },
          ),
        );
        _errorHandling(response);
        await _revisionProvider.saveValue(response.data['revision']);
      } on SocketException {
        _log.i('No Internet connection');
        rethrow;
      } on HttpException {
        _log.e("Couldn't find the post");
        rethrow;
      } on FormatException {
        _log.e('Bad response format');
        rethrow;
      } on UnsynchronizedDataException {
        rethrow;
      } catch (e) {
        _log.e(e);
        rethrow;
      }
    }
  }

  Future<int> _getCurrentRevision() async {
    var curRevision = await _revisionProvider.loadValue();
    if (curRevision == -1) {
      await getTaskList();
      curRevision = await _revisionProvider.loadValue();
    }
    return curRevision;
  }

  Future<bool> _checkInternet() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      return true;
    }
    return false;
  }

  void _errorHandling(Response response) {
    switch (response.statusCode) {
      case 200:
        return;
      case 400:
        {
          if (response.data == 'unsynchronized data') {
            _log.i('Data bases are unsynchronized');
            throw UnsynchronizedDataException();
          }
          _log.e('Bad http request to the server');
          throw BadDioRequestException();
        }
      case 500:
        {
          _log.e('Error on server');
          throw ServerErrorException();
        }
      default:
        {
          throw UnknownServerException();
        }
    }
  }
}
