import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_config.freezed.dart';

enum Relevance {
  none,
  high,
  low,
}

@freezed
class TaskWidgetConfiguration with _$TaskWidgetConfiguration {
  const factory TaskWidgetConfiguration({
    required String id,
    required bool isCompleted,
    required Relevance relevance,
    required String description,
    required String? date,
  }) = _TaskWidgetConfiguration;
}
