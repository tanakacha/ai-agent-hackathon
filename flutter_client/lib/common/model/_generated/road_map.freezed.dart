// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../RoadMap.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RoadMap _$RoadMapFromJson(Map<String, dynamic> json) {
  return _RoadMap.fromJson(json);
}

/// @nodoc
mixin _$RoadMap {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get objective => throw _privateConstructorUsedError;
  String get profile => throw _privateConstructorUsedError;
  DateTime get deadline => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  Map<String, Node> get nodes => throw _privateConstructorUsedError;

  /// Serializes this RoadMap to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoadMap
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoadMapCopyWith<RoadMap> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoadMapCopyWith<$Res> {
  factory $RoadMapCopyWith(RoadMap value, $Res Function(RoadMap) then) =
      _$RoadMapCopyWithImpl<$Res, RoadMap>;
  @useResult
  $Res call(
      {String id,
      String title,
      String objective,
      String profile,
      DateTime deadline,
      DateTime createdAt,
      DateTime updatedAt,
      Map<String, Node> nodes});
}

/// @nodoc
class _$RoadMapCopyWithImpl<$Res, $Val extends RoadMap>
    implements $RoadMapCopyWith<$Res> {
  _$RoadMapCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoadMap
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? objective = null,
    Object? profile = null,
    Object? deadline = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? nodes = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      objective: null == objective
          ? _value.objective
          : objective // ignore: cast_nullable_to_non_nullable
              as String,
      profile: null == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as String,
      deadline: null == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      nodes: null == nodes
          ? _value.nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as Map<String, Node>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoadMapImplCopyWith<$Res> implements $RoadMapCopyWith<$Res> {
  factory _$$RoadMapImplCopyWith(
          _$RoadMapImpl value, $Res Function(_$RoadMapImpl) then) =
      __$$RoadMapImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String objective,
      String profile,
      DateTime deadline,
      DateTime createdAt,
      DateTime updatedAt,
      Map<String, Node> nodes});
}

/// @nodoc
class __$$RoadMapImplCopyWithImpl<$Res>
    extends _$RoadMapCopyWithImpl<$Res, _$RoadMapImpl>
    implements _$$RoadMapImplCopyWith<$Res> {
  __$$RoadMapImplCopyWithImpl(
      _$RoadMapImpl _value, $Res Function(_$RoadMapImpl) _then)
      : super(_value, _then);

  /// Create a copy of RoadMap
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? objective = null,
    Object? profile = null,
    Object? deadline = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? nodes = null,
  }) {
    return _then(_$RoadMapImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      objective: null == objective
          ? _value.objective
          : objective // ignore: cast_nullable_to_non_nullable
              as String,
      profile: null == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as String,
      deadline: null == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      nodes: null == nodes
          ? _value._nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as Map<String, Node>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoadMapImpl implements _RoadMap {
  const _$RoadMapImpl(
      {required this.id,
      required this.title,
      required this.objective,
      required this.profile,
      required this.deadline,
      required this.createdAt,
      required this.updatedAt,
      required final Map<String, Node> nodes})
      : _nodes = nodes;

  factory _$RoadMapImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoadMapImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String objective;
  @override
  final String profile;
  @override
  final DateTime deadline;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final Map<String, Node> _nodes;
  @override
  Map<String, Node> get nodes {
    if (_nodes is EqualUnmodifiableMapView) return _nodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_nodes);
  }

  @override
  String toString() {
    return 'RoadMap(id: $id, title: $title, objective: $objective, profile: $profile, deadline: $deadline, createdAt: $createdAt, updatedAt: $updatedAt, nodes: $nodes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoadMapImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.objective, objective) ||
                other.objective == objective) &&
            (identical(other.profile, profile) || other.profile == profile) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._nodes, _nodes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      objective,
      profile,
      deadline,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_nodes));

  /// Create a copy of RoadMap
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoadMapImplCopyWith<_$RoadMapImpl> get copyWith =>
      __$$RoadMapImplCopyWithImpl<_$RoadMapImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoadMapImplToJson(
      this,
    );
  }
}

abstract class _RoadMap implements RoadMap {
  const factory _RoadMap(
      {required final String id,
      required final String title,
      required final String objective,
      required final String profile,
      required final DateTime deadline,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      required final Map<String, Node> nodes}) = _$RoadMapImpl;

  factory _RoadMap.fromJson(Map<String, dynamic> json) = _$RoadMapImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get objective;
  @override
  String get profile;
  @override
  DateTime get deadline;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  Map<String, Node> get nodes;

  /// Create a copy of RoadMap
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoadMapImplCopyWith<_$RoadMapImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
