import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:freezed/builder.dart';
import 'package:todo_list_shmr/common/task_model/task_configuration.dart';

part 'task_config.freezed.dart';

@freezed
class TaskConfig with _$TaskConfig {
  const factory TaskConfig({
    required String? id,
    required bool isCompleted,
    required Relevance relevance,
    required String description,
    required String? date,
  }) = _TaskConfig;
}
