// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../node.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Node {
  String get id => throw _privateConstructorUsedError;
  String? get parentId => throw _privateConstructorUsedError;
  List<String> get childrenIds => throw _privateConstructorUsedError;
  NodeType get nodeType => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError;
  int get progressRate => throw _privateConstructorUsedError;
  double get x => throw _privateConstructorUsedError;
  double get y => throw _privateConstructorUsedError;
  DateTime get dueAt => throw _privateConstructorUsedError;
  DateTime? get finishedAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  String? get mapId => throw _privateConstructorUsedError;

  /// Create a copy of Node
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NodeCopyWith<Node> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NodeCopyWith<$Res> {
  factory $NodeCopyWith(Node value, $Res Function(Node) then) =
      _$NodeCopyWithImpl<$Res, Node>;
  @useResult
  $Res call(
      {String id,
      String? parentId,
      List<String> childrenIds,
      NodeType nodeType,
      String title,
      String description,
      int duration,
      int progressRate,
      double x,
      double y,
      DateTime dueAt,
      DateTime? finishedAt,
      DateTime createdAt,
      DateTime updatedAt,
      String? mapId});
}

/// @nodoc
class _$NodeCopyWithImpl<$Res, $Val extends Node>
    implements $NodeCopyWith<$Res> {
  _$NodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Node
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentId = freezed,
    Object? childrenIds = null,
    Object? nodeType = null,
    Object? title = null,
    Object? description = null,
    Object? duration = null,
    Object? progressRate = null,
    Object? x = null,
    Object? y = null,
    Object? dueAt = null,
    Object? finishedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? mapId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      childrenIds: null == childrenIds
          ? _value.childrenIds
          : childrenIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nodeType: null == nodeType
          ? _value.nodeType
          : nodeType // ignore: cast_nullable_to_non_nullable
              as NodeType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      progressRate: null == progressRate
          ? _value.progressRate
          : progressRate // ignore: cast_nullable_to_non_nullable
              as int,
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      dueAt: null == dueAt
          ? _value.dueAt
          : dueAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      finishedAt: freezed == finishedAt
          ? _value.finishedAt
          : finishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      mapId: freezed == mapId
          ? _value.mapId
          : mapId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NodeImplCopyWith<$Res> implements $NodeCopyWith<$Res> {
  factory _$$NodeImplCopyWith(
          _$NodeImpl value, $Res Function(_$NodeImpl) then) =
      __$$NodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String? parentId,
      List<String> childrenIds,
      NodeType nodeType,
      String title,
      String description,
      int duration,
      int progressRate,
      double x,
      double y,
      DateTime dueAt,
      DateTime? finishedAt,
      DateTime createdAt,
      DateTime updatedAt,
      String? mapId});
}

/// @nodoc
class __$$NodeImplCopyWithImpl<$Res>
    extends _$NodeCopyWithImpl<$Res, _$NodeImpl>
    implements _$$NodeImplCopyWith<$Res> {
  __$$NodeImplCopyWithImpl(_$NodeImpl _value, $Res Function(_$NodeImpl) _then)
      : super(_value, _then);

  /// Create a copy of Node
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentId = freezed,
    Object? childrenIds = null,
    Object? nodeType = null,
    Object? title = null,
    Object? description = null,
    Object? duration = null,
    Object? progressRate = null,
    Object? x = null,
    Object? y = null,
    Object? dueAt = null,
    Object? finishedAt = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? mapId = freezed,
  }) {
    return _then(_$NodeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      childrenIds: null == childrenIds
          ? _value._childrenIds
          : childrenIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      nodeType: null == nodeType
          ? _value.nodeType
          : nodeType // ignore: cast_nullable_to_non_nullable
              as NodeType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      progressRate: null == progressRate
          ? _value.progressRate
          : progressRate // ignore: cast_nullable_to_non_nullable
              as int,
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as double,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as double,
      dueAt: null == dueAt
          ? _value.dueAt
          : dueAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      finishedAt: freezed == finishedAt
          ? _value.finishedAt
          : finishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      mapId: freezed == mapId
          ? _value.mapId
          : mapId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$NodeImpl extends _Node {
  const _$NodeImpl(
      {required this.id,
      this.parentId,
      final List<String> childrenIds = const [],
      required this.nodeType,
      required this.title,
      required this.description,
      required this.duration,
      required this.progressRate,
      this.x = 0.0,
      this.y = 0.0,
      required this.dueAt,
      this.finishedAt,
      required this.createdAt,
      required this.updatedAt,
      this.mapId})
      : _childrenIds = childrenIds,
        super._();

  @override
  final String id;
  @override
  final String? parentId;
  final List<String> _childrenIds;
  @override
  @JsonKey()
  List<String> get childrenIds {
    if (_childrenIds is EqualUnmodifiableListView) return _childrenIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_childrenIds);
  }

  @override
  final NodeType nodeType;
  @override
  final String title;
  @override
  final String description;
  @override
  final int duration;
  @override
  final int progressRate;
  @override
  @JsonKey()
  final double x;
  @override
  @JsonKey()
  final double y;
  @override
  final DateTime dueAt;
  @override
  final DateTime? finishedAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? mapId;

  @override
  String toString() {
    return 'Node(id: $id, parentId: $parentId, childrenIds: $childrenIds, nodeType: $nodeType, title: $title, description: $description, duration: $duration, progressRate: $progressRate, x: $x, y: $y, dueAt: $dueAt, finishedAt: $finishedAt, createdAt: $createdAt, updatedAt: $updatedAt, mapId: $mapId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            const DeepCollectionEquality()
                .equals(other._childrenIds, _childrenIds) &&
            (identical(other.nodeType, nodeType) ||
                other.nodeType == nodeType) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.progressRate, progressRate) ||
                other.progressRate == progressRate) &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.dueAt, dueAt) || other.dueAt == dueAt) &&
            (identical(other.finishedAt, finishedAt) ||
                other.finishedAt == finishedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.mapId, mapId) || other.mapId == mapId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      parentId,
      const DeepCollectionEquality().hash(_childrenIds),
      nodeType,
      title,
      description,
      duration,
      progressRate,
      x,
      y,
      dueAt,
      finishedAt,
      createdAt,
      updatedAt,
      mapId);

  /// Create a copy of Node
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NodeImplCopyWith<_$NodeImpl> get copyWith =>
      __$$NodeImplCopyWithImpl<_$NodeImpl>(this, _$identity);
}

abstract class _Node extends Node {
  const factory _Node(
      {required final String id,
      final String? parentId,
      final List<String> childrenIds,
      required final NodeType nodeType,
      required final String title,
      required final String description,
      required final int duration,
      required final int progressRate,
      final double x,
      final double y,
      required final DateTime dueAt,
      final DateTime? finishedAt,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final String? mapId}) = _$NodeImpl;
  const _Node._() : super._();

  @override
  String get id;
  @override
  String? get parentId;
  @override
  List<String> get childrenIds;
  @override
  NodeType get nodeType;
  @override
  String get title;
  @override
  String get description;
  @override
  int get duration;
  @override
  int get progressRate;
  @override
  double get x;
  @override
  double get y;
  @override
  DateTime get dueAt;
  @override
  DateTime? get finishedAt;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  String? get mapId;

  /// Create a copy of Node
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NodeImplCopyWith<_$NodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
