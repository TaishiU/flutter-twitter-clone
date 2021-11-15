// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'SetupState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$SetupStateTearOff {
  const _$SetupStateTearOff();

  _SetupState call({bool isFollowingUser = false, bool isLikedTweet = false}) {
    return _SetupState(
      isFollowingUser: isFollowingUser,
      isLikedTweet: isLikedTweet,
    );
  }
}

/// @nodoc
const $SetupState = _$SetupStateTearOff();

/// @nodoc
mixin _$SetupState {
  bool get isFollowingUser => throw _privateConstructorUsedError;
  bool get isLikedTweet => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SetupStateCopyWith<SetupState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SetupStateCopyWith<$Res> {
  factory $SetupStateCopyWith(
          SetupState value, $Res Function(SetupState) then) =
      _$SetupStateCopyWithImpl<$Res>;
  $Res call({bool isFollowingUser, bool isLikedTweet});
}

/// @nodoc
class _$SetupStateCopyWithImpl<$Res> implements $SetupStateCopyWith<$Res> {
  _$SetupStateCopyWithImpl(this._value, this._then);

  final SetupState _value;
  // ignore: unused_field
  final $Res Function(SetupState) _then;

  @override
  $Res call({
    Object? isFollowingUser = freezed,
    Object? isLikedTweet = freezed,
  }) {
    return _then(_value.copyWith(
      isFollowingUser: isFollowingUser == freezed
          ? _value.isFollowingUser
          : isFollowingUser // ignore: cast_nullable_to_non_nullable
              as bool,
      isLikedTweet: isLikedTweet == freezed
          ? _value.isLikedTweet
          : isLikedTweet // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$SetupStateCopyWith<$Res> implements $SetupStateCopyWith<$Res> {
  factory _$SetupStateCopyWith(
          _SetupState value, $Res Function(_SetupState) then) =
      __$SetupStateCopyWithImpl<$Res>;
  @override
  $Res call({bool isFollowingUser, bool isLikedTweet});
}

/// @nodoc
class __$SetupStateCopyWithImpl<$Res> extends _$SetupStateCopyWithImpl<$Res>
    implements _$SetupStateCopyWith<$Res> {
  __$SetupStateCopyWithImpl(
      _SetupState _value, $Res Function(_SetupState) _then)
      : super(_value, (v) => _then(v as _SetupState));

  @override
  _SetupState get _value => super._value as _SetupState;

  @override
  $Res call({
    Object? isFollowingUser = freezed,
    Object? isLikedTweet = freezed,
  }) {
    return _then(_SetupState(
      isFollowingUser: isFollowingUser == freezed
          ? _value.isFollowingUser
          : isFollowingUser // ignore: cast_nullable_to_non_nullable
              as bool,
      isLikedTweet: isLikedTweet == freezed
          ? _value.isLikedTweet
          : isLikedTweet // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_SetupState implements _SetupState {
  const _$_SetupState(
      {this.isFollowingUser = false, this.isLikedTweet = false});

  @JsonKey(defaultValue: false)
  @override
  final bool isFollowingUser;
  @JsonKey(defaultValue: false)
  @override
  final bool isLikedTweet;

  @override
  String toString() {
    return 'SetupState(isFollowingUser: $isFollowingUser, isLikedTweet: $isLikedTweet)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _SetupState &&
            (identical(other.isFollowingUser, isFollowingUser) ||
                const DeepCollectionEquality()
                    .equals(other.isFollowingUser, isFollowingUser)) &&
            (identical(other.isLikedTweet, isLikedTweet) ||
                const DeepCollectionEquality()
                    .equals(other.isLikedTweet, isLikedTweet)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(isFollowingUser) ^
      const DeepCollectionEquality().hash(isLikedTweet);

  @JsonKey(ignore: true)
  @override
  _$SetupStateCopyWith<_SetupState> get copyWith =>
      __$SetupStateCopyWithImpl<_SetupState>(this, _$identity);
}

abstract class _SetupState implements SetupState {
  const factory _SetupState({bool isFollowingUser, bool isLikedTweet}) =
      _$_SetupState;

  @override
  bool get isFollowingUser => throw _privateConstructorUsedError;
  @override
  bool get isLikedTweet => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$SetupStateCopyWith<_SetupState> get copyWith =>
      throw _privateConstructorUsedError;
}
