// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../add_child_nodes_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AddChildNodesResponse _$AddChildNodesResponseFromJson(
    Map<String, dynamic> json) {
  return _AddChildNodesResponse.fromJson(json);
}

/// @nodoc
mixin _$AddChildNodesResponse {
  String get parentNodeId => throw _privateConstructorUsedError;
  List<Node> get childNodes => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  /// Serializes this AddChildNodesResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddChildNodesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddChildNodesResponseCopyWith<AddChildNodesResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddChildNodesResponseCopyWith<$Res> {
  factory $AddChildNodesResponseCopyWith(AddChildNodesResponse value,
          $Res Function(AddChildNodesResponse) then) =
      _$AddChildNodesResponseCopyWithImpl<$Res, AddChildNodesResponse>;
  @useResult
  $Res call({String parentNodeId, List<Node> childNodes, String message});
}

/// @nodoc
class _$AddChildNodesResponseCopyWithImpl<$Res,
        $Val extends AddChildNodesResponse>
    implements $AddChildNodesResponseCopyWith<$Res> {
  _$AddChildNodesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddChildNodesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? parentNodeId = null,
    Object? childNodes = null,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      parentNodeId: null == parentNodeId
          ? _value.parentNodeId
          : parentNodeId // ignore: cast_nullable_to_non_nullable
              as String,
      childNodes: null == childNodes
          ? _value.childNodes
          : childNodes // ignore: cast_nullable_to_non_nullable
              as List<Node>,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddChildNodesResponseImplCopyWith<$Res>
    implements $AddChildNodesResponseCopyWith<$Res> {
  factory _$$AddChildNodesResponseImplCopyWith(
          _$AddChildNodesResponseImpl value,
          $Res Function(_$AddChildNodesResponseImpl) then) =
      __$$AddChildNodesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String parentNodeId, List<Node> childNodes, String message});
}

/// @nodoc
class __$$AddChildNodesResponseImplCopyWithImpl<$Res>
    extends _$AddChildNodesResponseCopyWithImpl<$Res,
        _$AddChildNodesResponseImpl>
    implements _$$AddChildNodesResponseImplCopyWith<$Res> {
  __$$AddChildNodesResponseImplCopyWithImpl(_$AddChildNodesResponseImpl _value,
      $Res Function(_$AddChildNodesResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddChildNodesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? parentNodeId = null,
    Object? childNodes = null,
    Object? message = null,
  }) {
    return _then(_$AddChildNodesResponseImpl(
      parentNodeId: null == parentNodeId
          ? _value.parentNodeId
          : parentNodeId // ignore: cast_nullable_to_non_nullable
              as String,
      childNodes: null == childNodes
          ? _value._childNodes
          : childNodes // ignore: cast_nullable_to_non_nullable
              as List<Node>,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AddChildNodesResponseImpl implements _AddChildNodesResponse {
  const _$AddChildNodesResponseImpl(
      {required this.parentNodeId,
      required final List<Node> childNodes,
      required this.message})
      : _childNodes = childNodes;

  factory _$AddChildNodesResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddChildNodesResponseImplFromJson(json);

  @override
  final String parentNodeId;
  final List<Node> _childNodes;
  @override
  List<Node> get childNodes {
    if (_childNodes is EqualUnmodifiableListView) return _childNodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_childNodes);
  }

  @override
  final String message;

  @override
  String toString() {
    return 'AddChildNodesResponse(parentNodeId: $parentNodeId, childNodes: $childNodes, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddChildNodesResponseImpl &&
            (identical(other.parentNodeId, parentNodeId) ||
                other.parentNodeId == parentNodeId) &&
            const DeepCollectionEquality()
                .equals(other._childNodes, _childNodes) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, parentNodeId,
      const DeepCollectionEquality().hash(_childNodes), message);

  /// Create a copy of AddChildNodesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddChildNodesResponseImplCopyWith<_$AddChildNodesResponseImpl>
      get copyWith => __$$AddChildNodesResponseImplCopyWithImpl<
          _$AddChildNodesResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddChildNodesResponseImplToJson(
      this,
    );
  }
}

abstract class _AddChildNodesResponse implements AddChildNodesResponse {
  const factory _AddChildNodesResponse(
      {required final String parentNodeId,
      required final List<Node> childNodes,
      required final String message}) = _$AddChildNodesResponseImpl;

  factory _AddChildNodesResponse.fromJson(Map<String, dynamic> json) =
      _$AddChildNodesResponseImpl.fromJson;

  @override
  String get parentNodeId;
  @override
  List<Node> get childNodes;
  @override
  String get message;

  /// Create a copy of AddChildNodesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddChildNodesResponseImplCopyWith<_$AddChildNodesResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
