// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../user_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateUserRequest _$CreateUserRequestFromJson(Map<String, dynamic> json) {
  return _CreateUserRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateUserRequest {
  String get uid => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;

  /// Serializes this CreateUserRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateUserRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateUserRequestCopyWith<CreateUserRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateUserRequestCopyWith<$Res> {
  factory $CreateUserRequestCopyWith(
          CreateUserRequest value, $Res Function(CreateUserRequest) then) =
      _$CreateUserRequestCopyWithImpl<$Res, CreateUserRequest>;
  @useResult
  $Res call({String uid, String email});
}

/// @nodoc
class _$CreateUserRequestCopyWithImpl<$Res, $Val extends CreateUserRequest>
    implements $CreateUserRequestCopyWith<$Res> {
  _$CreateUserRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateUserRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateUserRequestImplCopyWith<$Res>
    implements $CreateUserRequestCopyWith<$Res> {
  factory _$$CreateUserRequestImplCopyWith(_$CreateUserRequestImpl value,
          $Res Function(_$CreateUserRequestImpl) then) =
      __$$CreateUserRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String uid, String email});
}

/// @nodoc
class __$$CreateUserRequestImplCopyWithImpl<$Res>
    extends _$CreateUserRequestCopyWithImpl<$Res, _$CreateUserRequestImpl>
    implements _$$CreateUserRequestImplCopyWith<$Res> {
  __$$CreateUserRequestImplCopyWithImpl(_$CreateUserRequestImpl _value,
      $Res Function(_$CreateUserRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateUserRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? email = null,
  }) {
    return _then(_$CreateUserRequestImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateUserRequestImpl implements _CreateUserRequest {
  const _$CreateUserRequestImpl({required this.uid, required this.email});

  factory _$CreateUserRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateUserRequestImplFromJson(json);

  @override
  final String uid;
  @override
  final String email;

  @override
  String toString() {
    return 'CreateUserRequest(uid: $uid, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateUserRequestImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.email, email) || other.email == email));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, uid, email);

  /// Create a copy of CreateUserRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateUserRequestImplCopyWith<_$CreateUserRequestImpl> get copyWith =>
      __$$CreateUserRequestImplCopyWithImpl<_$CreateUserRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateUserRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateUserRequest implements CreateUserRequest {
  const factory _CreateUserRequest(
      {required final String uid,
      required final String email}) = _$CreateUserRequestImpl;

  factory _CreateUserRequest.fromJson(Map<String, dynamic> json) =
      _$CreateUserRequestImpl.fromJson;

  @override
  String get uid;
  @override
  String get email;

  /// Create a copy of CreateUserRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateUserRequestImplCopyWith<_$CreateUserRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateUserResponse _$CreateUserResponseFromJson(Map<String, dynamic> json) {
  return _CreateUserResponse.fromJson(json);
}

/// @nodoc
mixin _$CreateUserResponse {
  String? get id => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this CreateUserResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateUserResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateUserResponseCopyWith<CreateUserResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateUserResponseCopyWith<$Res> {
  factory $CreateUserResponseCopyWith(
          CreateUserResponse value, $Res Function(CreateUserResponse) then) =
      _$CreateUserResponseCopyWithImpl<$Res, CreateUserResponse>;
  @useResult
  $Res call({String? id, String? message});
}

/// @nodoc
class _$CreateUserResponseCopyWithImpl<$Res, $Val extends CreateUserResponse>
    implements $CreateUserResponseCopyWith<$Res> {
  _$CreateUserResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateUserResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateUserResponseImplCopyWith<$Res>
    implements $CreateUserResponseCopyWith<$Res> {
  factory _$$CreateUserResponseImplCopyWith(_$CreateUserResponseImpl value,
          $Res Function(_$CreateUserResponseImpl) then) =
      __$$CreateUserResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? id, String? message});
}

/// @nodoc
class __$$CreateUserResponseImplCopyWithImpl<$Res>
    extends _$CreateUserResponseCopyWithImpl<$Res, _$CreateUserResponseImpl>
    implements _$$CreateUserResponseImplCopyWith<$Res> {
  __$$CreateUserResponseImplCopyWithImpl(_$CreateUserResponseImpl _value,
      $Res Function(_$CreateUserResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateUserResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? message = freezed,
  }) {
    return _then(_$CreateUserResponseImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateUserResponseImpl implements _CreateUserResponse {
  const _$CreateUserResponseImpl({this.id, this.message});

  factory _$CreateUserResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateUserResponseImplFromJson(json);

  @override
  final String? id;
  @override
  final String? message;

  @override
  String toString() {
    return 'CreateUserResponse(id: $id, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateUserResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, message);

  /// Create a copy of CreateUserResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateUserResponseImplCopyWith<_$CreateUserResponseImpl> get copyWith =>
      __$$CreateUserResponseImplCopyWithImpl<_$CreateUserResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateUserResponseImplToJson(
      this,
    );
  }
}

abstract class _CreateUserResponse implements CreateUserResponse {
  const factory _CreateUserResponse({final String? id, final String? message}) =
      _$CreateUserResponseImpl;

  factory _CreateUserResponse.fromJson(Map<String, dynamic> json) =
      _$CreateUserResponseImpl.fromJson;

  @override
  String? get id;
  @override
  String? get message;

  /// Create a copy of CreateUserResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateUserResponseImplCopyWith<_$CreateUserResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CheckUserMapRequest _$CheckUserMapRequestFromJson(Map<String, dynamic> json) {
  return _CheckUserMapRequest.fromJson(json);
}

/// @nodoc
mixin _$CheckUserMapRequest {
  String get userId => throw _privateConstructorUsedError;

  /// Serializes this CheckUserMapRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CheckUserMapRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckUserMapRequestCopyWith<CheckUserMapRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckUserMapRequestCopyWith<$Res> {
  factory $CheckUserMapRequestCopyWith(
          CheckUserMapRequest value, $Res Function(CheckUserMapRequest) then) =
      _$CheckUserMapRequestCopyWithImpl<$Res, CheckUserMapRequest>;
  @useResult
  $Res call({String userId});
}

/// @nodoc
class _$CheckUserMapRequestCopyWithImpl<$Res, $Val extends CheckUserMapRequest>
    implements $CheckUserMapRequestCopyWith<$Res> {
  _$CheckUserMapRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckUserMapRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CheckUserMapRequestImplCopyWith<$Res>
    implements $CheckUserMapRequestCopyWith<$Res> {
  factory _$$CheckUserMapRequestImplCopyWith(_$CheckUserMapRequestImpl value,
          $Res Function(_$CheckUserMapRequestImpl) then) =
      __$$CheckUserMapRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userId});
}

/// @nodoc
class __$$CheckUserMapRequestImplCopyWithImpl<$Res>
    extends _$CheckUserMapRequestCopyWithImpl<$Res, _$CheckUserMapRequestImpl>
    implements _$$CheckUserMapRequestImplCopyWith<$Res> {
  __$$CheckUserMapRequestImplCopyWithImpl(_$CheckUserMapRequestImpl _value,
      $Res Function(_$CheckUserMapRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CheckUserMapRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
  }) {
    return _then(_$CheckUserMapRequestImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CheckUserMapRequestImpl implements _CheckUserMapRequest {
  const _$CheckUserMapRequestImpl({required this.userId});

  factory _$CheckUserMapRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CheckUserMapRequestImplFromJson(json);

  @override
  final String userId;

  @override
  String toString() {
    return 'CheckUserMapRequest(userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckUserMapRequestImpl &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId);

  /// Create a copy of CheckUserMapRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckUserMapRequestImplCopyWith<_$CheckUserMapRequestImpl> get copyWith =>
      __$$CheckUserMapRequestImplCopyWithImpl<_$CheckUserMapRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckUserMapRequestImplToJson(
      this,
    );
  }
}

abstract class _CheckUserMapRequest implements CheckUserMapRequest {
  const factory _CheckUserMapRequest({required final String userId}) =
      _$CheckUserMapRequestImpl;

  factory _CheckUserMapRequest.fromJson(Map<String, dynamic> json) =
      _$CheckUserMapRequestImpl.fromJson;

  @override
  String get userId;

  /// Create a copy of CheckUserMapRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckUserMapRequestImplCopyWith<_$CheckUserMapRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CheckUserMapResponse _$CheckUserMapResponseFromJson(Map<String, dynamic> json) {
  return _CheckUserMapResponse.fromJson(json);
}

/// @nodoc
mixin _$CheckUserMapResponse {
  bool get hasMap => throw _privateConstructorUsedError;
  String? get mapId => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this CheckUserMapResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CheckUserMapResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckUserMapResponseCopyWith<CheckUserMapResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckUserMapResponseCopyWith<$Res> {
  factory $CheckUserMapResponseCopyWith(CheckUserMapResponse value,
          $Res Function(CheckUserMapResponse) then) =
      _$CheckUserMapResponseCopyWithImpl<$Res, CheckUserMapResponse>;
  @useResult
  $Res call({bool hasMap, String? mapId, String? message});
}

/// @nodoc
class _$CheckUserMapResponseCopyWithImpl<$Res,
        $Val extends CheckUserMapResponse>
    implements $CheckUserMapResponseCopyWith<$Res> {
  _$CheckUserMapResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckUserMapResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasMap = null,
    Object? mapId = freezed,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      hasMap: null == hasMap
          ? _value.hasMap
          : hasMap // ignore: cast_nullable_to_non_nullable
              as bool,
      mapId: freezed == mapId
          ? _value.mapId
          : mapId // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CheckUserMapResponseImplCopyWith<$Res>
    implements $CheckUserMapResponseCopyWith<$Res> {
  factory _$$CheckUserMapResponseImplCopyWith(_$CheckUserMapResponseImpl value,
          $Res Function(_$CheckUserMapResponseImpl) then) =
      __$$CheckUserMapResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool hasMap, String? mapId, String? message});
}

/// @nodoc
class __$$CheckUserMapResponseImplCopyWithImpl<$Res>
    extends _$CheckUserMapResponseCopyWithImpl<$Res, _$CheckUserMapResponseImpl>
    implements _$$CheckUserMapResponseImplCopyWith<$Res> {
  __$$CheckUserMapResponseImplCopyWithImpl(_$CheckUserMapResponseImpl _value,
      $Res Function(_$CheckUserMapResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of CheckUserMapResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasMap = null,
    Object? mapId = freezed,
    Object? message = freezed,
  }) {
    return _then(_$CheckUserMapResponseImpl(
      hasMap: null == hasMap
          ? _value.hasMap
          : hasMap // ignore: cast_nullable_to_non_nullable
              as bool,
      mapId: freezed == mapId
          ? _value.mapId
          : mapId // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CheckUserMapResponseImpl implements _CheckUserMapResponse {
  const _$CheckUserMapResponseImpl(
      {required this.hasMap, this.mapId, this.message});

  factory _$CheckUserMapResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CheckUserMapResponseImplFromJson(json);

  @override
  final bool hasMap;
  @override
  final String? mapId;
  @override
  final String? message;

  @override
  String toString() {
    return 'CheckUserMapResponse(hasMap: $hasMap, mapId: $mapId, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckUserMapResponseImpl &&
            (identical(other.hasMap, hasMap) || other.hasMap == hasMap) &&
            (identical(other.mapId, mapId) || other.mapId == mapId) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, hasMap, mapId, message);

  /// Create a copy of CheckUserMapResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckUserMapResponseImplCopyWith<_$CheckUserMapResponseImpl>
      get copyWith =>
          __$$CheckUserMapResponseImplCopyWithImpl<_$CheckUserMapResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckUserMapResponseImplToJson(
      this,
    );
  }
}

abstract class _CheckUserMapResponse implements CheckUserMapResponse {
  const factory _CheckUserMapResponse(
      {required final bool hasMap,
      final String? mapId,
      final String? message}) = _$CheckUserMapResponseImpl;

  factory _CheckUserMapResponse.fromJson(Map<String, dynamic> json) =
      _$CheckUserMapResponseImpl.fromJson;

  @override
  bool get hasMap;
  @override
  String? get mapId;
  @override
  String? get message;

  /// Create a copy of CheckUserMapResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckUserMapResponseImplCopyWith<_$CheckUserMapResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
