// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'FcmTokenState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$FcmTokenStateTearOff {
  const _$FcmTokenStateTearOff();

  _FcmTokenState call({String? fcmToken}) {
    return _FcmTokenState(
      fcmToken: fcmToken,
    );
  }
}

/// @nodoc
const $FcmTokenState = _$FcmTokenStateTearOff();

/// @nodoc
mixin _$FcmTokenState {
  String? get fcmToken => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FcmTokenStateCopyWith<FcmTokenState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FcmTokenStateCopyWith<$Res> {
  factory $FcmTokenStateCopyWith(
          FcmTokenState value, $Res Function(FcmTokenState) then) =
      _$FcmTokenStateCopyWithImpl<$Res>;
  $Res call({String? fcmToken});
}

/// @nodoc
class _$FcmTokenStateCopyWithImpl<$Res>
    implements $FcmTokenStateCopyWith<$Res> {
  _$FcmTokenStateCopyWithImpl(this._value, this._then);

  final FcmTokenState _value;
  // ignore: unused_field
  final $Res Function(FcmTokenState) _then;

  @override
  $Res call({
    Object? fcmToken = freezed,
  }) {
    return _then(_value.copyWith(
      fcmToken: fcmToken == freezed
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$FcmTokenStateCopyWith<$Res>
    implements $FcmTokenStateCopyWith<$Res> {
  factory _$FcmTokenStateCopyWith(
          _FcmTokenState value, $Res Function(_FcmTokenState) then) =
      __$FcmTokenStateCopyWithImpl<$Res>;
  @override
  $Res call({String? fcmToken});
}

/// @nodoc
class __$FcmTokenStateCopyWithImpl<$Res>
    extends _$FcmTokenStateCopyWithImpl<$Res>
    implements _$FcmTokenStateCopyWith<$Res> {
  __$FcmTokenStateCopyWithImpl(
      _FcmTokenState _value, $Res Function(_FcmTokenState) _then)
      : super(_value, (v) => _then(v as _FcmTokenState));

  @override
  _FcmTokenState get _value => super._value as _FcmTokenState;

  @override
  $Res call({
    Object? fcmToken = freezed,
  }) {
    return _then(_FcmTokenState(
      fcmToken: fcmToken == freezed
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_FcmTokenState implements _FcmTokenState {
  const _$_FcmTokenState({this.fcmToken});

  @override
  final String? fcmToken;

  @override
  String toString() {
    return 'FcmTokenState(fcmToken: $fcmToken)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _FcmTokenState &&
            (identical(other.fcmToken, fcmToken) ||
                const DeepCollectionEquality()
                    .equals(other.fcmToken, fcmToken)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(fcmToken);

  @JsonKey(ignore: true)
  @override
  _$FcmTokenStateCopyWith<_FcmTokenState> get copyWith =>
      __$FcmTokenStateCopyWithImpl<_FcmTokenState>(this, _$identity);
}

abstract class _FcmTokenState implements FcmTokenState {
  const factory _FcmTokenState({String? fcmToken}) = _$_FcmTokenState;

  @override
  String? get fcmToken => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$FcmTokenStateCopyWith<_FcmTokenState> get copyWith =>
      throw _privateConstructorUsedError;
}
