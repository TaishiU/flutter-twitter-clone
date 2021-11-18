// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'IsLikedState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$IsLikedStateTearOff {
  const _$IsLikedStateTearOff();

  _IsLikedState call({bool isLikedTweet = false}) {
    return _IsLikedState(
      isLikedTweet: isLikedTweet,
    );
  }
}

/// @nodoc
const $IsLikedState = _$IsLikedStateTearOff();

/// @nodoc
mixin _$IsLikedState {
  bool get isLikedTweet => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $IsLikedStateCopyWith<IsLikedState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IsLikedStateCopyWith<$Res> {
  factory $IsLikedStateCopyWith(
          IsLikedState value, $Res Function(IsLikedState) then) =
      _$IsLikedStateCopyWithImpl<$Res>;
  $Res call({bool isLikedTweet});
}

/// @nodoc
class _$IsLikedStateCopyWithImpl<$Res> implements $IsLikedStateCopyWith<$Res> {
  _$IsLikedStateCopyWithImpl(this._value, this._then);

  final IsLikedState _value;
  // ignore: unused_field
  final $Res Function(IsLikedState) _then;

  @override
  $Res call({
    Object? isLikedTweet = freezed,
  }) {
    return _then(_value.copyWith(
      isLikedTweet: isLikedTweet == freezed
          ? _value.isLikedTweet
          : isLikedTweet // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$IsLikedStateCopyWith<$Res>
    implements $IsLikedStateCopyWith<$Res> {
  factory _$IsLikedStateCopyWith(
          _IsLikedState value, $Res Function(_IsLikedState) then) =
      __$IsLikedStateCopyWithImpl<$Res>;
  @override
  $Res call({bool isLikedTweet});
}

/// @nodoc
class __$IsLikedStateCopyWithImpl<$Res> extends _$IsLikedStateCopyWithImpl<$Res>
    implements _$IsLikedStateCopyWith<$Res> {
  __$IsLikedStateCopyWithImpl(
      _IsLikedState _value, $Res Function(_IsLikedState) _then)
      : super(_value, (v) => _then(v as _IsLikedState));

  @override
  _IsLikedState get _value => super._value as _IsLikedState;

  @override
  $Res call({
    Object? isLikedTweet = freezed,
  }) {
    return _then(_IsLikedState(
      isLikedTweet: isLikedTweet == freezed
          ? _value.isLikedTweet
          : isLikedTweet // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_IsLikedState implements _IsLikedState {
  const _$_IsLikedState({this.isLikedTweet = false});

  @JsonKey(defaultValue: false)
  @override
  final bool isLikedTweet;

  @override
  String toString() {
    return 'IsLikedState(isLikedTweet: $isLikedTweet)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _IsLikedState &&
            (identical(other.isLikedTweet, isLikedTweet) ||
                const DeepCollectionEquality()
                    .equals(other.isLikedTweet, isLikedTweet)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(isLikedTweet);

  @JsonKey(ignore: true)
  @override
  _$IsLikedStateCopyWith<_IsLikedState> get copyWith =>
      __$IsLikedStateCopyWithImpl<_IsLikedState>(this, _$identity);
}

abstract class _IsLikedState implements IsLikedState {
  const factory _IsLikedState({bool isLikedTweet}) = _$_IsLikedState;

  @override
  bool get isLikedTweet => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$IsLikedStateCopyWith<_IsLikedState> get copyWith =>
      throw _privateConstructorUsedError;
}
