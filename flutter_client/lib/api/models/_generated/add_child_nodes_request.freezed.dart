// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../add_child_nodes_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AddChildNodesRequest _$AddChildNodesRequestFromJson(Map<String, dynamic> json) {
  return _AddChildNodesRequest.fromJson(json);
}

/// @nodoc
mixin _$AddChildNodesRequest {
  String get mapId => throw _privateConstructorUsedError;
  String get nodeId => throw _privateConstructorUsedError;

  /// Serializes this AddChildNodesRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddChildNodesRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddChildNodesRequestCopyWith<AddChildNodesRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddChildNodesRequestCopyWith<$Res> {
  factory $AddChildNodesRequestCopyWith(AddChildNodesRequest value,
          $Res Function(AddChildNodesRequest) then) =
      _$AddChildNodesRequestCopyWithImpl<$Res, AddChildNodesRequest>;
  @useResult
  $Res call({String mapId, String nodeId});
}

/// @nodoc
class _$AddChildNodesRequestCopyWithImpl<$Res,
        $Val extends AddChildNodesRequest>
    implements $AddChildNodesRequestCopyWith<$Res> {
  _$AddChildNodesRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddChildNodesRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mapId = null,
    Object? nodeId = null,
  }) {
    return _then(_value.copyWith(
      mapId: null == mapId
          ? _value.mapId
          : mapId // ignore: cast_nullable_to_non_nullable
              as String,
      nodeId: null == nodeId
          ? _value.nodeId
          : nodeId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddChildNodesRequestImplCopyWith<$Res>
    implements $AddChildNodesRequestCopyWith<$Res> {
  factory _$$AddChildNodesRequestImplCopyWith(_$AddChildNodesRequestImpl value,
          $Res Function(_$AddChildNodesRequestImpl) then) =
      __$$AddChildNodesRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String mapId, String nodeId});
}

/// @nodoc
class __$$AddChildNodesRequestImplCopyWithImpl<$Res>
    extends _$AddChildNodesRequestCopyWithImpl<$Res, _$AddChildNodesRequestImpl>
    implements _$$AddChildNodesRequestImplCopyWith<$Res> {
  __$$AddChildNodesRequestImplCopyWithImpl(_$AddChildNodesRequestImpl _value,
      $Res Function(_$AddChildNodesRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddChildNodesRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mapId = null,
    Object? nodeId = null,
  }) {
    return _then(_$AddChildNodesRequestImpl(
      mapId: null == mapId
          ? _value.mapId
          : mapId // ignore: cast_nullable_to_non_nullable
              as String,
      nodeId: null == nodeId
          ? _value.nodeId
          : nodeId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AddChildNodesRequestImpl implements _AddChildNodesRequest {
  const _$AddChildNodesRequestImpl({required this.mapId, required this.nodeId});

  factory _$AddChildNodesRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddChildNodesRequestImplFromJson(json);

  @override
  final String mapId;
  @override
  final String nodeId;

  @override
  String toString() {
    return 'AddChildNodesRequest(mapId: $mapId, nodeId: $nodeId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddChildNodesRequestImpl &&
            (identical(other.mapId, mapId) || other.mapId == mapId) &&
            (identical(other.nodeId, nodeId) || other.nodeId == nodeId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, mapId, nodeId);

  /// Create a copy of AddChildNodesRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddChildNodesRequestImplCopyWith<_$AddChildNodesRequestImpl>
      get copyWith =>
          __$$AddChildNodesRequestImplCopyWithImpl<_$AddChildNodesRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddChildNodesRequestImplToJson(
      this,
    );
  }
}

abstract class _AddChildNodesRequest implements AddChildNodesRequest {
  const factory _AddChildNodesRequest(
      {required final String mapId,
      required final String nodeId}) = _$AddChildNodesRequestImpl;

  factory _AddChildNodesRequest.fromJson(Map<String, dynamic> json) =
      _$AddChildNodesRequestImpl.fromJson;

  @override
  String get mapId;
  @override
  String get nodeId;

  /// Create a copy of AddChildNodesRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddChildNodesRequestImplCopyWith<_$AddChildNodesRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
