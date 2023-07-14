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
mixin _$TaskConfig {
  String? get id => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  Relevance get relevance => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String? get date => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TaskConfigCopyWith<TaskConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskConfigCopyWith<$Res> {
  factory $TaskConfigCopyWith(
          TaskConfig value, $Res Function(TaskConfig) then) =
      _$TaskConfigCopyWithImpl<$Res, TaskConfig>;
  @useResult
  $Res call(
      {String? id,
      bool isCompleted,
      Relevance relevance,
      String description,
      String? date});
}

/// @nodoc
class _$TaskConfigCopyWithImpl<$Res, $Val extends TaskConfig>
    implements $TaskConfigCopyWith<$Res> {
  _$TaskConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? isCompleted = null,
    Object? relevance = null,
    Object? description = null,
    Object? date = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$_TaskConfigCopyWith<$Res>
    implements $TaskConfigCopyWith<$Res> {
  factory _$$_TaskConfigCopyWith(
          _$_TaskConfig value, $Res Function(_$_TaskConfig) then) =
      __$$_TaskConfigCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      bool isCompleted,
      Relevance relevance,
      String description,
      String? date});
}

/// @nodoc
class __$$_TaskConfigCopyWithImpl<$Res>
    extends _$TaskConfigCopyWithImpl<$Res, _$_TaskConfig>
    implements _$$_TaskConfigCopyWith<$Res> {
  __$$_TaskConfigCopyWithImpl(
      _$_TaskConfig _value, $Res Function(_$_TaskConfig) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? isCompleted = null,
    Object? relevance = null,
    Object? description = null,
    Object? date = freezed,
  }) {
    return _then(_$_TaskConfig(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
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

class _$_TaskConfig implements _TaskConfig {
  const _$_TaskConfig(
      {required this.id,
      required this.isCompleted,
      required this.relevance,
      required this.description,
      required this.date});

  @override
  final String? id;
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
    return 'TaskConfig(id: $id, isCompleted: $isCompleted, relevance: $relevance, description: $description, date: $date)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TaskConfig &&
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
  _$$_TaskConfigCopyWith<_$_TaskConfig> get copyWith =>
      __$$_TaskConfigCopyWithImpl<_$_TaskConfig>(this, _$identity);
}

abstract class _TaskConfig implements TaskConfig {
  const factory _TaskConfig(
      {required final String? id,
      required final bool isCompleted,
      required final Relevance relevance,
      required final String description,
      required final String? date}) = _$_TaskConfig;

  @override
  String? get id;
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
  _$$_TaskConfigCopyWith<_$_TaskConfig> get copyWith =>
      throw _privateConstructorUsedError;
}
