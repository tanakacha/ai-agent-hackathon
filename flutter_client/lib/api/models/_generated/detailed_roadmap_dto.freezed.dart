// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../detailed_roadmap_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DetailedRoadmapResponse _$DetailedRoadmapResponseFromJson(
    Map<String, dynamic> json) {
  return _DetailedRoadmapResponse.fromJson(json);
}

/// @nodoc
mixin _$DetailedRoadmapResponse {
  String get mapId => throw _privateConstructorUsedError;
  List<Node> get nodes => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this DetailedRoadmapResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DetailedRoadmapResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DetailedRoadmapResponseCopyWith<DetailedRoadmapResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DetailedRoadmapResponseCopyWith<$Res> {
  factory $DetailedRoadmapResponseCopyWith(DetailedRoadmapResponse value,
          $Res Function(DetailedRoadmapResponse) then) =
      _$DetailedRoadmapResponseCopyWithImpl<$Res, DetailedRoadmapResponse>;
  @useResult
  $Res call({String mapId, List<Node> nodes, String? message});
}

/// @nodoc
class _$DetailedRoadmapResponseCopyWithImpl<$Res,
        $Val extends DetailedRoadmapResponse>
    implements $DetailedRoadmapResponseCopyWith<$Res> {
  _$DetailedRoadmapResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DetailedRoadmapResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mapId = null,
    Object? nodes = null,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      mapId: null == mapId
          ? _value.mapId
          : mapId // ignore: cast_nullable_to_non_nullable
              as String,
      nodes: null == nodes
          ? _value.nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as List<Node>,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DetailedRoadmapResponseImplCopyWith<$Res>
    implements $DetailedRoadmapResponseCopyWith<$Res> {
  factory _$$DetailedRoadmapResponseImplCopyWith(
          _$DetailedRoadmapResponseImpl value,
          $Res Function(_$DetailedRoadmapResponseImpl) then) =
      __$$DetailedRoadmapResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String mapId, List<Node> nodes, String? message});
}

/// @nodoc
class __$$DetailedRoadmapResponseImplCopyWithImpl<$Res>
    extends _$DetailedRoadmapResponseCopyWithImpl<$Res,
        _$DetailedRoadmapResponseImpl>
    implements _$$DetailedRoadmapResponseImplCopyWith<$Res> {
  __$$DetailedRoadmapResponseImplCopyWithImpl(
      _$DetailedRoadmapResponseImpl _value,
      $Res Function(_$DetailedRoadmapResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of DetailedRoadmapResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mapId = null,
    Object? nodes = null,
    Object? message = freezed,
  }) {
    return _then(_$DetailedRoadmapResponseImpl(
      mapId: null == mapId
          ? _value.mapId
          : mapId // ignore: cast_nullable_to_non_nullable
              as String,
      nodes: null == nodes
          ? _value._nodes
          : nodes // ignore: cast_nullable_to_non_nullable
              as List<Node>,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DetailedRoadmapResponseImpl implements _DetailedRoadmapResponse {
  const _$DetailedRoadmapResponseImpl(
      {required this.mapId, required final List<Node> nodes, this.message})
      : _nodes = nodes;

  factory _$DetailedRoadmapResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$DetailedRoadmapResponseImplFromJson(json);

  @override
  final String mapId;
  final List<Node> _nodes;
  @override
  List<Node> get nodes {
    if (_nodes is EqualUnmodifiableListView) return _nodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nodes);
  }

  @override
  final String? message;

  @override
  String toString() {
    return 'DetailedRoadmapResponse(mapId: $mapId, nodes: $nodes, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DetailedRoadmapResponseImpl &&
            (identical(other.mapId, mapId) || other.mapId == mapId) &&
            const DeepCollectionEquality().equals(other._nodes, _nodes) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, mapId, const DeepCollectionEquality().hash(_nodes), message);

  /// Create a copy of DetailedRoadmapResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DetailedRoadmapResponseImplCopyWith<_$DetailedRoadmapResponseImpl>
      get copyWith => __$$DetailedRoadmapResponseImplCopyWithImpl<
          _$DetailedRoadmapResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DetailedRoadmapResponseImplToJson(
      this,
    );
  }
}

abstract class _DetailedRoadmapResponse implements DetailedRoadmapResponse {
  const factory _DetailedRoadmapResponse(
      {required final String mapId,
      required final List<Node> nodes,
      final String? message}) = _$DetailedRoadmapResponseImpl;

  factory _DetailedRoadmapResponse.fromJson(Map<String, dynamic> json) =
      _$DetailedRoadmapResponseImpl.fromJson;

  @override
  String get mapId;
  @override
  List<Node> get nodes;
  @override
  String? get message;

  /// Create a copy of DetailedRoadmapResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DetailedRoadmapResponseImplCopyWith<_$DetailedRoadmapResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
