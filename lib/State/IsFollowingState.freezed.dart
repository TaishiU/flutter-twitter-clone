// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'IsFollowingState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$IsFollowingStateTearOff {
  const _$IsFollowingStateTearOff();

  _IsFollowingState call({bool isFollowingUser = false}) {
    return _IsFollowingState(
      isFollowingUser: isFollowingUser,
    );
  }
}

/// @nodoc
const $IsFollowingState = _$IsFollowingStateTearOff();

/// @nodoc
mixin _$IsFollowingState {
  bool get isFollowingUser => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $IsFollowingStateCopyWith<IsFollowingState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IsFollowingStateCopyWith<$Res> {
  factory $IsFollowingStateCopyWith(
          IsFollowingState value, $Res Function(IsFollowingState) then) =
      _$IsFollowingStateCopyWithImpl<$Res>;
  $Res call({bool isFollowingUser});
}

/// @nodoc
class _$IsFollowingStateCopyWithImpl<$Res>
    implements $IsFollowingStateCopyWith<$Res> {
  _$IsFollowingStateCopyWithImpl(this._value, this._then);

  final IsFollowingState _value;
  // ignore: unused_field
  final $Res Function(IsFollowingState) _then;

  @override
  $Res call({
    Object? isFollowingUser = freezed,
  }) {
    return _then(_value.copyWith(
      isFollowingUser: isFollowingUser == freezed
          ? _value.isFollowingUser
          : isFollowingUser // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$IsFollowingStateCopyWith<$Res>
    implements $IsFollowingStateCopyWith<$Res> {
  factory _$IsFollowingStateCopyWith(
          _IsFollowingState value, $Res Function(_IsFollowingState) then) =
      __$IsFollowingStateCopyWithImpl<$Res>;
  @override
  $Res call({bool isFollowingUser});
}

/// @nodoc
class __$IsFollowingStateCopyWithImpl<$Res>
    extends _$IsFollowingStateCopyWithImpl<$Res>
    implements _$IsFollowingStateCopyWith<$Res> {
  __$IsFollowingStateCopyWithImpl(
      _IsFollowingState _value, $Res Function(_IsFollowingState) _then)
      : super(_value, (v) => _then(v as _IsFollowingState));

  @override
  _IsFollowingState get _value => super._value as _IsFollowingState;

  @override
  $Res call({
    Object? isFollowingUser = freezed,
  }) {
    return _then(_IsFollowingState(
      isFollowingUser: isFollowingUser == freezed
          ? _value.isFollowingUser
          : isFollowingUser // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_IsFollowingState implements _IsFollowingState {
  const _$_IsFollowingState({this.isFollowingUser = false});

  @JsonKey(defaultValue: false)
  @override
  final bool isFollowingUser;

  @override
  String toString() {
    return 'IsFollowingState(isFollowingUser: $isFollowingUser)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _IsFollowingState &&
            (identical(other.isFollowingUser, isFollowingUser) ||
                const DeepCollectionEquality()
                    .equals(other.isFollowingUser, isFollowingUser)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(isFollowingUser);

  @JsonKey(ignore: true)
  @override
  _$IsFollowingStateCopyWith<_IsFollowingState> get copyWith =>
      __$IsFollowingStateCopyWithImpl<_IsFollowingState>(this, _$identity);
}

abstract class _IsFollowingState implements IsFollowingState {
  const factory _IsFollowingState({bool isFollowingUser}) = _$_IsFollowingState;

  @override
  bool get isFollowingUser => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$IsFollowingStateCopyWith<_IsFollowingState> get copyWith =>
      throw _privateConstructorUsedError;
}
