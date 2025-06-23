// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../user_profile_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CreateUserWithProfileRequest _$CreateUserWithProfileRequestFromJson(
    Map<String, dynamic> json) {
  return _CreateUserWithProfileRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateUserWithProfileRequest {
  String get uid => throw _privateConstructorUsedError;
  String get nickname => throw _privateConstructorUsedError;
  int get age => throw _privateConstructorUsedError;
  UserType get userType => throw _privateConstructorUsedError;
  int get availableHoursPerDay => throw _privateConstructorUsedError;
  int get availableDaysPerWeek => throw _privateConstructorUsedError;
  ExperienceLevel get experienceLevel => throw _privateConstructorUsedError;

  /// Serializes this CreateUserWithProfileRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateUserWithProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateUserWithProfileRequestCopyWith<CreateUserWithProfileRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateUserWithProfileRequestCopyWith<$Res> {
  factory $CreateUserWithProfileRequestCopyWith(
          CreateUserWithProfileRequest value,
          $Res Function(CreateUserWithProfileRequest) then) =
      _$CreateUserWithProfileRequestCopyWithImpl<$Res,
          CreateUserWithProfileRequest>;
  @useResult
  $Res call(
      {String uid,
      String nickname,
      int age,
      UserType userType,
      int availableHoursPerDay,
      int availableDaysPerWeek,
      ExperienceLevel experienceLevel});
}

/// @nodoc
class _$CreateUserWithProfileRequestCopyWithImpl<$Res,
        $Val extends CreateUserWithProfileRequest>
    implements $CreateUserWithProfileRequestCopyWith<$Res> {
  _$CreateUserWithProfileRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateUserWithProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? nickname = null,
    Object? age = null,
    Object? userType = null,
    Object? availableHoursPerDay = null,
    Object? availableDaysPerWeek = null,
    Object? experienceLevel = null,
  }) {
    return _then(_value.copyWith(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      age: null == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
      userType: null == userType
          ? _value.userType
          : userType // ignore: cast_nullable_to_non_nullable
              as UserType,
      availableHoursPerDay: null == availableHoursPerDay
          ? _value.availableHoursPerDay
          : availableHoursPerDay // ignore: cast_nullable_to_non_nullable
              as int,
      availableDaysPerWeek: null == availableDaysPerWeek
          ? _value.availableDaysPerWeek
          : availableDaysPerWeek // ignore: cast_nullable_to_non_nullable
              as int,
      experienceLevel: null == experienceLevel
          ? _value.experienceLevel
          : experienceLevel // ignore: cast_nullable_to_non_nullable
              as ExperienceLevel,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateUserWithProfileRequestImplCopyWith<$Res>
    implements $CreateUserWithProfileRequestCopyWith<$Res> {
  factory _$$CreateUserWithProfileRequestImplCopyWith(
          _$CreateUserWithProfileRequestImpl value,
          $Res Function(_$CreateUserWithProfileRequestImpl) then) =
      __$$CreateUserWithProfileRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String uid,
      String nickname,
      int age,
      UserType userType,
      int availableHoursPerDay,
      int availableDaysPerWeek,
      ExperienceLevel experienceLevel});
}

/// @nodoc
class __$$CreateUserWithProfileRequestImplCopyWithImpl<$Res>
    extends _$CreateUserWithProfileRequestCopyWithImpl<$Res,
        _$CreateUserWithProfileRequestImpl>
    implements _$$CreateUserWithProfileRequestImplCopyWith<$Res> {
  __$$CreateUserWithProfileRequestImplCopyWithImpl(
      _$CreateUserWithProfileRequestImpl _value,
      $Res Function(_$CreateUserWithProfileRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateUserWithProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? nickname = null,
    Object? age = null,
    Object? userType = null,
    Object? availableHoursPerDay = null,
    Object? availableDaysPerWeek = null,
    Object? experienceLevel = null,
  }) {
    return _then(_$CreateUserWithProfileRequestImpl(
      uid: null == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      age: null == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
      userType: null == userType
          ? _value.userType
          : userType // ignore: cast_nullable_to_non_nullable
              as UserType,
      availableHoursPerDay: null == availableHoursPerDay
          ? _value.availableHoursPerDay
          : availableHoursPerDay // ignore: cast_nullable_to_non_nullable
              as int,
      availableDaysPerWeek: null == availableDaysPerWeek
          ? _value.availableDaysPerWeek
          : availableDaysPerWeek // ignore: cast_nullable_to_non_nullable
              as int,
      experienceLevel: null == experienceLevel
          ? _value.experienceLevel
          : experienceLevel // ignore: cast_nullable_to_non_nullable
              as ExperienceLevel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateUserWithProfileRequestImpl
    implements _CreateUserWithProfileRequest {
  const _$CreateUserWithProfileRequestImpl(
      {required this.uid,
      required this.nickname,
      required this.age,
      required this.userType,
      required this.availableHoursPerDay,
      required this.availableDaysPerWeek,
      required this.experienceLevel});

  factory _$CreateUserWithProfileRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$CreateUserWithProfileRequestImplFromJson(json);

  @override
  final String uid;
  @override
  final String nickname;
  @override
  final int age;
  @override
  final UserType userType;
  @override
  final int availableHoursPerDay;
  @override
  final int availableDaysPerWeek;
  @override
  final ExperienceLevel experienceLevel;

  @override
  String toString() {
    return 'CreateUserWithProfileRequest(uid: $uid, nickname: $nickname, age: $age, userType: $userType, availableHoursPerDay: $availableHoursPerDay, availableDaysPerWeek: $availableDaysPerWeek, experienceLevel: $experienceLevel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateUserWithProfileRequestImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.userType, userType) ||
                other.userType == userType) &&
            (identical(other.availableHoursPerDay, availableHoursPerDay) ||
                other.availableHoursPerDay == availableHoursPerDay) &&
            (identical(other.availableDaysPerWeek, availableDaysPerWeek) ||
                other.availableDaysPerWeek == availableDaysPerWeek) &&
            (identical(other.experienceLevel, experienceLevel) ||
                other.experienceLevel == experienceLevel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, uid, nickname, age, userType,
      availableHoursPerDay, availableDaysPerWeek, experienceLevel);

  /// Create a copy of CreateUserWithProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateUserWithProfileRequestImplCopyWith<
          _$CreateUserWithProfileRequestImpl>
      get copyWith => __$$CreateUserWithProfileRequestImplCopyWithImpl<
          _$CreateUserWithProfileRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateUserWithProfileRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateUserWithProfileRequest
    implements CreateUserWithProfileRequest {
  const factory _CreateUserWithProfileRequest(
          {required final String uid,
          required final String nickname,
          required final int age,
          required final UserType userType,
          required final int availableHoursPerDay,
          required final int availableDaysPerWeek,
          required final ExperienceLevel experienceLevel}) =
      _$CreateUserWithProfileRequestImpl;

  factory _CreateUserWithProfileRequest.fromJson(Map<String, dynamic> json) =
      _$CreateUserWithProfileRequestImpl.fromJson;

  @override
  String get uid;
  @override
  String get nickname;
  @override
  int get age;
  @override
  UserType get userType;
  @override
  int get availableHoursPerDay;
  @override
  int get availableDaysPerWeek;
  @override
  ExperienceLevel get experienceLevel;

  /// Create a copy of CreateUserWithProfileRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateUserWithProfileRequestImplCopyWith<
          _$CreateUserWithProfileRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CreateUserWithProfileResponse _$CreateUserWithProfileResponseFromJson(
    Map<String, dynamic> json) {
  return _CreateUserWithProfileResponse.fromJson(json);
}

/// @nodoc
mixin _$CreateUserWithProfileResponse {
  String? get uid => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this CreateUserWithProfileResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateUserWithProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateUserWithProfileResponseCopyWith<CreateUserWithProfileResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateUserWithProfileResponseCopyWith<$Res> {
  factory $CreateUserWithProfileResponseCopyWith(
          CreateUserWithProfileResponse value,
          $Res Function(CreateUserWithProfileResponse) then) =
      _$CreateUserWithProfileResponseCopyWithImpl<$Res,
          CreateUserWithProfileResponse>;
  @useResult
  $Res call({String? uid, String? message});
}

/// @nodoc
class _$CreateUserWithProfileResponseCopyWithImpl<$Res,
        $Val extends CreateUserWithProfileResponse>
    implements $CreateUserWithProfileResponseCopyWith<$Res> {
  _$CreateUserWithProfileResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateUserWithProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateUserWithProfileResponseImplCopyWith<$Res>
    implements $CreateUserWithProfileResponseCopyWith<$Res> {
  factory _$$CreateUserWithProfileResponseImplCopyWith(
          _$CreateUserWithProfileResponseImpl value,
          $Res Function(_$CreateUserWithProfileResponseImpl) then) =
      __$$CreateUserWithProfileResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? uid, String? message});
}

/// @nodoc
class __$$CreateUserWithProfileResponseImplCopyWithImpl<$Res>
    extends _$CreateUserWithProfileResponseCopyWithImpl<$Res,
        _$CreateUserWithProfileResponseImpl>
    implements _$$CreateUserWithProfileResponseImplCopyWith<$Res> {
  __$$CreateUserWithProfileResponseImplCopyWithImpl(
      _$CreateUserWithProfileResponseImpl _value,
      $Res Function(_$CreateUserWithProfileResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateUserWithProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = freezed,
    Object? message = freezed,
  }) {
    return _then(_$CreateUserWithProfileResponseImpl(
      uid: freezed == uid
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
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
class _$CreateUserWithProfileResponseImpl
    implements _CreateUserWithProfileResponse {
  const _$CreateUserWithProfileResponseImpl({this.uid, this.message});

  factory _$CreateUserWithProfileResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$CreateUserWithProfileResponseImplFromJson(json);

  @override
  final String? uid;
  @override
  final String? message;

  @override
  String toString() {
    return 'CreateUserWithProfileResponse(uid: $uid, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateUserWithProfileResponseImpl &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, uid, message);

  /// Create a copy of CreateUserWithProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateUserWithProfileResponseImplCopyWith<
          _$CreateUserWithProfileResponseImpl>
      get copyWith => __$$CreateUserWithProfileResponseImplCopyWithImpl<
          _$CreateUserWithProfileResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateUserWithProfileResponseImplToJson(
      this,
    );
  }
}

abstract class _CreateUserWithProfileResponse
    implements CreateUserWithProfileResponse {
  const factory _CreateUserWithProfileResponse(
      {final String? uid,
      final String? message}) = _$CreateUserWithProfileResponseImpl;

  factory _CreateUserWithProfileResponse.fromJson(Map<String, dynamic> json) =
      _$CreateUserWithProfileResponseImpl.fromJson;

  @override
  String? get uid;
  @override
  String? get message;

  /// Create a copy of CreateUserWithProfileResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateUserWithProfileResponseImplCopyWith<
          _$CreateUserWithProfileResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UserMapsListRequest _$UserMapsListRequestFromJson(Map<String, dynamic> json) {
  return _UserMapsListRequest.fromJson(json);
}

/// @nodoc
mixin _$UserMapsListRequest {
  String get userId => throw _privateConstructorUsedError;

  /// Serializes this UserMapsListRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserMapsListRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserMapsListRequestCopyWith<UserMapsListRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserMapsListRequestCopyWith<$Res> {
  factory $UserMapsListRequestCopyWith(
          UserMapsListRequest value, $Res Function(UserMapsListRequest) then) =
      _$UserMapsListRequestCopyWithImpl<$Res, UserMapsListRequest>;
  @useResult
  $Res call({String userId});
}

/// @nodoc
class _$UserMapsListRequestCopyWithImpl<$Res, $Val extends UserMapsListRequest>
    implements $UserMapsListRequestCopyWith<$Res> {
  _$UserMapsListRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserMapsListRequest
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
abstract class _$$UserMapsListRequestImplCopyWith<$Res>
    implements $UserMapsListRequestCopyWith<$Res> {
  factory _$$UserMapsListRequestImplCopyWith(_$UserMapsListRequestImpl value,
          $Res Function(_$UserMapsListRequestImpl) then) =
      __$$UserMapsListRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userId});
}

/// @nodoc
class __$$UserMapsListRequestImplCopyWithImpl<$Res>
    extends _$UserMapsListRequestCopyWithImpl<$Res, _$UserMapsListRequestImpl>
    implements _$$UserMapsListRequestImplCopyWith<$Res> {
  __$$UserMapsListRequestImplCopyWithImpl(_$UserMapsListRequestImpl _value,
      $Res Function(_$UserMapsListRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserMapsListRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
  }) {
    return _then(_$UserMapsListRequestImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserMapsListRequestImpl implements _UserMapsListRequest {
  const _$UserMapsListRequestImpl({required this.userId});

  factory _$UserMapsListRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserMapsListRequestImplFromJson(json);

  @override
  final String userId;

  @override
  String toString() {
    return 'UserMapsListRequest(userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserMapsListRequestImpl &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId);

  /// Create a copy of UserMapsListRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserMapsListRequestImplCopyWith<_$UserMapsListRequestImpl> get copyWith =>
      __$$UserMapsListRequestImplCopyWithImpl<_$UserMapsListRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserMapsListRequestImplToJson(
      this,
    );
  }
}

abstract class _UserMapsListRequest implements UserMapsListRequest {
  const factory _UserMapsListRequest({required final String userId}) =
      _$UserMapsListRequestImpl;

  factory _UserMapsListRequest.fromJson(Map<String, dynamic> json) =
      _$UserMapsListRequestImpl.fromJson;

  @override
  String get userId;

  /// Create a copy of UserMapsListRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserMapsListRequestImplCopyWith<_$UserMapsListRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserMapsListResponse _$UserMapsListResponseFromJson(Map<String, dynamic> json) {
  return _UserMapsListResponse.fromJson(json);
}

/// @nodoc
mixin _$UserMapsListResponse {
  List<MapSummary> get maps => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this UserMapsListResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserMapsListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserMapsListResponseCopyWith<UserMapsListResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserMapsListResponseCopyWith<$Res> {
  factory $UserMapsListResponseCopyWith(UserMapsListResponse value,
          $Res Function(UserMapsListResponse) then) =
      _$UserMapsListResponseCopyWithImpl<$Res, UserMapsListResponse>;
  @useResult
  $Res call({List<MapSummary> maps, String? message});
}

/// @nodoc
class _$UserMapsListResponseCopyWithImpl<$Res,
        $Val extends UserMapsListResponse>
    implements $UserMapsListResponseCopyWith<$Res> {
  _$UserMapsListResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserMapsListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maps = null,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      maps: null == maps
          ? _value.maps
          : maps // ignore: cast_nullable_to_non_nullable
              as List<MapSummary>,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserMapsListResponseImplCopyWith<$Res>
    implements $UserMapsListResponseCopyWith<$Res> {
  factory _$$UserMapsListResponseImplCopyWith(_$UserMapsListResponseImpl value,
          $Res Function(_$UserMapsListResponseImpl) then) =
      __$$UserMapsListResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<MapSummary> maps, String? message});
}

/// @nodoc
class __$$UserMapsListResponseImplCopyWithImpl<$Res>
    extends _$UserMapsListResponseCopyWithImpl<$Res, _$UserMapsListResponseImpl>
    implements _$$UserMapsListResponseImplCopyWith<$Res> {
  __$$UserMapsListResponseImplCopyWithImpl(_$UserMapsListResponseImpl _value,
      $Res Function(_$UserMapsListResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserMapsListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? maps = null,
    Object? message = freezed,
  }) {
    return _then(_$UserMapsListResponseImpl(
      maps: null == maps
          ? _value._maps
          : maps // ignore: cast_nullable_to_non_nullable
              as List<MapSummary>,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserMapsListResponseImpl implements _UserMapsListResponse {
  const _$UserMapsListResponseImpl(
      {required final List<MapSummary> maps, this.message})
      : _maps = maps;

  factory _$UserMapsListResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserMapsListResponseImplFromJson(json);

  final List<MapSummary> _maps;
  @override
  List<MapSummary> get maps {
    if (_maps is EqualUnmodifiableListView) return _maps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_maps);
  }

  @override
  final String? message;

  @override
  String toString() {
    return 'UserMapsListResponse(maps: $maps, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserMapsListResponseImpl &&
            const DeepCollectionEquality().equals(other._maps, _maps) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_maps), message);

  /// Create a copy of UserMapsListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserMapsListResponseImplCopyWith<_$UserMapsListResponseImpl>
      get copyWith =>
          __$$UserMapsListResponseImplCopyWithImpl<_$UserMapsListResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserMapsListResponseImplToJson(
      this,
    );
  }
}

abstract class _UserMapsListResponse implements UserMapsListResponse {
  const factory _UserMapsListResponse(
      {required final List<MapSummary> maps,
      final String? message}) = _$UserMapsListResponseImpl;

  factory _UserMapsListResponse.fromJson(Map<String, dynamic> json) =
      _$UserMapsListResponseImpl.fromJson;

  @override
  List<MapSummary> get maps;
  @override
  String? get message;

  /// Create a copy of UserMapsListResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserMapsListResponseImplCopyWith<_$UserMapsListResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

MapSummary _$MapSummaryFromJson(Map<String, dynamic> json) {
  return _MapSummary.fromJson(json);
}

/// @nodoc
mixin _$MapSummary {
  String get mapId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get objective => throw _privateConstructorUsedError;
  String? get deadline => throw _privateConstructorUsedError;

  /// Serializes this MapSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MapSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MapSummaryCopyWith<MapSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapSummaryCopyWith<$Res> {
  factory $MapSummaryCopyWith(
          MapSummary value, $Res Function(MapSummary) then) =
      _$MapSummaryCopyWithImpl<$Res, MapSummary>;
  @useResult
  $Res call({String mapId, String title, String objective, String? deadline});
}

/// @nodoc
class _$MapSummaryCopyWithImpl<$Res, $Val extends MapSummary>
    implements $MapSummaryCopyWith<$Res> {
  _$MapSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MapSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mapId = null,
    Object? title = null,
    Object? objective = null,
    Object? deadline = freezed,
  }) {
    return _then(_value.copyWith(
      mapId: null == mapId
          ? _value.mapId
          : mapId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      objective: null == objective
          ? _value.objective
          : objective // ignore: cast_nullable_to_non_nullable
              as String,
      deadline: freezed == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MapSummaryImplCopyWith<$Res>
    implements $MapSummaryCopyWith<$Res> {
  factory _$$MapSummaryImplCopyWith(
          _$MapSummaryImpl value, $Res Function(_$MapSummaryImpl) then) =
      __$$MapSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String mapId, String title, String objective, String? deadline});
}

/// @nodoc
class __$$MapSummaryImplCopyWithImpl<$Res>
    extends _$MapSummaryCopyWithImpl<$Res, _$MapSummaryImpl>
    implements _$$MapSummaryImplCopyWith<$Res> {
  __$$MapSummaryImplCopyWithImpl(
      _$MapSummaryImpl _value, $Res Function(_$MapSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of MapSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mapId = null,
    Object? title = null,
    Object? objective = null,
    Object? deadline = freezed,
  }) {
    return _then(_$MapSummaryImpl(
      mapId: null == mapId
          ? _value.mapId
          : mapId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      objective: null == objective
          ? _value.objective
          : objective // ignore: cast_nullable_to_non_nullable
              as String,
      deadline: freezed == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MapSummaryImpl implements _MapSummary {
  const _$MapSummaryImpl(
      {required this.mapId,
      required this.title,
      required this.objective,
      this.deadline});

  factory _$MapSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$MapSummaryImplFromJson(json);

  @override
  final String mapId;
  @override
  final String title;
  @override
  final String objective;
  @override
  final String? deadline;

  @override
  String toString() {
    return 'MapSummary(mapId: $mapId, title: $title, objective: $objective, deadline: $deadline)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MapSummaryImpl &&
            (identical(other.mapId, mapId) || other.mapId == mapId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.objective, objective) ||
                other.objective == objective) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, mapId, title, objective, deadline);

  /// Create a copy of MapSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MapSummaryImplCopyWith<_$MapSummaryImpl> get copyWith =>
      __$$MapSummaryImplCopyWithImpl<_$MapSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MapSummaryImplToJson(
      this,
    );
  }
}

abstract class _MapSummary implements MapSummary {
  const factory _MapSummary(
      {required final String mapId,
      required final String title,
      required final String objective,
      final String? deadline}) = _$MapSummaryImpl;

  factory _MapSummary.fromJson(Map<String, dynamic> json) =
      _$MapSummaryImpl.fromJson;

  @override
  String get mapId;
  @override
  String get title;
  @override
  String get objective;
  @override
  String? get deadline;

  /// Create a copy of MapSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MapSummaryImplCopyWith<_$MapSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateDetailedRoadmapRequest _$CreateDetailedRoadmapRequestFromJson(
    Map<String, dynamic> json) {
  return _CreateDetailedRoadmapRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateDetailedRoadmapRequest {
  String get userId => throw _privateConstructorUsedError;
  String get goal => throw _privateConstructorUsedError;
  String get deadline => throw _privateConstructorUsedError;
  UserType get userType => throw _privateConstructorUsedError;
  int get availableHoursPerDay => throw _privateConstructorUsedError;
  int get availableDaysPerWeek => throw _privateConstructorUsedError;
  ExperienceLevel get experienceLevel => throw _privateConstructorUsedError;

  /// Serializes this CreateDetailedRoadmapRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateDetailedRoadmapRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateDetailedRoadmapRequestCopyWith<CreateDetailedRoadmapRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateDetailedRoadmapRequestCopyWith<$Res> {
  factory $CreateDetailedRoadmapRequestCopyWith(
          CreateDetailedRoadmapRequest value,
          $Res Function(CreateDetailedRoadmapRequest) then) =
      _$CreateDetailedRoadmapRequestCopyWithImpl<$Res,
          CreateDetailedRoadmapRequest>;
  @useResult
  $Res call(
      {String userId,
      String goal,
      String deadline,
      UserType userType,
      int availableHoursPerDay,
      int availableDaysPerWeek,
      ExperienceLevel experienceLevel});
}

/// @nodoc
class _$CreateDetailedRoadmapRequestCopyWithImpl<$Res,
        $Val extends CreateDetailedRoadmapRequest>
    implements $CreateDetailedRoadmapRequestCopyWith<$Res> {
  _$CreateDetailedRoadmapRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateDetailedRoadmapRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? goal = null,
    Object? deadline = null,
    Object? userType = null,
    Object? availableHoursPerDay = null,
    Object? availableDaysPerWeek = null,
    Object? experienceLevel = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      goal: null == goal
          ? _value.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as String,
      deadline: null == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as String,
      userType: null == userType
          ? _value.userType
          : userType // ignore: cast_nullable_to_non_nullable
              as UserType,
      availableHoursPerDay: null == availableHoursPerDay
          ? _value.availableHoursPerDay
          : availableHoursPerDay // ignore: cast_nullable_to_non_nullable
              as int,
      availableDaysPerWeek: null == availableDaysPerWeek
          ? _value.availableDaysPerWeek
          : availableDaysPerWeek // ignore: cast_nullable_to_non_nullable
              as int,
      experienceLevel: null == experienceLevel
          ? _value.experienceLevel
          : experienceLevel // ignore: cast_nullable_to_non_nullable
              as ExperienceLevel,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CreateDetailedRoadmapRequestImplCopyWith<$Res>
    implements $CreateDetailedRoadmapRequestCopyWith<$Res> {
  factory _$$CreateDetailedRoadmapRequestImplCopyWith(
          _$CreateDetailedRoadmapRequestImpl value,
          $Res Function(_$CreateDetailedRoadmapRequestImpl) then) =
      __$$CreateDetailedRoadmapRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      String goal,
      String deadline,
      UserType userType,
      int availableHoursPerDay,
      int availableDaysPerWeek,
      ExperienceLevel experienceLevel});
}

/// @nodoc
class __$$CreateDetailedRoadmapRequestImplCopyWithImpl<$Res>
    extends _$CreateDetailedRoadmapRequestCopyWithImpl<$Res,
        _$CreateDetailedRoadmapRequestImpl>
    implements _$$CreateDetailedRoadmapRequestImplCopyWith<$Res> {
  __$$CreateDetailedRoadmapRequestImplCopyWithImpl(
      _$CreateDetailedRoadmapRequestImpl _value,
      $Res Function(_$CreateDetailedRoadmapRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of CreateDetailedRoadmapRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? goal = null,
    Object? deadline = null,
    Object? userType = null,
    Object? availableHoursPerDay = null,
    Object? availableDaysPerWeek = null,
    Object? experienceLevel = null,
  }) {
    return _then(_$CreateDetailedRoadmapRequestImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      goal: null == goal
          ? _value.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as String,
      deadline: null == deadline
          ? _value.deadline
          : deadline // ignore: cast_nullable_to_non_nullable
              as String,
      userType: null == userType
          ? _value.userType
          : userType // ignore: cast_nullable_to_non_nullable
              as UserType,
      availableHoursPerDay: null == availableHoursPerDay
          ? _value.availableHoursPerDay
          : availableHoursPerDay // ignore: cast_nullable_to_non_nullable
              as int,
      availableDaysPerWeek: null == availableDaysPerWeek
          ? _value.availableDaysPerWeek
          : availableDaysPerWeek // ignore: cast_nullable_to_non_nullable
              as int,
      experienceLevel: null == experienceLevel
          ? _value.experienceLevel
          : experienceLevel // ignore: cast_nullable_to_non_nullable
              as ExperienceLevel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateDetailedRoadmapRequestImpl
    implements _CreateDetailedRoadmapRequest {
  const _$CreateDetailedRoadmapRequestImpl(
      {required this.userId,
      required this.goal,
      required this.deadline,
      required this.userType,
      required this.availableHoursPerDay,
      required this.availableDaysPerWeek,
      required this.experienceLevel});

  factory _$CreateDetailedRoadmapRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$CreateDetailedRoadmapRequestImplFromJson(json);

  @override
  final String userId;
  @override
  final String goal;
  @override
  final String deadline;
  @override
  final UserType userType;
  @override
  final int availableHoursPerDay;
  @override
  final int availableDaysPerWeek;
  @override
  final ExperienceLevel experienceLevel;

  @override
  String toString() {
    return 'CreateDetailedRoadmapRequest(userId: $userId, goal: $goal, deadline: $deadline, userType: $userType, availableHoursPerDay: $availableHoursPerDay, availableDaysPerWeek: $availableDaysPerWeek, experienceLevel: $experienceLevel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateDetailedRoadmapRequestImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.goal, goal) || other.goal == goal) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline) &&
            (identical(other.userType, userType) ||
                other.userType == userType) &&
            (identical(other.availableHoursPerDay, availableHoursPerDay) ||
                other.availableHoursPerDay == availableHoursPerDay) &&
            (identical(other.availableDaysPerWeek, availableDaysPerWeek) ||
                other.availableDaysPerWeek == availableDaysPerWeek) &&
            (identical(other.experienceLevel, experienceLevel) ||
                other.experienceLevel == experienceLevel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, goal, deadline, userType,
      availableHoursPerDay, availableDaysPerWeek, experienceLevel);

  /// Create a copy of CreateDetailedRoadmapRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateDetailedRoadmapRequestImplCopyWith<
          _$CreateDetailedRoadmapRequestImpl>
      get copyWith => __$$CreateDetailedRoadmapRequestImplCopyWithImpl<
          _$CreateDetailedRoadmapRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateDetailedRoadmapRequestImplToJson(
      this,
    );
  }
}

abstract class _CreateDetailedRoadmapRequest
    implements CreateDetailedRoadmapRequest {
  const factory _CreateDetailedRoadmapRequest(
          {required final String userId,
          required final String goal,
          required final String deadline,
          required final UserType userType,
          required final int availableHoursPerDay,
          required final int availableDaysPerWeek,
          required final ExperienceLevel experienceLevel}) =
      _$CreateDetailedRoadmapRequestImpl;

  factory _CreateDetailedRoadmapRequest.fromJson(Map<String, dynamic> json) =
      _$CreateDetailedRoadmapRequestImpl.fromJson;

  @override
  String get userId;
  @override
  String get goal;
  @override
  String get deadline;
  @override
  UserType get userType;
  @override
  int get availableHoursPerDay;
  @override
  int get availableDaysPerWeek;
  @override
  ExperienceLevel get experienceLevel;

  /// Create a copy of CreateDetailedRoadmapRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateDetailedRoadmapRequestImplCopyWith<
          _$CreateDetailedRoadmapRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
