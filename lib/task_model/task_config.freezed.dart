// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$TaskWidgetConfiguration {
  String get id => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  Relevance get relevance => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get date => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TaskWidgetConfigurationCopyWith<TaskWidgetConfiguration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskWidgetConfigurationCopyWith<$Res> {
  factory $TaskWidgetConfigurationCopyWith(TaskWidgetConfiguration value,
          $Res Function(TaskWidgetConfiguration) then) =
      _$TaskWidgetConfigurationCopyWithImpl<$Res, TaskWidgetConfiguration>;
  @useResult
  $Res call(
      {String id,
      bool isCompleted,
      Relevance relevance,
      String description,
      String? date});
}

/// @nodoc
class _$TaskWidgetConfigurationCopyWithImpl<$Res,
        $Val extends TaskWidgetConfiguration>
    implements $TaskWidgetConfigurationCopyWith<$Res> {
  _$TaskWidgetConfigurationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? isCompleted = null,
    Object? relevance = null,
    Object? description = null,
    Object? date = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      relevance: null == relevance
          ? _value.relevance
          : relevance // ignore: cast_nullable_to_non_nullable
              as Relevance,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TaskWidgetConfigurationCopyWith<$Res>
    implements $TaskWidgetConfigurationCopyWith<$Res> {
  factory _$$_TaskWidgetConfigurationCopyWith(_$_TaskWidgetConfiguration value,
          $Res Function(_$_TaskWidgetConfiguration) then) =
      __$$_TaskWidgetConfigurationCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      bool isCompleted,
      Relevance relevance,
      String description,
      String? date});
}

/// @nodoc
class __$$_TaskWidgetConfigurationCopyWithImpl<$Res>
    extends _$TaskWidgetConfigurationCopyWithImpl<$Res,
        _$_TaskWidgetConfiguration>
    implements _$$_TaskWidgetConfigurationCopyWith<$Res> {
  __$$_TaskWidgetConfigurationCopyWithImpl(_$_TaskWidgetConfiguration _value,
      $Res Function(_$_TaskWidgetConfiguration) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? isCompleted = null,
    Object? relevance = null,
    Object? description = null,
    Object? date = freezed,
  }) {
    return _then(_$_TaskWidgetConfiguration(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      relevance: null == relevance
          ? _value.relevance
          : relevance // ignore: cast_nullable_to_non_nullable
              as Relevance,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_TaskWidgetConfiguration implements _TaskWidgetConfiguration {
  const _$_TaskWidgetConfiguration(
      {required this.id,
      required this.isCompleted,
      required this.relevance,
      required this.description,
      required this.date});

  @override
  final String id;
  @override
  final bool isCompleted;
  @override
  final Relevance relevance;
  @override
  final String description;
  @override
  final String? date;

  @override
  String toString() {
    return 'TaskWidgetConfiguration(id: $id, isCompleted: $isCompleted, relevance: $relevance, description: $description, date: $date)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TaskWidgetConfiguration &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.relevance, relevance) ||
                other.relevance == relevance) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.date, date) || other.date == date));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, isCompleted, relevance, description, date);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TaskWidgetConfigurationCopyWith<_$_TaskWidgetConfiguration>
      get copyWith =>
          __$$_TaskWidgetConfigurationCopyWithImpl<_$_TaskWidgetConfiguration>(
              this, _$identity);
}

abstract class _TaskWidgetConfiguration implements TaskWidgetConfiguration {
  const factory _TaskWidgetConfiguration(
      {required final String id,
      required final bool isCompleted,
      required final Relevance relevance,
      required final String description,
      required final String? date}) = _$_TaskWidgetConfiguration;

  @override
  String get id;
  @override
  bool get isCompleted;
  @override
  Relevance get relevance;
  @override
  String get description;
  @override
  String? get date;
  @override
  @JsonKey(ignore: true)
  _$$_TaskWidgetConfigurationCopyWith<_$_TaskWidgetConfiguration>
      get copyWith => throw _privateConstructorUsedError;
}
