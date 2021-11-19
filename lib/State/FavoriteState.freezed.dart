// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'FavoriteState.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
class _$FavoriteStateTearOff {
  const _$FavoriteStateTearOff();

  _FavoriteState call({List<Tweet> favoriteTweetList = const <Tweet>[]}) {
    return _FavoriteState(
      favoriteTweetList: favoriteTweetList,
    );
  }
}

/// @nodoc
const $FavoriteState = _$FavoriteStateTearOff();

/// @nodoc
mixin _$FavoriteState {
  List<Tweet> get favoriteTweetList => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FavoriteStateCopyWith<FavoriteState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FavoriteStateCopyWith<$Res> {
  factory $FavoriteStateCopyWith(
          FavoriteState value, $Res Function(FavoriteState) then) =
      _$FavoriteStateCopyWithImpl<$Res>;
  $Res call({List<Tweet> favoriteTweetList});
}

/// @nodoc
class _$FavoriteStateCopyWithImpl<$Res>
    implements $FavoriteStateCopyWith<$Res> {
  _$FavoriteStateCopyWithImpl(this._value, this._then);

  final FavoriteState _value;
  // ignore: unused_field
  final $Res Function(FavoriteState) _then;

  @override
  $Res call({
    Object? favoriteTweetList = freezed,
  }) {
    return _then(_value.copyWith(
      favoriteTweetList: favoriteTweetList == freezed
          ? _value.favoriteTweetList
          : favoriteTweetList // ignore: cast_nullable_to_non_nullable
              as List<Tweet>,
    ));
  }
}

/// @nodoc
abstract class _$FavoriteStateCopyWith<$Res>
    implements $FavoriteStateCopyWith<$Res> {
  factory _$FavoriteStateCopyWith(
          _FavoriteState value, $Res Function(_FavoriteState) then) =
      __$FavoriteStateCopyWithImpl<$Res>;
  @override
  $Res call({List<Tweet> favoriteTweetList});
}

/// @nodoc
class __$FavoriteStateCopyWithImpl<$Res>
    extends _$FavoriteStateCopyWithImpl<$Res>
    implements _$FavoriteStateCopyWith<$Res> {
  __$FavoriteStateCopyWithImpl(
      _FavoriteState _value, $Res Function(_FavoriteState) _then)
      : super(_value, (v) => _then(v as _FavoriteState));

  @override
  _FavoriteState get _value => super._value as _FavoriteState;

  @override
  $Res call({
    Object? favoriteTweetList = freezed,
  }) {
    return _then(_FavoriteState(
      favoriteTweetList: favoriteTweetList == freezed
          ? _value.favoriteTweetList
          : favoriteTweetList // ignore: cast_nullable_to_non_nullable
              as List<Tweet>,
    ));
  }
}

/// @nodoc

class _$_FavoriteState implements _FavoriteState {
  const _$_FavoriteState({this.favoriteTweetList = const <Tweet>[]});

  @JsonKey(defaultValue: const <Tweet>[])
  @override
  final List<Tweet> favoriteTweetList;

  @override
  String toString() {
    return 'FavoriteState(favoriteTweetList: $favoriteTweetList)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _FavoriteState &&
            (identical(other.favoriteTweetList, favoriteTweetList) ||
                const DeepCollectionEquality()
                    .equals(other.favoriteTweetList, favoriteTweetList)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(favoriteTweetList);

  @JsonKey(ignore: true)
  @override
  _$FavoriteStateCopyWith<_FavoriteState> get copyWith =>
      __$FavoriteStateCopyWithImpl<_FavoriteState>(this, _$identity);
}

abstract class _FavoriteState implements FavoriteState {
  const factory _FavoriteState({List<Tweet> favoriteTweetList}) =
      _$_FavoriteState;

  @override
  List<Tweet> get favoriteTweetList => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$FavoriteStateCopyWith<_FavoriteState> get copyWith =>
      throw _privateConstructorUsedError;
}
