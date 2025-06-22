// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../complete_node_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CompleteNodeResponse _$CompleteNodeResponseFromJson(Map<String, dynamic> json) {
  return _CompleteNodeResponse.fromJson(json);
}

/// @nodoc
mixin _$CompleteNodeResponse {
  Node? get node => throw _privateConstructorUsedError;
  List<Node> get completedNodes => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  /// Serializes this CompleteNodeResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CompleteNodeResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CompleteNodeResponseCopyWith<CompleteNodeResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompleteNodeResponseCopyWith<$Res> {
  factory $CompleteNodeResponseCopyWith(CompleteNodeResponse value,
          $Res Function(CompleteNodeResponse) then) =
      _$CompleteNodeResponseCopyWithImpl<$Res, CompleteNodeResponse>;
  @useResult
  $Res call({Node? node, List<Node> completedNodes, String message});

  $NodeCopyWith<$Res>? get node;
}

/// @nodoc
class _$CompleteNodeResponseCopyWithImpl<$Res,
        $Val extends CompleteNodeResponse>
    implements $CompleteNodeResponseCopyWith<$Res> {
  _$CompleteNodeResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CompleteNodeResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? node = freezed,
    Object? completedNodes = null,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      node: freezed == node
          ? _value.node
          : node // ignore: cast_nullable_to_non_nullable
              as Node?,
      completedNodes: null == completedNodes
          ? _value.completedNodes
          : completedNodes // ignore: cast_nullable_to_non_nullable
              as List<Node>,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  /// Create a copy of CompleteNodeResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NodeCopyWith<$Res>? get node {
    if (_value.node == null) {
      return null;
    }

    return $NodeCopyWith<$Res>(_value.node!, (value) {
      return _then(_value.copyWith(node: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CompleteNodeResponseImplCopyWith<$Res>
    implements $CompleteNodeResponseCopyWith<$Res> {
  factory _$$CompleteNodeResponseImplCopyWith(_$CompleteNodeResponseImpl value,
          $Res Function(_$CompleteNodeResponseImpl) then) =
      __$$CompleteNodeResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Node? node, List<Node> completedNodes, String message});

  @override
  $NodeCopyWith<$Res>? get node;
}

/// @nodoc
class __$$CompleteNodeResponseImplCopyWithImpl<$Res>
    extends _$CompleteNodeResponseCopyWithImpl<$Res, _$CompleteNodeResponseImpl>
    implements _$$CompleteNodeResponseImplCopyWith<$Res> {
  __$$CompleteNodeResponseImplCopyWithImpl(_$CompleteNodeResponseImpl _value,
      $Res Function(_$CompleteNodeResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of CompleteNodeResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? node = freezed,
    Object? completedNodes = null,
    Object? message = null,
  }) {
    return _then(_$CompleteNodeResponseImpl(
      node: freezed == node
          ? _value.node
          : node // ignore: cast_nullable_to_non_nullable
              as Node?,
      completedNodes: null == completedNodes
          ? _value._completedNodes
          : completedNodes // ignore: cast_nullable_to_non_nullable
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
class _$CompleteNodeResponseImpl implements _CompleteNodeResponse {
  const _$CompleteNodeResponseImpl(
      {this.node,
      final List<Node> completedNodes = const [],
      required this.message})
      : _completedNodes = completedNodes;

  factory _$CompleteNodeResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompleteNodeResponseImplFromJson(json);

  @override
  final Node? node;
  final List<Node> _completedNodes;
  @override
  @JsonKey()
  List<Node> get completedNodes {
    if (_completedNodes is EqualUnmodifiableListView) return _completedNodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_completedNodes);
  }

  @override
  final String message;

  @override
  String toString() {
    return 'CompleteNodeResponse(node: $node, completedNodes: $completedNodes, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompleteNodeResponseImpl &&
            (identical(other.node, node) || other.node == node) &&
            const DeepCollectionEquality()
                .equals(other._completedNodes, _completedNodes) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, node,
      const DeepCollectionEquality().hash(_completedNodes), message);

  /// Create a copy of CompleteNodeResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CompleteNodeResponseImplCopyWith<_$CompleteNodeResponseImpl>
      get copyWith =>
          __$$CompleteNodeResponseImplCopyWithImpl<_$CompleteNodeResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompleteNodeResponseImplToJson(
      this,
    );
  }
}

abstract class _CompleteNodeResponse implements CompleteNodeResponse {
  const factory _CompleteNodeResponse(
      {final Node? node,
      final List<Node> completedNodes,
      required final String message}) = _$CompleteNodeResponseImpl;

  factory _CompleteNodeResponse.fromJson(Map<String, dynamic> json) =
      _$CompleteNodeResponseImpl.fromJson;

  @override
  Node? get node;
  @override
  List<Node> get completedNodes;
  @override
  String get message;

  /// Create a copy of CompleteNodeResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CompleteNodeResponseImplCopyWith<_$CompleteNodeResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
