// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../complete_node_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CompleteNodeRequest _$CompleteNodeRequestFromJson(Map<String, dynamic> json) {
  return _CompleteNodeRequest.fromJson(json);
}

/// @nodoc
mixin _$CompleteNodeRequest {
  String get mapId => throw _privateConstructorUsedError;
  String get nodeId => throw _privateConstructorUsedError;

  /// Serializes this CompleteNodeRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompleteNodeRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompleteNodeRequestCopyWith<CompleteNodeRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompleteNodeRequestCopyWith<$Res> {
  factory $CompleteNodeRequestCopyWith(
          CompleteNodeRequest value, $Res Function(CompleteNodeRequest) then) =
      _$CompleteNodeRequestCopyWithImpl<$Res, CompleteNodeRequest>;
  @useResult
  $Res call({String mapId, String nodeId});
}

/// @nodoc
class _$CompleteNodeRequestCopyWithImpl<$Res, $Val extends CompleteNodeRequest>
    implements $CompleteNodeRequestCopyWith<$Res> {
  _$CompleteNodeRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompleteNodeRequest
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
abstract class _$$CompleteNodeRequestImplCopyWith<$Res>
    implements $CompleteNodeRequestCopyWith<$Res> {
  factory _$$CompleteNodeRequestImplCopyWith(_$CompleteNodeRequestImpl value,
          $Res Function(_$CompleteNodeRequestImpl) then) =
      __$$CompleteNodeRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String mapId, String nodeId});
}

/// @nodoc
class __$$CompleteNodeRequestImplCopyWithImpl<$Res>
    extends _$CompleteNodeRequestCopyWithImpl<$Res, _$CompleteNodeRequestImpl>
    implements _$$CompleteNodeRequestImplCopyWith<$Res> {
  __$$CompleteNodeRequestImplCopyWithImpl(_$CompleteNodeRequestImpl _value,
      $Res Function(_$CompleteNodeRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CompleteNodeRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mapId = null,
    Object? nodeId = null,
  }) {
    return _then(_$CompleteNodeRequestImpl(
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
class _$CompleteNodeRequestImpl implements _CompleteNodeRequest {
  const _$CompleteNodeRequestImpl({required this.mapId, required this.nodeId});

  factory _$CompleteNodeRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompleteNodeRequestImplFromJson(json);

  @override
  final String mapId;
  @override
  final String nodeId;

  @override
  String toString() {
    return 'CompleteNodeRequest(mapId: $mapId, nodeId: $nodeId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompleteNodeRequestImpl &&
            (identical(other.mapId, mapId) || other.mapId == mapId) &&
            (identical(other.nodeId, nodeId) || other.nodeId == nodeId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, mapId, nodeId);

  /// Create a copy of CompleteNodeRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompleteNodeRequestImplCopyWith<_$CompleteNodeRequestImpl> get copyWith =>
      __$$CompleteNodeRequestImplCopyWithImpl<_$CompleteNodeRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompleteNodeRequestImplToJson(
      this,
    );
  }
}

abstract class _CompleteNodeRequest implements CompleteNodeRequest {
  const factory _CompleteNodeRequest(
      {required final String mapId,
      required final String nodeId}) = _$CompleteNodeRequestImpl;

  factory _CompleteNodeRequest.fromJson(Map<String, dynamic> json) =
      _$CompleteNodeRequestImpl.fromJson;

  @override
  String get mapId;
  @override
  String get nodeId;

  /// Create a copy of CompleteNodeRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompleteNodeRequestImplCopyWith<_$CompleteNodeRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
