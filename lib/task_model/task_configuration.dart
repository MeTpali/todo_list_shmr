import 'package:uuid/uuid.dart';

enum Relevance {
  none,
  high,
  low,
}

class TaskWidgetConfiguration {
  static const _uuid = Uuid();
  String id;
  final String description;
  final Relevance relevance;
  bool isCompleted;
  final String? date;
  TaskWidgetConfiguration({
    String? id,
    required this.isCompleted,
    required this.relevance,
    required this.description,
    required this.date,
  }) : id = id ?? _uuid.v4();

  TaskWidgetConfiguration.initial()
      : description = '',
        relevance = Relevance.none,
        isCompleted = false,
        date = null,
        id = _uuid.v4();

  TaskWidgetConfiguration copyWith({
    String? id,
    String? description,
    Relevance? relevance,
    bool? isCompleted,
    String? date,
  }) {
    return TaskWidgetConfiguration(
      id: id ?? this.id,
      description: description ?? this.description,
      relevance: relevance ?? this.relevance,
      isCompleted: isCompleted ?? this.isCompleted,
      date: date,
    );
  }

  @override
  bool operator ==(covariant TaskWidgetConfiguration other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.description == description &&
        other.relevance == relevance &&
        other.isCompleted == isCompleted &&
        other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        description.hashCode ^
        relevance.hashCode ^
        isCompleted.hashCode ^
        date.hashCode;
  }
}
